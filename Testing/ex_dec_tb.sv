module ex_dec_tb();

	// Decode Signals //
	logic clk_i, rst_n_i, flush_i, reg_write_enable_i, stall_i;
	logic [4:0] write_reg_sel_i, write_reg_sel_o, col_o, row_o, d_op2_reg_o, d_op1_reg_o;
	logic [31:0] instr_i, write_data_i, pc_i, pc_o;
	logic imm_sel_o, reg_write_enable_o, mem_write_enable_o;
	logic write_enable_A_o, write_enable_B_o, write_enable_C_o, start_o;
	logic [31:0] read_data1_o, read_data2_o, imm_o;
	logic [3:0] alu_op_o;
	logic [1:0] wb_sel_o, branch_type_o;
	
	// Execute Signals //
	logic signed [31:0] forward_data_i;
	logic [1:0] forward_en_i;
	logic [31:0] result_o;
	logic wb_sel_o_ex, reg_write_enable_o_ex, mem_write_enable_o_ex;
	logic [4:0] write_reg_sel_o_ex;
	logic [31:0] pc_o_ex, cout_o_ex, read_data2_o_ex;
	logic [4:0] e_dest_reg_o;
	logic e_dest_reg_en_o, e_valid_o;
	
	decode dec_DUT (.*);
	execute ex_DUT (.read_data1_i(read_data1_o), .read_data2_i(read_data2_o), .imm_i(imm_o), .pc_i(pc_o), .imm_sel_i(imm_sel_o), .wb_sel_i(wb_sel_o), .alu_op_i(alu_op_o),
					.reg_write_enable_i(reg_write_enable_o), .mem_write_enable_i(mem_write_enable_o), .branch_type_i(branch_type_o), .write_reg_sel_i(write_reg_sel_o),
					.col_i(col_o), .row_i(row_o), .start_i(start_o), .write_enable_A_i(write_enable_A_o), .write_enable_B_i(write_enable_B_o), .write_enable_C_i(write_enable_C_o),
					.wb_sel_o(wb_sel_o_ex), .reg_write_enable_o(reg_write_enable_o_ex), .mem_write_enable_o(mem_write_enable_o_ex), .write_reg_sel_o(write_reg_sel_o_ex), 
					.pc_o(pc_o_ex), .cout_o(cout_o_ex), .read_data2_o(read_data2_o_ex));
	
	initial begin
		clk_i = 0;
		// Test 1: Reset Test //
		
		// Test 2: Flush Test //
		
		// Test 3: Stall Test //
		
		// Test 4: Random Instructions //
	end
	
	always
		#5 clk_i <= ~clk_i;

endmodule