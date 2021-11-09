module decode #(parameter PC_BITS = 16) (clk, rst_n, flush, write_wb, writeregsel_wb, instr, writedata, pc_d, read1data, 
										 read2data, imm_ext, alu_op, pc, imm_sel, wb_sel, m_write, write, branch, writeregsel);

	input clk, rst_n, flush, write_wb;
	input [4:0] writeregsel_wb;
	input [31:0] instr, writedata;
	input [PC_BITS-1:0] pc_d;
	
	output logic [31:0] read1data, read2data;
	output logic [31:0] imm_ext;
	output logic [3:0] alu_op;
	output logic imm_sel, wb_sel, write, m_write;
	output logic [1:0] branch;
	output logic [4:0] writeregsel;
	output logic [PC_BITS-1:0] pc;
	
	logic write_d, imm_sel_d, wb_sel_d, m_write_d;
	logic [14:0] imm;
	logic [31:0] imm_ext_d, read1data_d, read2data_d;
	logic [3:0] alu_op_d;
	logic [1:0] branch_d;
	
	rf reg_file (.clk(clk), .rst_n(rst_n), .read1regsel(instr[19:15]), .read2regsel(instr[14:10]), .write(write_wb), 
			     .writeregsel(writeregsel_wb), .writedata(writedata), .read1data(read1data_d), .read2data(read2data_d));
				 
	control control_inst (.op(instr[31:25]), .alu_op(alu_op_d), .branch(branch_d), .write(write_d), .imm_sel(imm_sel_d),
						  .wb_sel(wb_sel_d), .m_write(m_write_d));
					 
	extend_15 extension (.imm(imm), .imm_ext(imm_ext_d));
	
	assign imm = branch_d[0] ? {instr[24:20], instr[9:0]} : instr[14:0];
	
	/////////////////
	// ID/EX Flops //
	/////////////////
	
	always_ff @(posedge clk)
		pc <= pc_d;
	
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
			m_write <= 0;
		else if (flush)
			m_write <= 0;
		else
			m_write <= m_write_d;
	
	always_ff @(posedge clk, negedge rst_n)
		if (!rst_n)
			branch <= 0;
		else if (flush)
			branch <= 0;
		else
			branch <= branch_d;
		
endmodule