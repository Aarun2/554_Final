module extend_15
	(
	 input imm_i, 
	 output imm_ext_i);

    assign imm_ext_i = {{17{imm[14]}}, imm_i};

endmodule