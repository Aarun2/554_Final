module decode #(parameter PC_BITS = 16) 
	(
	 input clk_i, rst_n_i, flush_i, reg_write_enable_i, 
	 [4:0] write_reg_sel_i, [31:0] instr_i, [3:0] write_data_i, [31:0] pc_i, 
	 output logic [31:0] read_data_1_o, [31:0] read_data_2_o, [31:0] imm_o, 
	 [3:0] alu_op_o, imm_sel_o, [1:0] wb_sel_o, reg_write_enable_o, 
	 mem_write_enable_o, [1:0] branch_type_o, [4:0] write_reg_sel_o, 
	 [31:0] pc_o, write_enable_A_o, write_enable_B_o, write_enable_C_o, start_o,
	 [4:0] col_o, [4:0] row_o, [4:0] d_op2_reg_o, [4:0] d_op1_reg_o
	);
	
	
	logic write_d, imm_sel_d, m_write_d;
	logic [14:0] imm;
	logic [31:0] imm_ext_d, read1data_d, read2data_d;
	logic [3:0] alu_op_d;
	logic [1:0] branch_d, wb_sel_d;
	
	rf reg_file (.clk_i(clk_i), .rst_n_i(rst_n_i), .read_reg1_sel_i(instr[19:15]), .read_reg2_sel_i(instr[14:10]), .write_enable_i(reg_write_enable_i), 
			     .write_reg_sel_i(write_reg_sel_i), .write_data_i(write_data_i), .read_data1_o(read_data_1_d), .read_data2_o(read_data_2_d));
				 
	control control_inst (.op(instr_i[31:25]), .alu_op(alu_op_d), .branch(branch_d), .write(write_d), .imm_sel(imm_sel_d),
						  .wb_sel(wb_sel_d), .m_write(m_write_d));
					 
	extend_15 extension (.imm(imm), .imm_ext(imm_ext_d));
	
	assign imm = branch_d[0] ? {instr[24:20], instr[9:0]} : instr[14:0];
	
	/////////////////
	// ID/EX Flops //
	/////////////////
	
	always_ff @(posedge clk)
		pc <= pc_d;
	
	always_ff @(posedge clk, negedge rst_n)
		writeregsel <= instr[24:20];
	
	always_ff @(posedge clk)
		read_data_1_o <=  read_data_1_d;
	
	always_ff @(posedge clk)
		read_data_2_o <= read_data_2_o;
	
	always_ff @(posedge clk)
		imm_ext <= imm_ext_d;
	
	always_ff @(posedge clk)
		alu_op <= alu_op_d;
	
	always_ff @(posedge clk)
		imm_sel <= imm_sel_d;

	always_ff @(posedge clk)
		wb_sel <= wb_sel_d;
		
	always_ff @(posedge clk, negedge rst_n_i)
		if (!rst_n_i)
			write <= 0;
		else if (flush)
			write <= 0;
		else
			write <= write_d;
	
	always_ff @(posedge clk, negedge rst_n_i)
		if (!rst_n_i)
			m_write <= 0;
		else if (flush)
			m_write <= 0;
		else
			m_write <= m_write_d;
	
	always_ff @(posedge clk, negedge rst_n_i)
		if (!rst_n_i)
			branch <= 0;
		else if (flush)
			branch <= 0;
		else
			branch <= branch_d;
		
endmodule