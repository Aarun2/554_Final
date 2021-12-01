`timescale 1ns/1ns
module fetch_tb();

	logic clk_i, rst_n_i, stall_i, branch_i, flush_i, data_cache_valid_i, stall_o;
	logic [31:0] pc_i, pc_o, instr_o, addr_to_cache_o, data_from_cache_i;
	
	logic [31:0] pc_check, pc_prev, instr_check, stall_check;
	
	fetch fetch_DUT (.clk_i(clk_i), .rst_n_i(rst_n_i), .instr_o(instr_o), .pc_i(pc_i), 
										.pc_o(pc_o), .branch_i(branch_i), .stall_i(stall_i), .flush_i(flush_i),
										.data_cache_valid_i(data_cache_valid_i), .data_from_cache_i(data_from_cache_i),
										.addr_to_cache_o(addr_to_cache_o), .stall_o(stall_o));
	
	////////////////////////////////////////////////////////////////////
	// Init task
	////////////////////////////////////////////////////////////////////
	task init();
		clk_i = 0;
		rst_n_i = 1'b1;
		@(posedge clk_i);
		rst_n_i = 1'b0;
		stall_i = 1'b0;
		branch_i = 1'b0;
		flush_i = 1'b0;
		data_cache_valid_i = 1'b1; // always valid
		data_from_cache_i = 0;
		@(posedge clk_i);
		rst_n_i = 1'b1;
	endtask
	
	////////////////////////////////////////////////////////////////////
	// Task that tests random PC inputs for branch_i condition and checks for correct output //
	////////////////////////////////////////////////////////////////////
	task random_pcIn();
		@(posedge clk_i);
		branch_i = 1'b1;
		stall_i = 1'b0;
		pc_i = $random();
		pc_check = pc_i + 4;
		repeat (3) @(posedge clk_i);
		if (pc_check !== pc_o) begin
			$display("Random pc_i was not incremented correctly	%h %h", pc_check, pc_o);
			$stop();
		end
	endtask
	
	////////////////////////////////////////////////////////////////////
	// Task that exhaustively tests PC inputs for branch_i condition    //
	////////////////////////////////////////////////////////////////////
	task exhaustive_pcIn(integer i);
		@(posedge clk_i);
		branch_i = 1'b1;
		stall_i = 1'b0;
		pc_i = i;
		pc_check = pc_i + 4;
		repeat (3) @(posedge clk_i);
		if (pc_check !== pc_o) begin
			$display("pc_i was not incremented correctly	%h %h", pc_check, pc_o);
			$stop();
		end
	endtask
	
	///////////////////////////////////////////////////////////////////////////
	// Task checks when branch_i signal is low, pc_i has no impact on pc_o   //
	// This doubles as making sure the PC increments by 4 each cycle				//
	//////////////////////////////////////////////////////////////////////////
	task branch_is_low_pcIn();
		branch_i = 1'b0;
		stall_i = 1'b0;
		pc_i = $random();
		repeat (2) @(posedge clk_i);
		pc_check = pc_o + 4;
		@(posedge clk_i);
		if (pc_check !== pc_o) begin
			$display("err: pc_i should have no impact when branch_i is low %d %d", pc_check, pc_o);
			$stop();
		end
	endtask
	
	////////////////////////////////////////////////////////////////////
	// Task that checks stall_i does not change pc   //
	////////////////////////////////////////////////////////////////////
	task stall_test();
		stall_i = 1'b1;
		@(posedge clk_i);
		pc_prev = pc_o;
		@(posedge clk_i);
		if (pc_o !== pc_prev) begin
			$display("err: stall_i should not allow pc to change!!");
			$stop();
		end
	endtask
	
	///////////////////////////////////////////////////////////////////////////////////
	// Task that performs random instr fetches and makes sure it gets correct instr  //
	///////////////////////////////////////////////////////////////////////////////////
	task random_fetch();
		stall_i = 1'b0;
		data_cache_valid_i = 1;
		data_from_cache_i = $random();
		instr_check = data_from_cache_i;
		repeat (2) @(posedge clk_i);
		if (instr_o !== instr_check) begin
			$display("err: random instr incorrectly fetched (expected:)%d (actual:)%d",instr_check, instr_o);
			$stop();
		end
	endtask
	
	///////////////////////////////////////////////////////////////////////////////////
	// Exhaustive Fetch test  																											//
	///////////////////////////////////////////////////////////////////////////////////
	task exhaustive_fetch(integer i);
		data_cache_valid_i = 1;
		data_from_cache_i = i;
		instr_check = i;
		repeat(2) @(posedge clk_i);
		if (instr_o !== instr_check) begin
			$display("err: instr incorrectly fetched (expected:)%d (actual:)%d",instr_check, instr_o);
			$stop();
		end
	endtask
	
	///////////////////////////////////////////////////////////////////////////////////
	// Tests flush to make the control signal pushes NOPS to the instr output of fetch//
	///////////////////////////////////////////////////////////////////////////////////
	task flush_test();
		stall_i = 1'b0;
		flush_i = 1'b1;
		repeat(2) @(posedge clk_i);
		if (instr_o !== 0) begin
			$display("err: flush should force instr to 0 (NOP)");
			$stop();
		end
	endtask
	
		///////////////////////////////////////////////////////////////////////////////////
	// Tests data_cache_valid_i to make the control signal pushes NOPS to the instr		// 
	// output of fetch (same concept as flush test above															//
	///////////////////////////////////////////////////////////////////////////////////
	task cache_valid_test();
		stall_i = 1'b0;
		flush_i = 1'b0;
		data_cache_valid_i = 1'b0;
		repeat(2) @(posedge clk_i);
		if (instr_o !== 0) begin
			$display("err: invalid cache should force instr to 0 (NOP)");
			$stop();
		end
	endtask
	
	
	// MAIN SEGMENT OF TB
	initial begin
		//Set up signals
		init();
		
		// Test 1: Do some random pcIns //
		$display("Random pc_i Test");
		for (int i = 0; i < 1000; i++) begin
			random_pcIn();
		end
		$display("Random pc_i Test Complete");
		
		// Test 2: Exhaustive pcIns //
		$display("Exhaustiv pc_i Test");
		for (int i = 0; i < 2**16; i++) begin
			exhaustive_pcIn(i);
		end
		$display("Exhaustive pc_i Test Complete");
		
		// Test 3: pc_i has no impact when branch_i is low  and pc incs by 4 each cycle//
		$display("pc_i no impact Test");
		for (int i = 0; i < 1000; i++) begin
			branch_is_low_pcIn();
		end
		$display("pc_i no impact Test Complete");
		
		// Test 4: Make sure stall_i does not allow PC to change //
		$display("stall_i Test");
		for (int i = 0; i < 1000; i++) begin
			stall_test();
		end
		$display("stall_i Test Complete");
		
		// Test 5: Reset Memory Test //
		$display("Memory Reset Test");
		rst_n_i = 0;
		stall_i = 1'b0;
		@(posedge clk_i);
		rst_n_i = 1;
		repeat(2) @(posedge clk_i);
		if (pc_o !== 4) begin
			$display("Err: reset should make PC go to 4! (because of adder after flop)");
			$stop();
		end
		$display("Memory Reset Test Complete");
		
		// Test 6: random fetches
		$display("Random Fetch Test");
		for (int i = 0; i < 1000; i++) begin
			random_fetch();
		end
		$display("Random Fetch Test Complete");
		
		// Test 7: exhaustive fetches
		$display("Exhaustive Fetch Test");
		for (int i = 0; i < 2**16; i++) begin
			exhaustive_fetch(i);
		end
		$display("Exhaustive Fetch Test Complete");
		
		// Test 8: flush test
		$display("Flush Test");
		for (int i = 0; i < 1000; i++) begin
			data_from_cache_i = $random();
			flush_test();
		end
		$display("Flush Test Complete");
		
		// Test 9: cache valid test
		$display("Cache Valid Test");
		for (int i = 0; i < 1000; i++) begin
			data_from_cache_i = $random();
			cache_valid_test();
		end
		$display("Cache Valid Test Complete");

		// TESTS COMPLETE
		$display("Yahoo Tests Passed!");
		// TODO: Figure out the valid check part. 
		// Also add flush check
		$stop();
	end
	
	always #5 clk_i = ~clk_i;

endmodule