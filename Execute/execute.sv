module execute(clk, rst_n, flush, writeregsel_d, read1data, read2data, imm, alu_op, imm_sel, wb_sel_d, write_d, branch_d, result, branch, 
               branch_dec, wb_sel, write, writeregsel);

	input clk, rst_n, flush;
	input [31:0] read1data, read2data, imm;
	input [3:0] alu_op;
	input imm_sel, wb_sel_d, write_d;
	input [1:0] branch_d;
	input [4:0] writeregsel_d;
	
	output logic [31:0] result;
	output logic branch_dec, wb_sel, write;
	output logic [1:0] branch;
	output logic [4:0] writeregsel;
	
	wire [31:0] b, result_d;
	wire branch_dec_d;
	
	assign b = (imm_sel) ? imm : read2data; 
	
	alu alu_DUT (.a(read1data), .b(b), .alu_op(alu_op), .result(result_d), .branch(branch_dec_d));
	
	//////////////////
	// EX/MEM Flops //
	//////////////////
	
	always_ff @(posedge clk)
		writeregsel <=  writeregsel_d;
	
	always_ff @(posedge clk)
		result <= result_d;
		
	always_ff @(posedge clk, negedge rst_n)
		if (!rst_n)
			branch <= 0;
		else if (flush)
			branch <= 0;
		else
			branch <= branch_d;
	
	always_ff @(posedge clk)
		branch_dec <= branch_dec_d;
			
	always_ff @(posedge clk, negedge rst_n)
		if (!rst_n)
			write <= 0;
		else if (flush)
			write <= 0;
		else
			write <= write_d;
	
	always_ff @(posedge clk)
		wb_sel <= wb_sel_d;

endmodule