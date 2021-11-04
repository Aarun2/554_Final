module i_cache(clk, rst_n, addr, instr);
	
	localparam PC_BITS = 16;
	
	input clk, rst_n; //left in for now in case things change in the future
	input [PC_BITS-1:0] addr;
	output [PC_BITS-1:0] instr;
	
	reg [PC_BITS-1:0] instrMem [(2**PC_BITS) - 1:0];
	
	assign instr = instrMem[addr];
	
	initial	
		$readmemh("test_icache.txt", instrMem);

endmodule