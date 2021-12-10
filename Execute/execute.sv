module execute 
	(	   
	input clk_i, rst_n_i, flush_i, stall_i,
	input [31:0] read_data1_i, read_data2_i, imm_i, pc_i, forward_data_i,
	input [3:0] alu_op_i,
	input imm_sel_i, reg_write_enable_i, mem_write_enable_i, mem_cache_valid_i,
	input [1:0] branch_type_i, forward_en_i, wb_sel_i,
	input [4:0] reg_write_dst_i, col_i, row_i,
	input start_i, write_enable_A_i, write_enable_B_i, write_enable_C_i,	
	
	output logic [31:0] result_o, pc_o, cout_o, read_data2_o,
	output logic reg_write_enable_o, mem_write_enable_o, branch_dec_o, mem_cache_valid_o,
	output logic [4:0] reg_write_dst_o,
	output logic [1:0] wb_sel_o,
	//output [4:0] e_dest_reg_o,
	output [1:0] branch_inst_o,
	output e_valid_o
	);
	
	// forwarding
	
	logic [31:0] b_i, result_d, read_data1_d, read_data2_d;
	logic [31:0] pc_d, cout_d;
	logic branch_dec, done_d;
	
	assign read_data1_d = (forward_en_i == 2'd1) ? forward_data_i : read_data1_i;
	assign read_data2_d = (forward_en_i == 2'd2) ? forward_data_i : read_data2_i;
	
	assign b_i = (imm_sel_i) ? imm_i : read_data2_d; 
	
	alu i_alu (.a_i(read_data1_d), .b_i(b_i), .alu_op_i(alu_op_i), .result_o(result_d), .branch_o(branch_dec));
	
	//branch_pc i_branch_pc (.pc_i(pc_i), .imm_i(imm_i), .read_data1_i(read_data1_d), .branch_dec_i(branch_dec), 
	//                       .branch_type_i(branch_type_i), .pc_o(pc_d));
	branch_pc i_branch_pc (.pc_i(pc_i), .imm_i(imm_i), .read_data1_i(read_data1_d), .branch_dec_i(branch_dec), 
	                       .branch_type_i(branch_type_i), .pc_o(pc_o));
										  
	tpuv1 #(.BITS_AB(16), .BITS_C(32), .DIM(32)) i_tpuv1 (.clk(clk_i), .rst_n(rst_n_i), .start(start_i), .WrEnA(write_enable_A_i), .WrEnB(write_enable_B_i), .WrEnC(write_enable_C_i),
				   .col(col_i), .row(row_i), .dataIn(read_data1_d), .dataOut(cout_d), .done(done_d));
	
	assign e_valid_o = start_i ? done_d : 1'b1;
	
	assign e_dest_reg_o = reg_write_dst_i;
	
	assign branch_inst_o  = branch_type_i;
	
	assign branch_dec_o = branch_dec | branch_type_i[1];
		
	//////////////////
	// EX/MEM Flops //
	//////////////////
	
	// Update Key Signals //
	always_ff @(posedge clk_i, negedge rst_n_i)
		if (!rst_n_i) begin
			//pc_o <= 0;
			reg_write_enable_o <= 0;
			mem_write_enable_o <= 0;
			mem_cache_valid_o <= 0;
		end
		else if (flush_i) begin
			//pc_o <= pc_i;
			reg_write_enable_o <= 0;
			mem_write_enable_o <= 0;
			mem_cache_valid_o <= 0;
		end
		else if (stall_i) begin
			//pc_o <= pc_o;
			reg_write_enable_o <= reg_write_enable_o;
			mem_write_enable_o <= mem_write_enable_o;
			mem_cache_valid_o <= mem_cache_valid_o;
		end
		else begin
			//pc_o <= pc_d;
			reg_write_enable_o <= reg_write_enable_i;
			mem_write_enable_o <= mem_write_enable_i;
			mem_cache_valid_o <= mem_cache_valid_i;
		end
	
	// Don't need to reset some signals //
	// Flush to default value 			//
	always_ff @(posedge clk_i)
		if (flush_i) begin
			result_o <= result_d;
			reg_write_dst_o <=  reg_write_dst_i;
			wb_sel_o <= wb_sel_i;
			cout_o <= cout_d;
			read_data2_o <= read_data2_d;
		end
		else if (stall_i) begin
			result_o <= result_o;
			reg_write_dst_o <=  reg_write_dst_o;
			wb_sel_o <= wb_sel_o;
			cout_o <= cout_o;
			read_data2_o <= read_data2_o;
		end
		else begin
			result_o <= result_d;
			reg_write_dst_o <=  reg_write_dst_i;
			wb_sel_o <= wb_sel_i;
			cout_o <= cout_d;
			read_data2_o <= read_data2_d;
		end

endmodule