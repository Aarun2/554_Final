module i_cache
	#(
	parameter PC_BITS = 16
	)
	(
	input clk_i, rst_n_i,
	input [PC_BITS-1:0] addr_i,
	output [PC_BITS-1:0] instr_o
	);
	
	logic [PC_BITS-1:0] instr_mem [(2**PC_BITS) - 1:0];
	
	assign instr_o = instr_mem[addr_i];
	
	initial	
		$readmemh("test_icache.txt", instr_mem);

endmodule