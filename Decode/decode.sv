module decode(clk, rst_n, flush, write_wb, writeregsel_wb, instr, writedata, read1data, read2data, imm_ext, alu_op, 
              imm_sel, wb_sel, write, branch, writeregsel);

	input clk, rst_n, flush, write_wb;
	input [4:0] writeregsel_wb;
	input [31:0] instr, writedata;
	
	output logic [31:0] read1data, read2data;
	output logic [31:0] imm_ext;
	output logic [3:0] alu_op;
	output logic imm_sel, wb_sel, write;
	output logic [1:0] branch;
	output logic [4:0] writeregsel;
	
	logic write_d, imm_sel_d, wb_sel_d;
	logic [14:0] imm;
	logic [31:0] imm_ext_d, read1data_d, read2data_d;
	logic [3:0] alu_op_d;
	logic [1:0] branch_d;
	
	rf reg_file (.clk(clk), .rst_n(rst_n), .read1regsel(instr[19:15]), .read2regsel(instr[14:10]), .write(write_wb), 
			     .writeregsel(writeregsel_wb), .writedata(writedata), .read1data(read1data_d), .read2data(read2data_d));
				 
	control control_inst (.op(instr[31:25]), .alu_op(alu_op_d), .branch(branch_d), .write(write_d), .imm_sel(imm_sel_d),
						  .wb_sel(wb_sel_d));
					 
	extend_15 extension (.imm(imm), .imm_ext(imm_ext_d));
	
	assign imm = branch_d[0] ? {instr[24:20], instr[9:0]} : instr[14:0];
	
	/////////////////
	// ID/EX Flops //
	/////////////////
	
	always_ff @(posedge clk)
		writeregsel <= instr[24:20];
	
	always_ff @(posedge clk)
		read1data <=  read1data_d;
	
	always_ff @(posedge clk)
		read2data <= read2data_d;
	
	always_ff @(posedge clk)
		imm_ext <= imm_ext_d;
	
	always_ff @(posedge clk)
		alu_op <= alu_op_d;
	
	always_ff @(posedge clk)
		imm_sel <= imm_sel_d;

	always_ff @(posedge clk)
		wb_sel <= wb_sel_d;
		
	always_ff @(posedge clk, negedge rst_n)
		if (!rst_n)
			write <= 0;
		else if (flush)
			write <= 0;
		else
			write <= write_d;
	
	always_ff @(posedge clk, negedge rst_n)
		if (!rst_n)
			branch <= 0;
		else if (flush)
			branch <= 0;
		else
			branch <= branch_d;
		
endmodule