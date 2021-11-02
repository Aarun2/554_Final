module decode(clk, rst_n, flush, write_reg, instr, writedata, read1data, read2data, imm_ext, alu_op, imm_sel, wb_sel, write, branch);

	input clk, rst_n, flush, write_reg;
	input [31:0] instr, writedata;
	
	output [31:0] read1data, read2data;
	output logic [31:0] imm_ext;
	output logic [3:0] alu_op;
	output logic imm_sel, wb_sel, write;
	output logic [1:0] branch;
	
	logic write_in, imm_sel_in, wb_sel_in;
	logic [14:0] imm;
	logic [31:0] imm_ext_in;
	logic [3:0] alu_op_in;
	logic [1:0] branch_in;
	
	rf reg_file (.clk(clk), .rst_n(rst_n), .read1regsel(instr[19:15]), .read2regsel(instr[14:10]), .write(write_reg), 
			     .writeregsel(instr[24:20]), .writedata(writedata), .read1data(read1data), .read2data(read2data));
				 
	control control_inst (.op(instr[31:25]), .alu_op(alu_op_in), .branch(branch_in), .write(write_in), .imm_sel(imm_sel_in),
						  .wb_sel(wb_sel_in));
					 
	extend_15 extension (.imm(imm), .imm_ext(imm_ext_in));
	
	assign imm = branch_in[0] ? {instr[24:20], instr[9:0]} : instr[14:0];
	
	always_ff @(posedge clk)
		imm_ext <= imm_ext_in;
	
	always_ff @(posedge clk)
		alu_op <= alu_op_in;
	
	always_ff @(posedge clk)
		imm_sel <= imm_sel_in;

	always_ff @(posedge clk)
		wb_sel <= wb_sel_in;
		
	always_ff @(posedge clk, negedge rst_n)
		if (!rst_n)
			write <= 0;
		else if (flush)
			write <= 0;
		else
			write <= write_in;
	
	always_ff @(posedge clk, negedge rst_n)
		if (!rst_n)
			branch <= 0;
		else if (flush)
			branch <= 0;
		else
			branch <= branch_in;
		
endmodule