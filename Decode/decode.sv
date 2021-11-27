module decode
	(
	 input clk_i, rst_n_i, flush_i, reg_write_enable_i, stall_i,
	 input [4:0] write_reg_sel_i, 
	 input [31:0] instr_i, write_data_i, pc_i, 
	 output logic imm_sel_o, reg_write_enable_o, mem_write_enable_o,
	 output logic write_enable_A_o, write_enable_B_o, write_enable_C_o, start_o,
	 output logic [31:0] read_data1_o, read_data2_o, imm_o, pc_o,
	 output logic [3:0] alu_op_o, 
	 output logic [1:0] wb_sel_o, branch_type_o, 
	 output logic [4:0] write_reg_sel_o, col_o, row_o, d_op2_reg_o, d_op1_reg_o
	);
	
	logic write_d, imm_sel_d, m_write_d;
	logic [14:0] imm;
	logic [31:0] imm_ext_d, read_data1_d, read_data2_d;
	logic [3:0] alu_op_d;
	logic [1:0] branch_d, wb_sel_d;
	logic [4:0] col_d, row_d, d_op2_reg_d, d_op1_reg_d;
	logic tpu_start_d, tpu_wren_A_d, tpu_wren_B_d, tpu_wren_C_d;
	
	rf reg_file (.clk_i(clk_i), .rst_n_i(rst_n_i), .read_reg1_sel_i(instr_i[19:15]), .read_reg2_sel_i(instr_i[14:10]), .write_enable_i(reg_write_enable_i), 
			     .write_reg_sel_i(write_reg_sel_i), .write_data_i(write_data_i), .read_data1_o(read_data1_d), .read_data2_o(read_data2_d));
	 
	control control_inst (.op_i(instr_i[31:25]), .alu_op_o(alu_op_d), .branch_type_o(branch_d), .reg_write_enable_o(write_d), .imm_sel_o(imm_sel_d),
						  .wb_sel_o(wb_sel_d), .mem_write_enable_o(m_write_d), .tpu_start_o(tpu_start_d), .tpu_write_enable_A(tpu_wren_A_d), 
						  .tpu_write_enable_B(tpu_wren_B_d), .tpu_write_enable_C(tpu_wren_C_d));
					 
	assign imm_ext_d = {{17{imm[14]}}, imm};
	
	assign imm = branch_d[0] ? {instr_i[24:20], instr_i[9:0]} : instr_i[14:0];
	
	assign col_d = instr_i[12:8];
	
	assign row_d = instr_i[17:13];
	
	assign d_op1_reg_d = instr_i[19:15];
	
	assign d_op2_reg_d = instr_i[14:10];
	
	/////////////////
	// ID/EX Flops //
	/////////////////
	
	///////////////////////////////
	// Stall holds same value    //
	// Flush sets to default     //
	// Default is the new value  //
	///////////////////////////////
	always_ff @(posedge clk_i)
		if (stall_i) begin
			pc_o <= pc_o;
			write_reg_sel_o <= write_reg_sel_o;
			read_data1_o <= read_data1_o;
			read_data2_o <= read_data2_o;
			imm_o <= imm_o;
			alu_op_o <= alu_op_o;
			imm_sel_o <= imm_sel_o;
			wb_sel_o <= wb_sel_o;
			col_o <= col_o;
			row_o <=  row_o;
			d_op2_reg_o <= d_op2_reg_o;
			d_op1_reg_o <= d_op1_reg_o;
		end
		else if (flush_i) begin
			pc_o <= pc_i;
			write_reg_sel_o <= instr_i[24:20];
			read_data1_o <= read_data1_d;
			read_data2_o <= read_data2_d;
			imm_o <= imm_ext_d;
			alu_op_o <= alu_op_d;
			imm_sel_o <= imm_sel_d;
			wb_sel_o <= wb_sel_d;
			col_o <= col_d;
			row_o <=  row_d;
			d_op2_reg_o <= d_op2_reg_d;
			d_op1_reg_o <= d_op1_reg_d;
		end
		else begin
			pc_o <= pc_i;
			write_reg_sel_o <= instr_i[24:20];
			read_data1_o <= read_data1_d;
			read_data2_o <= read_data2_d;
			imm_o <= imm_ext_d;
			alu_op_o <= alu_op_d;
			imm_sel_o <= imm_sel_d;
			wb_sel_o <= wb_sel_d;
			col_o <= col_d;
			row_o <=  row_d;
			d_op2_reg_o <= d_op2_reg_d;
			d_op1_reg_o <= d_op1_reg_d;
		end
	
	// Needs to clear this on flush and reset //
	always_ff @(posedge clk_i, negedge rst_n_i)
		if (!rst_n_i) begin
			reg_write_enable_o <= 0;
			mem_write_enable_o <= 0;
			branch_type_o <= 0;
			start_o <= 0;
			write_enable_A_o <= 0;
			write_enable_B_o <= 0;
			write_enable_C_o <= 0;
		end
		else if (stall_i) begin
			reg_write_enable_o <= reg_write_enable_o;
			mem_write_enable_o <= mem_write_enable_o;
			branch_type_o <= branch_type_o;
			start_o <= start_o;
			write_enable_A_o <= write_enable_A_o;
			write_enable_B_o <= write_enable_B_o;
			write_enable_C_o <= write_enable_C_o;
		end
		else if (flush_i) begin
			reg_write_enable_o <= 0;
			mem_write_enable_o <= 0;
			branch_type_o <= 0;
			start_o <= 0;
			write_enable_A_o <= 0;
			write_enable_B_o <= 0;
			write_enable_C_o <= 0;
		end
		else begin
			reg_write_enable_o <= write_d;
			mem_write_enable_o <= m_write_d;
			branch_type_o <= branch_d;
			start_o <= tpu_start_d;
			write_enable_A_o <= tpu_wren_A_d;
			write_enable_B_o <= tpu_wren_B_d;
			write_enable_C_o <= tpu_wren_C_d;
		end
		
endmodule