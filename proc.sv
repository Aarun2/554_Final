module proc(clk, rst_n);

	input clk, rst_n;
	
	wire [31:0] read1data, read2data, imm, result, writedata;
	wire [3:0] alu_op;
	wire jump, branch_instr, imm_sel, branch_dec, wb_sel;
	
	decode decode_proc(.clk(clk), .rst_n(rst_n), .writedata(writedata), .read1data(read1data), .read2data(read2data), .imm_ext(imm), 
		               .alu_op(alu_op), .jump(jump), .branch(branch_instr), .imm_sel(imm_sel), .wb_sel(wb_sel));
	
	execute execute_proc(.read1data(read1data), .read2data(read2data), .imm(imm), .alu_op(alu_op), .imm_sel(imm_sel), 
				         .result(result), .branch(branch_dec));
						 
	writeback wb_proc (.wb_sel(wb_sel), .result(result), .mem_data(), .wb_reg(writedata));

endmodule