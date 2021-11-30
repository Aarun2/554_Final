module i_cache
	(
	input [31:0] addr_in_pipeline_i,
	output pipeline_valid_o,
	output [31:0] data_out_pipeline_o
	);
	
	logic [31:0] instr_mem [(2**16) - 1:0];
	
	assign data_out_pipeline_o = instr_mem[addr_in_pipeline_i];
	assign pipeline_valid_o = 1; // dummy cache always 1
	
	initial	
		$readmemh("test.txt", instr_mem);

endmodule