module proc(
	input clk, 
	input rst_n
	);

// CONTROL FLOW OUTPUTS
	logic cf_to_fe_f_stall;
	logic cf_to_de_d_stall;
	logic cf_to_ex_e_stall;
	logic cf_to_mem_m_stall;
	logic cf_to_wb_w_stall;
	logic cf_to_fe_f_flush;
	logic cf_to_de_d_flush;
	logic cf_to_ex_e_flush;
	logic cf_to_mem_m_flush;
	logic cf_to_wb_w_flush;
	// To Fetch
	// To Decode
	// To Execute
	// To Memory
	// To Writeback


// FETCH OUTPUTS
	logic fe_to_de_pc;
	logic fe_to_de_instr;
	logic fe_to_icache_addr_to_cache;
	logic fe_to_cf_stall;
	// To Decode
	//To Icache
	
	
// DECODE OUTPUTS
	logic de_to_ex_read_data_1;
	logic de_to_ex_read_data_2;
	logic de_to_ex_imm;
	logic de_to_ex_alu_op;
	logic de_to_ex_imm_sel;
	logic de_to_ex_wb_sel;
	logic de_to_ex_reg_write_enable;
	logic de_to_ex_mem_write_enable;
	logic de_to_ex_branch_type;
	logic de_to_ex_write_reg_sel;
	logic de_to_ex_pc;
	logic de_to_ex_write_enable_A;
	logic de_to_ex_write_enable_B;
	logic de_to_ex_write_enable_C;
	logic de_to_ex_start;
	logic de_to_ex_col;
	logic de_to_ex_row;
	logic de_to_cf_d_op2_reg;
	logic de_to_cf_d_op1_reg;
	// To execute
	// To memory
	// To writeback
	// To TPU
	// To Control Flow

	
// EXECUTE OUTPUTS
	logic ex_to_mem_result;
	logic ex_to_mem_wb_sel;
	logic ex_to_mem_reg_write_enable;
	logic ex_to_mem_mem_write_enable;
	logic ex_to_mem_write_reg_sel;
	logic ex_to_fe_pc;
	logic ex_to_cf_e_dest_reg;
	logic ex_to_mem_cout;
	logic ex_to_mem_read_data_2;
	// To Fetch	
	// To Memory
	// To Writeback
	// To Control Flow
	
	
// MEMORY OUTPUTS
	logic mem_to_wb_write_reg_sel;
	logic mem_to_wb_wb_sel;
	logic mem_to_wb_reg_write_enable;
	logic mem_to_wb_result;
	logic mem_to_wb_read_data;
	logic mem_to_wb_cout;
	logic mem_to_dcache_data_to_cache;
	logic mem_to_dcache_addr_to_cache;
	logic mem_to_dcache_wr_to_cache;
	logic mem_to_cf_m_dst_reg;
	// To Writeback
	// To Dcache
	// To Control Flow
	
	
// WRITEBACK OUTPUTS
	logic wb_to_de_reg_wrdata;
	logic wb_to_de_reg_wren;
	logic wb_to_cf_w_dest_reg;
	logic wb_to_de_dest_reg;
	// To Decode
	// To Control Flow
	


	control_flow_bubble cf(
		clk_i				(clk),
		rst_n_i				(rst_n),
		branch_inst_i		(),
		branch_dec_i		(),
		inst_cache_stall_i	(),
		data_cache_stall_i	(),
		tpu_busy_stall_i    (fe_to_cf_stall),
		d_op1_reg_i			(de_to_cf_d_op1_reg),
		d_op2_reg_i			(de_to_cf_d_op2_reg),
		e_dest_reg_i		(ex_to_cf_e_dest_reg),
		m_dest_reg_i		(mem_to_cf_m_dst_reg),
		w_dest_reg_i		(wb_to_cf_w_dest_reg),
		f_stall_o			(cf_to_fe_f_stall),
		d_stall_o			(cf_to_de_d_stall),
		e_stall_o			(cf_to_ex_e_stall),
		m_stall_o			(cf_to_mem_m_stall),
		w_stall_o			(cf_to_wb_w_stall),
		f_flush_o			(cf_to_fe_f_flush),
		d_flush_o			(cf_to_de_d_flush),
		e_flush_o			(cf_to_ex_e_flush),
		m_flush_o			(cf_to_mem_m_flush),
		w_flush_o			(cf_to_wb_w_flush)
	);

	
	fetch fetch_stage(
		clk_i				(clk),
		rst_n_i				(rst_n),
		pc_i				(ex_to_fe_pc),
		branch_i			(),
		stall_i				(cf_to_fe_f_stall),
		flush_i				(cf_to_fe_f_flush),
		data_from_cache_i	(),
		data_cache_valid_i	(),
		pc_o				(fe_to_de_pc),
		instr_o				(fe_to_de_instr),
		addr_to_cache_o		(fe_to_icache_addr_to_cache),
		stall_o				(fe_to_cf_stall)
	);
		
	decode decode_stage(
		clk_i				(clk),
		rst_n_i				(rst_n),
		flush_i				(cf_to_de_d_flush),
		reg_write_enable_i	(wb_to_de_reg_wren),
		write_reg_sel_i		(wb_to_de_dest_reg),
		instr_i				(fe_to_de_instr),
		write_data_i		(wb_to_de_reg_wrdata),
		pc_i				(fe_to_de_pc),
		stall_i				(cf_to_de_d_stall),
		read_data_1_o		(de_to_ex_read_data_1),
		read_data_2_o		(de_to_ex_read_data_2),
		imm_o				(de_to_ex_imm),
		alu_op_o			(de_to_ex_alu_op),
		imm_sel_o			(de_to_ex_imm_sel),
		wb_sel_o			(de_to_ex_wb_sel),
		reg_write_enable_o	(de_to_ex_reg_write_enable),
		mem_write_enable_o	(de_to_ex_mem_write_enable),
		branch_type_o		(de_to_ex_branch_type),
		write_reg_sel_o		(de_to_ex_write_reg_sel),
		pc_o				(de_to_ex_pc),
		write_enable_A_o	(de_to_ex_write_enable_A),
		write_enable_B_o	(de_to_ex_write_enable_B),
		write_enable_C_o	(de_to_ex_write_enable_C),
		start_o				(de_to_ex_start),
		col_o				(de_to_ex_col),
		row_o				(de_to_ex_row),
		d_op2_reg_o			(de_to_cf_d_op2_reg),
		d_op1_reg_o			(de_to_cf_d_op1_reg)
	);

	execute execute_stage(
		clk_i				(clk),
		rst_n_i				(rst_n),
		flush_i				(cf_to_ex_e_flush),
		read_data_1_i		(de_to_ex_read_data_1),
		read_data_2_i		(de_to_ex_read_data_2),
		imm_i				(de_to_ex_imm),
		alu_op_i			(de_to_ex_alu_op),
		imm_sel_i			(de_to_ex_imm_sel),
		wb_sel_i			(de_to_ex_wb_sel),
		reg_write_enable_i	(de_to_ex_reg_write_enable),
		mem_write_enable_i	(de_to_ex_mem_write_enable),
		branch_type_i		(de_to_ex_branch_type),
		reg_write_sel_i		(de_to_ex_write_reg_sel),
		pc_i				(de_to_ex_pc),
		forward_data_i		(),
		forward_en_i		(),
		stall_i				(cf_to_ex_e_stall),
		write_enable_A_i	(de_to_ex_write_enable_A),
		write_enable_B_i	(de_to_ex_write_enable_B),
		write_enable_C_i	(de_to_ex_write_enable_C),
		start_i				(de_to_ex_start),
		col_i				(de_to_ex_col),
		row_i				(de_to_ex_col),
		result_o			(ex_to_mem_result),
		wb_sel_o			(ex_to_mem_wb_sel),
		reg_write_enable_o	(ex_to_mem_reg_write_enable),
		mem_write_enable_o	(ex_to_mem_mem_write_enable),
		write_reg_sel_o		(ex_to_mem_write_reg_sel),
		pc_o				(ex_to_fe_pc),
		e_dest_reg_o		(ex_to_cf_e_dest_reg),
		cout_o				(ex_to_mem_cout),
		read_data_2_o		(ex_to_mem_read_data_2)
	);

	memory memory_stage(
		clk_i				(clk),
		rst_n_i				(rst_n),
		stall_i				(cf_to_mem_m_stall),
		flush_i				(cf_to_mem_m_flush),
		write_reg_sel_i		(ex_to_mem_write_reg_sel),
		mem_write_enable_i	(ex_to_mem_mem_write_enable),
		wb_sel_i			(ex_to_mem_wb_sel),
		reg_write_enable_i	(ex_to_mem_reg_write_enable),
		cout_i				(ex_to_mem_cout),
		result_i			(ex_to_mem_result),
		read_data_2_i		(ex_to_mem_read_data_2),
		forward_data_i		(),
		forward_en_i		(),
		data_from_cache_i	(),
		data_cache_valid_i	(),
		write_reg_sel_o		(mem_to_wb_write_reg_sel),
		wb_sel_o			(mem_to_wb_wb_sel),
		reg_write_enable_o	(mem_to_wb_reg_write_enable),
		result_o			(mem_to_wb_result),
		read_data_o			(mem_to_wb_read_data),
		cout_o				(mem_to_wb_cout),
		data_to_cache_o		(mem_to_dcache_data_to_cache),
		addr_to_cache_o		(mem_to_dcache_addr_to_cache),
		wr_to_cache_o		(mem_to_dcache_wr_to_cache),
		m_dst_reg_o			(mem_to_cf_m_dst_reg)
	);

	writeback writeback_stage(
		clk_i				(clk),
		rst_n_i				(rst_n),
		mem_data_i			(mem_to_wb_read_data),
		result_i			(mem_to_wb_result),
		cout_i				(mem_to_wb_cout),
		wb_sel_i			(mem_to_wb_wb_sel),
		reg_wren_i			(mem_to_wb_reg_write_enable),
		flush_i				(cf_to_wb_w_flush),
		stall_i				(cf_to_wb_w_stall),
		forward_data_i		(),
		forward_en_i		(),
		reg_wrdata_o		(wb_to_de_reg_wrdata),
		reg_wren_o			(wb_to_de_reg_wren),
		w_dest_reg_o		(wb_to_cf_w_dest_reg)
	);
	
	
	assign wb_to_de_dest_reg = wb_to_cf_w_dest_reg;
	
endmodule
