`timescale 1ns/1ns
module icache_tb();

	localparam PC_BITS = 16;
	
	logic clk, rst_n;
	logic [PC_BITS-1:0] addr, instr, instrCheck;
	
	reg [PC_BITS-1:0] instrMem [(2**PC_BITS) - 1:0];
	
	i_cache icache_DUT (.clk(clk), .rst_n(rst_n), .addr(addr), .instr(instr));
	
	initial
		
		$readmemh("test_icache.txt", instrMem);
	
	/////////////////////////////////////////////////////////////////
	// Task that reads a random index and checks if read is valid  //
	/////////////////////////////////////////////////////////////////
	task random_fetches();
		addr = $random();
		instrCheck = instrMem[addr];
		@(posedge clk);
		if (instrCheck !== instr) begin
			$display("Random instr fetched from i_cache is not accurate");
			$stop();
		end
	endtask
	
	//////////////////////////////////////////////////////////////////////////////////////
	// Task that reads from first select line at a specific index and checks if correct //
	//////////////////////////////////////////////////////////////////////////////////////
	task fetch_specific(integer i);
		addr = i;
		instrCheck = instrMem[addr];
		@(posedge clk);
		if (instrCheck !== instr) begin
			$display("Instr fetched at specific addr: %d, is not accurate", i);
			$stop();
		end
	endtask
		
			   
	initial begin
		clk = 0;
		rst_n = 0;
		@(posedge clk);
		rst_n = 1;
		
		// Test 1: Do some random fetches //
		$display("Random Fetches Test");
		for (int i = 0; i < 1000; i++) begin
			random_fetches();
		end
		$display("Random Fetches Test Complete");
		
		// Test 2: Exhaustive fetch of specific addresses //
		$display("Exhaustive Fetch Test");
		for (int i = 0; i < (2**PC_BITS); i++) begin
			fetch_specific(i);
		end
		$display("Exhaustive Fetch Test Complete");
		
		
		$display("Yahoo Tests Passed!");
		$stop();
	end
	
	always #5 clk = ~clk;

endmodule