`timescale 1ns/1ns
module dcache_tb();
	
	logic clk_i, rst_n_i, pipeline_valid_o, write;
	logic [31:0] addr_i, data_o, data_i;
	
	logic [31:0] data_mem [(2**16) - 1:0];
	
	// DUT
	d_cache dcache_DUT  (.clk_i(clk_i), .rst_n_i(rst_n_i), .addr_in_pipeline_i(addr_i), .pipeline_valid_o(valid), 
												.data_out_pipeline_o(data_o), .data_in_pipeline_i(data_i), .pipeline_write_valid_i(write));
	
	/////////////////////////////////////////////////////////////////
	// Task that reads a random index and checks if read is valid  //
	/////////////////////////////////////////////////////////////////
	task random_reads();
		addr_i = $random();
		write = 1'b0;
		@(posedge clk_i);
		if (data_mem[addr_i] !== data_o) begin
			$display("Random read from d_cache not accurate");
			$stop();
		end
		if (valid != 1) begin
			$display("valid should be high!");
			$stop();
		end
	endtask
	
	////////////////////////////////////////////////////////////////////////////////////////////
	// Task that performs random writes to dummy cache and then checks with read at that addr //
	////////////////////////////////////////////////////////////////////////////////////////////
	task random_writes();
		addr_i = $random();
		data_i = $random();
		write = 1'b1;
		data_mem[addr_i] = data_i;
		@(posedge clk_i);
		write = 1'b0;
		@(posedge clk_i);
		if(data_mem[addr_i] !== data_o) begin
			$display("data_o written incorrectly at random addr (expected: %d ) , (actual: %d )", data_mem[addr_i], data_o);
			$stop();
		end
		if (valid != 1) begin
			$display("valid should be high!");
			$stop();
		end
	endtask
	
	//////////////////////////////////////////////////////////////////////////////////////
	// Task that reads from first select line at a specific index and checks if correct //
	//////////////////////////////////////////////////////////////////////////////////////
	task read_specific(integer i);
		addr_i = i;
		@(posedge clk_i);
		if (data_mem[addr_i] !== data_o) begin
			$display("data_o read at specific addr_i: %d, is not accurate", i);
			$stop();
		end
		if (valid != 1) begin
			$display("valid should be high!");
			$stop();
		end
	endtask
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	// Task that performs specific writes to dummy cache and then checks with read at that addr //
	//////////////////////////////////////////////////////////////////////////////////////////////
	task exhaustive_writes(integer i);
		addr_i = i;
		data_i = $random();
		write = 1'b1;
		data_mem[addr_i] = data_i;
		@(posedge clk_i);
		write = 1'b0; //read
		@(posedge clk_i);
		if (data_mem[addr_i] !== data_o) begin
			$display("data_o written at specific addr_i: %d, is not accurate", i);
			$stop();
		end
		if (valid != 1) begin
			$display("valid should be high!");
			$stop();
		end
	endtask
	
			   
	initial begin
		$readmemh("test.txt", data_mem);
		clk_i = 0;
		rst_n_i = 0;
		@(posedge clk_i);
		rst_n_i = 1;
		write = 1'b0;
		// Test 1: Do some random reads //
		$display("Random Reads Test");
		for (int i = 0; i < 1000; i++) begin
			random_reads();
		end
		$display("Random Reads Test Complete");
		
		// Test 2: Exhaustive fetch of specific addresses //
		$display("Exhaustive Read Test");
		for (int i = 0; i < (2**16); i++) begin
			read_specific(i);
		end
		$display("Exhaustive Reads Test Complete");
		
		// Test 3: Do some random writes followed by a read to confirm//
		$display("Random Writes Test");
		for (int i = 0; i < 1000; i++) begin
			random_writes();
		end
		$display("Random Writes Test Complete");
		
		// Test 4: Do some random data writes to specific addrs followed by a read to confirm//
		$display("Exhaustive Writes Test");
		for (int i = 0; i < 2**32; i++) begin
			exhaustive_writes(i);
		end
		$display("Exhaustive Writes Test Complete");
		
		// TESTS COMPLETE
		$display("Yahoo Tests Passed!");
		$stop();
	end
	
	always #5 clk_i = ~clk_i;

endmodule