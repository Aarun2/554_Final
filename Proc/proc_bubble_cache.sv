module proc_bubble_cache(
	input clk, 
	input rst_n
	);
	localparam REG_SIZE = 32;


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
	// TAPS
	logic [4:0] wb_to_cf_w_dest_reg;
	logic [4:0] wb_to_cf_m_dest_reg;


// FETCH OUTPUTS
	logic [REG_SIZE-1:0]fe_to_de_pc;
	logic [REG_SIZE-1:0]fe_to_de_instr;
	logic [REG_SIZE-1:0]fe_to_icache_addr_to_cache;
	logic fe_to_cf_stall;
	// To Decode
	//To Icache
	
	
// DECODE OUTPUTS
	logic [REG_SIZE-1:0]de_to_ex_read_data_1;
	logic [REG_SIZE-1:0]de_to_ex_read_data_2;
	logic [REG_SIZE-1:0]de_to_ex_imm;
	logic [3:0] de_to_ex_alu_op;
	logic de_to_ex_imm_sel;
	logic [1:0]de_to_ex_wb_sel;
	logic de_to_ex_reg_write_enable;
	logic de_to_ex_mem_write_enable;
	logic de_to_ex_mem_cache_valid;
	logic [1:0] de_to_ex_branch_type;
	logic [4:0] de_to_ex_reg_write_dst;
	logic [REG_SIZE-1:0] de_to_ex_pc;
	logic de_to_ex_write_enable_A;
	logic de_to_ex_write_enable_B;
	logic de_to_ex_write_enable_C;
	logic de_to_ex_start;
	logic [4:0] de_to_ex_col;
	logic [4:0] de_to_ex_row;
	logic [4:0] de_to_cf_d_op2_reg;
	logic [4:0] de_to_cf_d_op1_reg;
	// To execute
	// To memory
	// To writeback
	// To TPU
	// To Control Flow

	
// EXECUTE OUTPUTS
	logic [REG_SIZE-1:0] ex_to_mem_result;
	logic [1:0] ex_to_mem_wb_sel;
	logic ex_to_mem_reg_write_enable;
	logic ex_to_mem_mem_write_enable;
	logic ex_to_mem_mem_cache_valid;
	logic [4:0] ex_to_mem_reg_write_dst;
	logic [REG_SIZE-1:0] ex_to_fe_pc;
	logic [4:0] ex_to_cf_e_dest_reg;
	logic [REG_SIZE-1:0] ex_to_mem_cout;
	logic [REG_SIZE-1:0] ex_to_mem_read_data_2;
	logic [1:0] ex_to_cf_branch_inst_o;
	logic ex_to_cf_branch_dec_o;
	logic ex_to_cf_e_valid;
	// To Fetch	
	// To Memory
	// To Writeback
	// To Control Flow
	
	
// MEMORY OUTPUTS
	logic [4:0] mem_to_wb_reg_write_dst;
	logic [1:0] mem_to_wb_wb_sel;
	logic mem_to_wb_reg_write_en;
	logic [REG_SIZE-1:0] mem_to_wb_result;
	logic [REG_SIZE-1:0] mem_to_wb_read_data;
	logic [REG_SIZE-1:0] mem_to_wb_cout;
	logic [REG_SIZE-1:0] mem_to_dcache_data_to_cache;
	logic [REG_SIZE-1:0] mem_to_dcache_addr_to_cache;
	logic mem_to_dcache_wr_to_cache;
	logic mem_to_cache_cache_rq;
	// To Writeback
	// To Dcache
	// To Control Flow
	
	logic [4:0] mem_to_cf_m_dst_reg;
	logic mem_to_cf_stall;
	
	
	
	
// WRITEBACK OUTPUTS
	logic [REG_SIZE-1:0]wb_to_de_reg_wrdata;
	logic wb_to_de_reg_wren;
	logic wb_to_de_dest_reg;
	logic wb_to_de_reg_write_en;
	// To Decode
	// To Control Flow
	
// I-Cache outputs
	logic icache_to_fe_pipeline_valid;
	logic [REG_SIZE-1:0] icache_to_fe_data_out_pipeline;
	
// D-Cache outputs
	logic dcache_to_mem_pipeline_valid;
	logic [REG_SIZE-1:0] dcache_to_mem_data_out_pipeline;


// Full cache outputs
	logic [31:0] main_to_dma_addr_out_request_DMA;
	logic main_to_dma_request_DMA;
	logic [511:0] main_to_dma_data_out_evict_DMA;
	logic [31:0] main_to_dma_addr_out_evict_DMA;
	logic main_to_dma_evict_DMA;
	
// DMA outputs
	logic [511:0] dma_to_main_data_in_request_DMA;
	logic [31:0] dma_to_main_addr_in_request_DMA;
	logic dma_to_main_request_valid_DMA;
	logic dma_to_main_evict_DMA;



	control_flow_bubble cf(
		.clk_i				(clk),
		.rst_n_i				(rst_n),
		.branch_inst_i		(ex_to_cf_branch_inst_o),
		.branch_dec_i		(ex_to_cf_branch_dec_o),
		.inst_cache_stall_i	(fe_to_cf_stall),
		.data_cache_stall_i	(mem_to_cf_stall),
		.tpu_busy_stall_i    (ex_to_cf_e_valid),
		.d_op1_reg_i			(de_to_cf_d_op1_reg),
		.d_op2_reg_i			(de_to_cf_d_op2_reg),
		.e_dest_reg_i		(ex_to_cf_e_dest_reg),
		.m_dest_reg_i		(mem_to_cf_m_dst_reg),
		.w_dest_reg_i		(wb_to_cf_w_dest_reg),
		.f_stall_o			(cf_to_fe_f_stall),
		.d_stall_o			(cf_to_de_d_stall),
		.e_stall_o			(cf_to_ex_e_stall),
		.m_stall_o			(cf_to_mem_m_stall),
		.w_stall_o			(cf_to_wb_w_stall),
		.f_flush_o			(cf_to_fe_f_flush),
		.d_flush_o			(cf_to_de_d_flush),
		.e_flush_o			(cf_to_ex_e_flush),
		.m_flush_o			(cf_to_mem_m_flush),
		.w_flush_o			(cf_to_wb_w_flush)
	);

	
	fetch fetch(
		.clk_i				(clk),
		.rst_n_i				(rst_n),
		.pc_i				(ex_to_fe_pc),
		.branch_i			(ex_to_cf_branch_dec_o),
		.stall_i				(cf_to_fe_f_stall),
		.flush_i				(cf_to_fe_f_flush),
		.data_from_cache_i	({icache_to_fe_data_out_pipeline[7:0],icache_to_fe_data_out_pipeline[15:8],icache_to_fe_data_out_pipeline[23:16],icache_to_fe_data_out_pipeline[31:24]}),
		.data_cache_valid_i	(icache_to_fe_pipeline_valid),
		.pc_o				(fe_to_de_pc),
		.instr_o				(fe_to_de_instr),
		.addr_to_cache_o		(fe_to_icache_addr_to_cache),
		.stall_o				(fe_to_cf_stall)
	);
		
	decode decode(
		.clk_i				(clk),
		.rst_n_i				(rst_n),
		.flush_i				(cf_to_de_d_flush),
		.reg_write_enable_i	(wb_to_de_reg_write_en),
		.reg_write_dst_i		(mem_to_wb_reg_write_dst),
		.instr_i				(fe_to_de_instr),
		.write_data_i		(wb_to_de_reg_wrdata),
		.pc_i				(fe_to_de_pc),
		.stall_i				(cf_to_de_d_stall),
		.read_data1_o		(de_to_ex_read_data_1),
		.read_data2_o		(de_to_ex_read_data_2),
		.imm_o				(de_to_ex_imm),
		.alu_op_o			(de_to_ex_alu_op),
		.imm_sel_o			(de_to_ex_imm_sel),
		.wb_sel_o			(de_to_ex_wb_sel),
		.reg_write_enable_o	(de_to_ex_reg_write_enable),
		.mem_write_enable_o	(de_to_ex_mem_write_enable),
		.mem_cache_valid_o  (de_to_ex_mem_cache_valid),
		.branch_type_o		(de_to_ex_branch_type),
		.reg_write_dst_o		(de_to_ex_reg_write_dst),
		.pc_o				(de_to_ex_pc),
		.write_enable_A_o	(de_to_ex_write_enable_A),
		.write_enable_B_o	(de_to_ex_write_enable_B),
		.write_enable_C_o	(de_to_ex_write_enable_C),
		.start_o				(de_to_ex_start),
		.col_o				(de_to_ex_col),
		.row_o				(de_to_ex_row),
		.d_op2_reg_o			(de_to_cf_d_op2_reg),
		.d_op1_reg_o			(de_to_cf_d_op1_reg)
	);

	execute execute(
		.clk_i				(clk),
		.rst_n_i				(rst_n),
		.flush_i				(cf_to_ex_e_flush),
		.read_data1_i		(de_to_ex_read_data_1),
		.read_data2_i		(de_to_ex_read_data_2),
		.imm_i				(de_to_ex_imm),
		.alu_op_i			(de_to_ex_alu_op),
		.imm_sel_i			(de_to_ex_imm_sel),
		.wb_sel_i			(de_to_ex_wb_sel),
		.reg_write_enable_i	(de_to_ex_reg_write_enable),
		.mem_write_enable_i	(de_to_ex_mem_write_enable),
		.mem_cache_valid_i	(de_to_ex_mem_cache_valid),
		.branch_type_i		(de_to_ex_branch_type),
		.reg_write_dst_i		(de_to_ex_reg_write_dst),
		.pc_i				(de_to_ex_pc),
		.forward_data_i		(0),
		.forward_en_i		(0),
		.stall_i				(cf_to_ex_e_stall),
		.write_enable_A_i	(de_to_ex_write_enable_A),
		.write_enable_B_i	(de_to_ex_write_enable_B),
		.write_enable_C_i	(de_to_ex_write_enable_C),
		.start_i				(de_to_ex_start),
		.col_i				(de_to_ex_col),
		.row_i				(de_to_ex_row),
		.result_o			(ex_to_mem_result),
		.wb_sel_o			(ex_to_mem_wb_sel),
		.reg_write_enable_o	(ex_to_mem_reg_write_enable),
		.mem_write_enable_o	(ex_to_mem_mem_write_enable),
		.mem_cache_valid_o  (ex_to_mem_mem_cache_valid),
		.reg_write_dst_o	(ex_to_mem_reg_write_dst),
		.pc_o				(ex_to_fe_pc),
		.cout_o				(ex_to_mem_cout),
		.read_data2_o		(ex_to_mem_read_data_2),
		.branch_inst_o		(ex_to_cf_branch_inst_o),
		.branch_dec_o		(ex_to_cf_branch_dec_o),
		.e_valid_o			(ex_to_cf_e_valid)
	);
	
	assign ex_to_cf_e_dest_reg = de_to_ex_reg_write_dst;

	memory memory(
		.clk_i				(clk),
		.rst_n_i				(rst_n),
		.stall_i				(cf_to_mem_m_stall),
		.flush_i				(cf_to_mem_m_flush),
		.reg_write_dst_i		(ex_to_mem_reg_write_dst),
		.mem_write_en_i	(ex_to_mem_mem_write_enable),
		.cache_req_i		(ex_to_mem_mem_cache_valid),
		.wb_sel_i			(ex_to_mem_wb_sel),
		.reg_write_en_i	(ex_to_mem_reg_write_enable),
		.cout_i				(ex_to_mem_cout),
		.result_i			(ex_to_mem_result),
		.read_data_2_i		(ex_to_mem_read_data_2),
		.forward_data_i		(0),
		.forward_en_i		(0),
		.data_from_cache_i	({dcache_to_mem_data_out_pipeline[7:0],dcache_to_mem_data_out_pipeline[15:8],dcache_to_mem_data_out_pipeline[23:16],dcache_to_mem_data_out_pipeline[31:24]}),
		.data_cache_valid_i	(dcache_to_mem_pipeline_valid),
		.reg_write_dst_o	(mem_to_wb_reg_write_dst),
		.wb_sel_o			(mem_to_wb_wb_sel),
		.reg_write_en_o		(mem_to_wb_reg_write_en),
		.result_o			(mem_to_wb_result),
		.read_data_o		(mem_to_wb_read_data),
		.cout_o				(mem_to_wb_cout),
		.data_to_cache_o	({mem_to_dcache_data_to_cache[7:0],mem_to_dcache_data_to_cache[15:8],mem_to_dcache_data_to_cache[23:16],mem_to_dcache_data_to_cache[31:24]}),
		.addr_to_cache_o	(mem_to_dcache_addr_to_cache),
		.wr_to_cache_o		(mem_to_dcache_wr_to_cache),
		.cache_req_o		(mem_to_cache_cache_rq),
		.stall_o			(mem_to_cf_stall)
	);
	
	assign mem_to_cf_m_dst_reg = ex_to_mem_reg_write_dst;

	writeback writeback(
		.mem_data_i			(mem_to_wb_read_data),
		.result_i			(mem_to_wb_result),
		.cout_i				(mem_to_wb_cout),
		.wb_sel_i			(mem_to_wb_wb_sel),
		.reg_write_enable_i		(mem_to_wb_reg_write_en),
		.flush_i				(cf_to_wb_w_flush),
		.stall_i				(cf_to_wb_w_stall),
		.forward_data_i		(0),
		.forward_en_i		(0),
		.reg_write_data_o	(wb_to_de_reg_wrdata),
		.reg_write_enable_o		(wb_to_de_reg_write_en)
	);
	
	assign wb_to_cf_w_dest_reg = mem_to_wb_reg_write_dst;
	
	// i_cache i_cache (
		// .addr_in_pipeline_i(fe_to_icache_addr_to_cache),
		// .pipeline_valid_o(icache_to_fe_pipeline_valid),
		// .data_out_pipeline_o(icache_to_fe_data_out_pipeline)
	
	// );
	
	// d_cache d_cache (
		// .clk_i(clk), 
		// .rst_n_i(rst_n),
		// .pipeline_write_valid_i(mem_to_dcache_wr_to_cache), 
		// .addr_in_pipeline_i(mem_to_dcache_addr_to_cache), 
		// .data_in_pipeline_i(mem_to_dcache_data_to_cache),
		// .pipeline_valid_o(dcache_to_mem_pipeline_valid),
		// .data_out_pipeline_o(dcache_to_mem_data_out_pipeline)
	// );
	
	Cache cache (
		.clk_i(clk),
		.rst_n_i(rst_n),
		
		// Inputs to ICache from CPU
		.addr_in_pipeline_icache_i(fe_to_icache_addr_to_cache),
		.pipeline_valid_icache_i(1'b1),
		
		// Outputs from ICache to CPU
		.data_out_pipeline_icache_o(icache_to_fe_data_out_pipeline),
		.pipeline_valid_icache_o(icache_to_fe_pipeline_valid),
		
		
		// Inputs to DCache from CPU
		.addr_in_pipeline_dcache_i(mem_to_dcache_addr_to_cache),
		.data_in_pipeline_dcache_i(mem_to_dcache_data_to_cache),
		.pipeline_wr_valid_dcache_i(mem_to_dcache_wr_to_cache),
		.pipeline_valid_dcache_i(mem_to_cache_cache_rq),
		
		// Outputs from DCache to CPU
		.data_out_pipeline_dcache_o(dcache_to_mem_data_out_pipeline),
		.pipeline_valid_dcache_o(dcache_to_mem_pipeline_valid),
		
		
		// Inputs from DMA Interface
		.data_in_request_DMA_i(dma_to_main_data_in_request_DMA),
		.addr_in_request_DMA_i(dma_to_main_addr_in_request_DMA),
		.request_valid_DMA_i(dma_to_main_request_valid_DMA),
		.evict_DMA_i(dma_to_main_evict_DMA),
		
		// Outputs to DMA Interface
		.addr_out_request_DMA_o(main_to_dma_addr_out_request_DMA),
		.request_DMA_o(main_to_dma_request_DMA),
		.data_out_evict_DMA_o(main_to_dma_data_out_evict_DMA),
		.addr_out_evict_DMA_o(main_to_dma_addr_out_evict_DMA),
		.evict_DMA_o(main_to_dma_evict_DMA)
	);
	
	dummyDMA dma(
		.clk_i(clk),
		.rst_n_i(rst_n),
	
		// Outputs to DMA Interface
		.addr_out_request_DMA_i(main_to_dma_addr_out_request_DMA),
		.request_DMA_i(main_to_dma_request_DMA),
		.data_out_evict_DMA_i(main_to_dma_data_out_evict_DMA),
		.evict_DMA_i(main_to_dma_evict_DMA),
	
		// Inputs from DMA Interface
		.data_in_request_DMA_o(dma_to_main_data_in_request_DMA),
		.addr_in_request_DMA_o(dma_to_main_addr_in_request_DMA),
		.request_valid_DMA_o(dma_to_main_request_valid_DMA),
		.evict_DMA_o(dma_to_main_evict_DMA)
	);
	
endmodule
