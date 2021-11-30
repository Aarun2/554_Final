`timescale 1ns/1ns
module icache_tb();
	
	logic clk_i, rst_n_i, valid;
	logic [31:0] addr_i, instr_o, instr_check;
	
	logic [31:0] instr_mem [(2**16) - 1:0];
	
	// DUT
	i_cache icache_DUT  (.addr_in_pipeline_i(addr_i), .pipeline_valid_o(valid), .data_out_pipeline_o(instr_o));
	
	initial
		$readmemh("test.txt", instr_mem);
	
	/////////////////////////////////////////////////////////////////
	// Task that reads a random index and checks if read is valid  //
	/////////////////////////////////////////////////////////////////
	task random_fetches();
		addr_i = $random();
		instr_check = instr_mem[addr_i];
		@(posedge clk_i);
		if (instr_check !== instr_o) begin
			$display("Random instr_o fetched from i_cache is not accurate");
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
	task fetch_specific(integer i);
		addr_i = i;
		instr_check = instr_mem[addr_i];
		@(posedge clk_i);
		if (instr_check !== instr_o) begin
			$display("instr_o fetched at specific addr_i: %d, is not accurate", i);
			$stop();
		end
		if (valid != 1) begin
			$display("valid should be high!");
			$stop();
		end
	endtask
		
			   
	initial begin
		clk_i = 0;
		rst_n_i = 0;
		@(posedge clk_i);
		rst_n_i = 1;
		
		// Test 1: Do some random fetches //
		$display("Random Fetches Test");
		for (int i = 0; i < 1000; i++) begin
			random_fetches();
		end
		$display("Random Fetches Test Complete");
		
		// Test 2: Exhaustive fetch of specific addresses //
		$display("Exhaustive Fetch Test");
		for (int i = 0; i < (2**16); i++) begin
			fetch_specific(i);
		end
		$display("Exhaustive Fetch Test Complete");
		
		
		$display("Yahoo Tests Passed!");
		$stop();
	end
	
	always #5 clk_i = ~clk_i;

endmodule