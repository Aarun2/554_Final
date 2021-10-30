module execute(read1data, read2data, imm, alu_op, imm_sel, result, branch);

	input [31:0] read1data, read2data, imm;
	input [3:0] alu_op;
	input imm_sel;
	
	output [31:0] result;
	output branch;
	
	wire [31:0] b;
	
	assign b = (imm_sel) ? imm : read2data; 
	
	alu alu_DUT (.a(read1data), .b(b), .alu_op(alu_op), .result(result), .branch(branch));

endmodule