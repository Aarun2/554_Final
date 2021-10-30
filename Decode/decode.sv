module decode(clk, rst_n, writedata, read1data, read2data, imm_ext, alu_op, jump, branch, imm_sel, wb_sel);

	input clk, rst_n;
	input [31:0] instr, writedata;
	
	output [31:0] read1data, read2data, imm_ext;
	output [3:0] alu_op;
	output jump, branch, imm_sel, wb_sel;
	
	wire write;
	wire [14:0] imm;
	
	rf reg_file (.clk(clk), .rst_n(rst_n), .read1regsel(instr[19:15]), .read2regsel(instr[14:10]), .write(write), 
			     .writeregsel(instr[24:20]), .writedata(writedata), .read1data(read1data), .read2data(read2data));
				 
	control control_inst (.op(instr[31:25]), .alu_op(alu_op), .jump(jump), .branch(branch), .write(write), .imm_sel(imm_sel)
						  .wb_sel(wb_sel));
	
	assign imm = (branch) ? {instr[24:20], instr[9:0]} : instr[14:0];
				 
	extend_15 extension (.imm(imm), .imm_ext(imm_ext));

endmodule