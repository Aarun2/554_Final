module execute(clk, rst_n, flush, read1data, read2data, imm, alu_op, imm_sel, wb_sel_in, write_in, branch_in, result, branch, 
               branch_dec, wb_sel, write);

	input clk, rst_n, flush;
	input [31:0] read1data, read2data, imm;
	input [3:0] alu_op;
	input imm_sel, wb_sel_in, write_in, branch_in;
	
	output logic [31:0] result;
	output logic branch, branch_dec, wb_sel, write;
	
	wire [31:0] b, result_in;
	wire branch_dec_in;
	
	assign b = (imm_sel) ? imm : read2data; 
	
	alu alu_DUT (.a(read1data), .b(b), .alu_op(alu_op), .result(result_in), .branch(branch_dec_in));
	
	always_ff @(posedge clk)
		result <= result_in;
		
	always_ff @(posedge clk, negedge rst_n)
		if (!rst_n)
			branch <= 0;
		else if (flush)
			branch <= 0;
		else
			branch <= branch_in;
	
	always_ff @(posedge clk)
		branch_dec <= branch_dec_in;
			
	always_ff @(posedge clk, negedge rst_n)
		if (!rst_n)
			write <= 0;
		else if (flush)
			write <= 0;
		else
			write <= write_in;
	
	always_ff @(posedge clk)
		wb_sel <= wb_sel_in;

endmodule