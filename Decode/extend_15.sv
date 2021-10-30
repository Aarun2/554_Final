module extend_15(imm, imm_ext);

	input [14:0] imm;
    output [31:0] imm_ext;

    assign imm_ext = {{17{imm[14]}}, imm};

endmodule