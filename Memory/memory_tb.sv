`timescale 1ns/1ns
module memory_tb();

	// "Inputs"
	logic clk_i, rst_n_i; 
	logic flush_i, stall_i;
	logic mem_write_en_i, reg_write_en_i, forward_en_i, data_cache_valid_i;	
	logic [1:0] wb_sel_i;
	logic [4:0] reg_write_dst_i;
	logic [31:0] cout_i, result_i, read_data_2_i, forward_data_i, data_from_cache_i;
	// "Outputs"
	logic reg_write_en_o; // pass through 
	logic wr_to_cache_o, stall_o;
	logic [1:0] wb_sel_o; // pass through
	logic [4:0] reg_write_dst_o; // pass through
	logic [31:0] result_o, cout_o; // pass through
	logic [31:0] read_data_o, data_to_cache_o, addr_to_cache_o;
	
	// used for comparisons
	logic wr_prev;
	logic [31:0] data_prev, addr_prev;
	
	memory memory_DUT (
		.clk_i(clk_i), 
		.rst_n_i(rst_n_i), 
		.flush_i(flush_i), 
		.stall_i(stall_i),
		.mem_write_en_i(mem_write_en_i), 
		.reg_write_en_i(reg_write_en_i), 
		.forward_en_i(forward_en_i),
		.data_cache_valid_i(data_cache_valid_i), 
		.wb_sel_i(wb_sel_i), 
		.reg_write_dst_i(reg_write_dst_i),
		.cout_i(cout_i),
		.result_i(result_i),
		.read_data_2_i(read_data_2_i),
		.forward_data_i(forward_data_i),
		.data_from_cache_i(data_from_cache_i),
		.reg_write_en_o(reg_write_en_o),
		.wr_to_cache_o(wr_to_cache_o),
		.stall_o(stall_o),
		.wb_sel_o(wb_sel_o),
		.reg_write_dst_o(reg_write_dst_o),
		.result_o(result_o),
		.cout_o(cout_o),
		.read_data_o(read_data_o),
		.data_to_cache_o(data_to_cache_o),
		.addr_to_cache_o(addr_to_cache_o)
	);
	
	////////////////////////////////////////////////////////////////////
	// Init task
	////////////////////////////////////////////////////////////////////
	task init();
		clk_i = 0;
		rst_n_i = 1'b1;
		@(posedge clk_i);
		// default values input to DUT when starting simulation
		rst_n_i = 1'b0;
		stall_i = 1'b0;
		flush_i = 1'b0;
		mem_write_en_i = 1'b0;
		reg_write_en_i = 0;
		forward_en_i = 0;
		data_cache_valid_i = 1'b1; // always valid
		wb_sel_i = 2'b00;	// 2 bit 
		reg_write_dst_i = 5'h00; // 5 bit
		cout_i = 0;	// 32 bit for the rest
		result_i = 0;
		read_data_2_i = 0;
		forward_data_i = 0;
		data_from_cache_i = 0;
		@(posedge clk_i);
		rst_n_i = 1'b1;
	endtask
	
	////////////////////////////////////////////////////////////////////
	// Task that checks all inputs pipelined through match on the output //
	////////////////////////////////////////////////////////////////////
	task pass_through_checks();
		@(posedge clk_i);
		reg_write_en_i = $random();
		wb_sel_i = $random();
		reg_write_dst_i = $random();
		result_i = $random();
		cout_i = $random();
		@(posedge clk_i);
		@(posedge clk_i);
		if (reg_write_en_i !== reg_write_en_o) begin
			$display("reg_write_en_i not passed through pipeline correctly (Expected: %h, Actual: %h", reg_write_en_i, reg_write_en_o);
			$stop();
		end
		if (wb_sel_i !== wb_sel_o) begin
			$display("wb_sel_i not passed through pipeline correctly (Expected: %h, Actual: %h", wb_sel_i, wb_sel_o);
			$stop();
		end
		if (reg_write_dst_i !== reg_write_dst_o) begin
			$display("reg_write_dst_i not passed through pipeline correctly (Expected: %h, Actual: %h", reg_write_dst_i, reg_write_dst_o);
			$stop();
		end
		if (result_i !== result_o) begin
			$display("result_i not passed through pipeline correctly (Expected: %h, Actual: %h",result_i, result_o);
			$stop();
		end
		if (cout_i !== cout_o) begin
			$display("cout_i not passed through pipeline correctly (Expected: %h, Actual: %h", cout_i, cout_o);
			$stop();
		end
	endtask	
	
		////////////////////////////////////////////////////////////////////
	// Task that checks data read from D cache is flopped into pipeline //
	////////////////////////////////////////////////////////////////////
	task read_tests();
		@(posedge clk_i);
		data_from_cache_i = $random();
		@(posedge clk_i);
		@(posedge clk_i);
		if (read_data_o !== data_from_cache_i) begin
			$display("read_data_o incorrect (Expected: %h, Actual: %h", data_from_cache_i, read_data_o);
			$stop();
		end
	endtask
	
		/////////////////////////////////////////////////////////////////////////////////////////////
	// Task that checks random writes, and also checks for correct read_data_o following a write //
	////////////////////////////////////////////////////////////////////////////////////////////////
	task write_tests();
		@(posedge clk_i);
		read_data_2_i = $random();
		result_i = $random();
		mem_write_en_i = 1;
		@(posedge clk_i);
		if (data_to_cache_o !== read_data_2_i) begin
			$display("wr_to_cache_o incorrect (Expected: %h, Actual: %h", read_data_2_i, data_to_cache_o);
			$stop();
		end
		if (wr_to_cache_o !== mem_write_en_i) begin
			$display("wr_to_cache_o incorrect (Expected: %h, Actual: %h", mem_write_en_i, wr_to_cache_o);
			$stop();
		end
		if (addr_to_cache_o !== result_i) begin
			$display("addr_to_cache_o incorrect (Expected: %h, Actual: %h", result_i, addr_to_cache_o);
			$stop();
		end
		@(posedge clk_i);
		mem_write_en_i = 0;
		@(posedge clk_i);
		if (wr_to_cache_o !== mem_write_en_i) begin
			$display("wr_to_cache_o incorrect (Expected: %h, Actual: %h", mem_write_en_i, wr_to_cache_o);
			$stop();
		end
		@(posedge clk_i);
		// check stalls and flushes
		flush_i = 1'b1;
		@(posedge clk_i);
		if (data_to_cache_o !== 0) begin
			$display("data_to_cache_o should be 0 (Actual: %h",data_to_cache_o);
			$stop();
		end
		if (wr_to_cache_o !== 0) begin
			$display("wr_to_cache_o should be 0 (Actual: %h",wr_to_cache_o);
			$stop();
		end
		if (addr_to_cache_o !== 0) begin
			$display("addr_to_cache_o should be 0 (Actual: %h",addr_to_cache_o);
			$stop();
		end
		data_prev = data_to_cache_o;
		addr_prev = addr_to_cache_o;
		wr_prev = addr_to_cache_o;
		@(posedge clk_i);
		flush_i = 1'b0;
		stall_i = 1'b1;
		repeat (20) @(posedge clk_i);
			if (data_to_cache_o !== data_prev) begin
			$display("wr_to_cache_o incorrect (Expected: %h, Actual: %h", data_prev, data_to_cache_o);
			$stop();
		end
		if (wr_to_cache_o !== wr_prev) begin
			$display("wr_to_cache_o incorrect (Expected: %h, Actual: %h", wr_prev, wr_to_cache_o);
			$stop();
		end
		if (addr_to_cache_o !== addr_prev) begin
			$display("addr_to_cache_o incorrect (Expected: %h, Actual: %h", addr_prev, addr_to_cache_o);
			$stop();
		end
		stall_i = 1'b0;
		
	endtask
	
	
	// MAIN SEGMENT OF TB
	initial begin
		//Set up signals
		init();
		
		// Test 1: Do some pass through checks //
		$display("Pass Through Checks Test");
		for (int i = 0; i < 1000; i++) begin
			pass_through_checks();
		end
		$display("Pass Through Checks Test Complete");
	
		// Test 2: Random reads //
		$display("Random Reads Test");
		for (int i = 0; i < 1000; i++) begin
			read_tests();
		end
		$display("Random Reads Test Complete");
		
		// Test 3: Random writes //
		$display("Random Writes Test");
		for (int i = 0; i < 1000; i++) begin
			write_tests();
		end
		$display("Random Writes Test Complete");
	
		// TESTS COMPLETE
		$display("Yahoo Tests Passed!");
		$stop();
	end
	
	always #5 clk_i = ~clk_i;

endmodule