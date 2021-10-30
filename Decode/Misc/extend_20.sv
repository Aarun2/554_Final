module extend_20(imm, imm_ext);
    input [19:0] imm;
    output [31:0] imm_ext;

    assign imm_ext = {{12{imm[19]}}, imm};

endmodule