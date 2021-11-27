module decode_tb();

	localparam TIME_PER_INSTR = 10**6;

	logic clk_i, rst_n_i, flush_i, reg_write_enable_i, stall_i;
	logic [4:0] write_reg_sel_i, write_reg_sel_o, col_o, row_o, d_op2_reg_o, d_op1_reg_o;
	logic [31:0] instr_i, write_data_i, pc_i, pc_o;
	logic imm_sel_o, reg_write_enable_o, mem_write_enable_o;
	logic write_enable_A_o, write_enable_B_o, write_enable_C_o, start_o;
	logic [31:0] read_data1_o, read_data2_o, imm_o;
	logic [3:0] alu_op_o;
	logic [1:0] wb_sel_o, branch_type_o;
	
	logic [4:0] write_reg_sel_old, col_old, row_old;
	logic [31:0] pc_old;
	logic imm_sel_old, reg_write_enable_old, mem_write_enable_old;
	logic write_enable_A_old, write_enable_B_old, write_enable_C_old, start_old;
	logic [31:0] read_data1_old, read_data2_old, imm_old;
	logic [3:0] alu_op_old;
	logic [1:0] wb_sel_old, branch_type_old;
	
	logic [31:0] mem [31:0];
	logic [24:0] reg_data;
	
	decode decode_DUT (.*);
	
	initial
		$readmemh("test.txt", mem);
		
	/////////////////////////////////
	// Helper function to abstract //
	// redundant singal checks     //
	/////////////////////////////////
	
	function R_instr();
		R_instr = (imm_sel_o !== 0 || reg_write_enable_o !== 1 || mem_write_enable_o !== 0 || 
		           write_enable_A_o !== 0 || write_enable_B_o !== 0 || write_enable_C_o !== 0 ||
				   start_o !== 0 || pc_o !== pc_i || wb_sel_o !== 0 || branch_type_o !== 0 || 
				   write_reg_sel_o !== instr_i[24:20] || d_op1_reg_o !== instr_i[19:15] ||
				   d_op2_reg_o !== instr_i[14:10]);
	endfunction
	
	function I_instr();
		I_instr = (imm_sel_o !== 1 || reg_write_enable_o !== 1 || mem_write_enable_o !== 0 || 
		           write_enable_A_o !== 0 || write_enable_B_o !== 0 || write_enable_C_o !== 0 ||
				   start_o !== 0 || pc_o !== pc_i || wb_sel_o !== 0 || branch_type_o !== 0 ||
				   imm_o !== {{17{instr_i[14]}}, instr_i[14:0]} || write_reg_sel_o !== instr_i[24:20] ||
				   d_op1_reg_o !== instr_i[19:15] || d_op2_reg_o !== instr_i[14:10]);
	endfunction
	
	function B_instr();
		B_instr = (imm_sel_o !== 0 || reg_write_enable_o !== 0 || mem_write_enable_o !== 0 || 
		           write_enable_A_o !== 0 || write_enable_B_o !== 0 || write_enable_C_o !== 0 ||
				   start_o !== 0 || pc_o !== pc_i || branch_type_o !== 1 || d_op1_reg_o !== instr_i[19:15] ||
				   imm_o !== {{17{instr_i[24]}}, instr_i[24:20], instr_i[9:0]} || d_op2_reg_o !== instr_i[14:10]);
	endfunction
	
	function j_instr();
		j_instr = (imm_sel_o !== 0 || reg_write_enable_o !== 0 || mem_write_enable_o !== 0 || 
		           write_enable_A_o !== 0 || write_enable_B_o !== 0 || write_enable_C_o !== 0 ||
				   start_o !== 0 || pc_o !== pc_i || d_op2_reg_o !== instr_i[14:10] || d_op1_reg_o !== instr_i[19:15]);
	endfunction
	
	function tpu_instr();
		tpu_instr = (mem_write_enable_o !== 0 || pc_o !== pc_i || branch_type_o !== 0 || d_op1_reg_o !== instr_i[19:15] ||
		             d_op2_reg_o !== instr_i[14:10]);
	endfunction
	
	//////////////////////////////////////
	// Tasks to call instruction checks //
	//////////////////////////////////////
	
	task nop_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (reg_write_enable_o !== 0 || mem_write_enable_o !== 0 || write_enable_A_o !== 0 || d_op2_reg_o !== instr_i[14:10] ||
		    write_enable_B_o !== 0 || write_enable_C_o !== 0 || start_o !== 0 || pc_o !== pc_i || d_op1_reg_o !== instr_i[19:15] ||
			branch_type_o !== 0) begin
			$display("Problem with nop instruction");
			$stop();
		end
	endtask
	
	// R Instructions //
	
	task add_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (R_instr || read_data1_o !== mem[instr_i[19:15]] || read_data2_o !== mem[instr_i[14:10]] || alu_op_o !== 1) begin
			$display("Problem with add instruction");
			$stop();
		end
	endtask
	
	task sub_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (R_instr || read_data1_o !== mem[instr_i[19:15]] || read_data2_o !== mem[instr_i[14:10]] || alu_op_o !== 2) begin
			$display("Problem with sub instruction");
			$stop();
		end
	endtask
	
	task xor_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (R_instr || read_data1_o !== mem[instr_i[19:15]] || read_data2_o !== mem[instr_i[14:10]] || alu_op_o !== 3) begin
			$display("Problem with xor instruction");
			$stop();
		end
	endtask
	
	task or_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (R_instr || read_data1_o !== mem[instr_i[19:15]] || read_data2_o !== mem[instr_i[14:10]] || alu_op_o !== 4) begin
			$display("Problem with or instruction");
			$stop();
		end
	endtask
	
	task and_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (R_instr || read_data1_o !== mem[instr_i[19:15]] || read_data2_o !== mem[instr_i[14:10]] || alu_op_o !== 5) begin
			$display("Problem with and instruction");
			$stop();
		end
	endtask
	
	task sll_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (R_instr || read_data1_o !== mem[instr_i[19:15]] || read_data2_o !== mem[instr_i[14:10]] || alu_op_o !== 6) begin
			$display("Problem with sll instruction");
			$stop();
		end
	endtask
	
	task srl_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (R_instr || read_data1_o !== mem[instr_i[19:15]] || read_data2_o !== mem[instr_i[14:10]] || alu_op_o !== 7) begin
			$display("Problem with srl instruction");
			$stop();
		end
	endtask
	
	task sra_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (R_instr || read_data1_o !== mem[instr_i[19:15]] || read_data2_o !== mem[instr_i[14:10]] || alu_op_o !== 8) begin
			$display("Problem with sra instruction");
			$stop();
		end
	endtask
	
	task slt_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (R_instr || read_data1_o !== mem[instr_i[19:15]] || read_data2_o !== mem[instr_i[14:10]] || alu_op_o !== 9) begin
			$display("Problem with slt instruction");
			$stop();
		end
	endtask
	
	task mul_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (R_instr || read_data1_o !== mem[instr_i[19:15]] || read_data2_o !== mem[instr_i[14:10]] || alu_op_o !== 10) begin
			$display("Problem with mul instruction");
			$stop();
		end
	endtask
	
	// I Instructions //
	
	task addi_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (I_instr || read_data1_o !== mem[instr_i[19:15]] || alu_op_o !== 1) begin
			$display("Problem with addi instruction");
			$stop();
		end
	endtask
	
	task subi_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (I_instr || read_data1_o !== mem[instr_i[19:15]] || alu_op_o !== 2) begin
			$display("Problem with subi instruction");
			$stop();
		end
	endtask
	
	task xori_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (I_instr || read_data1_o !== mem[instr_i[19:15]] || alu_op_o !== 3) begin
			$display("Problem with xori instruction");
			$stop();
		end
	endtask
	
	task ori_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (I_instr || read_data1_o !== mem[instr_i[19:15]] || alu_op_o !== 4) begin
			$display("Problem with ori instruction");
			$stop();
		end
	endtask
	
	task andi_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (I_instr || read_data1_o !== mem[instr_i[19:15]] || alu_op_o !== 5) begin
			$display("Problem with andi instruction");
			$stop();
		end
	endtask
	
	task slli_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (I_instr || read_data1_o !== mem[instr_i[19:15]] || alu_op_o !== 6) begin
			$display("Problem with slli instruction");
			$stop();
		end
	endtask
	
	task srli_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (I_instr || read_data1_o !== mem[instr_i[19:15]] || alu_op_o !== 7) begin
			$display("Problem with srli instruction");
			$stop();
		end
	endtask
	
	task srai_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (I_instr || read_data1_o !== mem[instr_i[19:15]] || alu_op_o !== 8) begin
			$display("Problem with srai instruction");
			$stop();
		end
	endtask
	
	task slti_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (I_instr || read_data1_o !== mem[instr_i[19:15]] || alu_op_o !== 9) begin
			$display("Problem with slti instruction");
			$stop();
		end
	endtask
	
	task lui_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (I_instr || read_data1_o !== mem[instr_i[19:15]] || alu_op_o !== 11) begin
			$display("Problem with lui instruction");
			$stop();
		end
	endtask
	
	// Branch Instructions //
	
	task beq_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (B_instr || read_data1_o !== mem[instr_i[19:15]] || read_data2_o !== mem[instr_i[14:10]] || alu_op_o !== 12) begin
			$display("Problem with beq instruction");
			$stop();
		end
	endtask
	
	task bne_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (B_instr || read_data1_o !== mem[instr_i[19:15]] || read_data2_o !== mem[instr_i[14:10]] || alu_op_o !== 13) begin
			$display("Problem with bne instruction");
			$stop();
		end
	endtask
	
	task blt_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (B_instr || read_data1_o !== mem[instr_i[19:15]] || read_data2_o !== mem[instr_i[14:10]] || alu_op_o !== 14) begin
			$display("Problem with blt instruction");
			$stop();
		end
	endtask
	
	task bgt_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (B_instr || read_data1_o !== mem[instr_i[19:15]] || read_data2_o !== mem[instr_i[14:10]] || alu_op_o !== 15) begin
			$display("Problem with bgt instruction");
			$stop();
		end
	endtask
	
	// Jump Instructions //
	
	task j_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (j_instr || imm_o !== {{17{instr_i[14]}}, instr_i[14:0]} || branch_type_o !== 2) begin
			$display("Problem with j instruction");
			$stop();
		end
	endtask
	
	task jr_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (j_instr || read_data1_o !== mem[instr_i[19:15]] || branch_type_o !== 3) begin
			$display("Problem with jr instruction");
			$stop();
		end
	endtask
	
	// lw and sw instructions //
	
	task lw_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (imm_sel_o !== 1 || reg_write_enable_o !== 1 || mem_write_enable_o !== 0 || d_op1_reg_o !== instr_i[19:15] ||
		    read_data1_o !== mem[instr_i[19:15]] || branch_type_o !== 0 || write_enable_A_o !== 0 || d_op2_reg_o !== instr_i[14:10] ||
			write_enable_B_o !== 0 || write_enable_C_o !== 0 || start_o !== 0 || imm_o !== {{17{instr_i[14]}}, instr_i[14:0]} ||
			pc_o !== pc_i || alu_op_o !== 1 || wb_sel_o !== 1 || write_reg_sel_o !== instr_i[24:20]) begin
			$display("Problem with lw instruction");
			$stop();
		end
	endtask
	
	task sw_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (imm_sel_o !== 1 || reg_write_enable_o !== 0 || mem_write_enable_o !== 1 || read_data2_o !== mem[instr_i[14:10]] ||
		    read_data1_o !== mem[instr_i[19:15]] || branch_type_o !== 0 || write_enable_A_o !== 0 || d_op2_reg_o !== instr_i[14:10] ||
			write_enable_B_o !== 0 || write_enable_C_o !== 0 || start_o !== 0 || imm_o !== {{17{instr_i[14]}}, instr_i[14:0]} ||
			pc_o !== pc_i || alu_op_o !== 1 || d_op1_reg_o !== instr_i[19:15]) begin
			$display("Problem with sw instruction");
			$stop();
		end
	endtask
	
	// tpu Instructions //
	
	task matmul_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (tpu_instr || start_o !== 1 || reg_write_enable_o !== 0 ||
			write_enable_A_o !== 0 || write_enable_B_o !== 0 || write_enable_C_o !== 0) begin
			$display("Problem with matmul instruction");
			$stop();
		end
	endtask
	
	task lam_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (tpu_instr || read_data1_o !== mem[instr_i[19:15]] || start_o !== 0 ||
			write_enable_A_o !== 1 || write_enable_B_o !== 0 || write_enable_C_o !== 0 || 
			row_o !== instr_i[17:13] || col_o !== instr_i[12:8] || reg_write_enable_o !== 0) begin
			$display("Problem with lam instruction");
			$stop();
		end
	endtask
	
	task lbm_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (tpu_instr || read_data1_o !== mem[instr_i[19:15]] || start_o !== 0 ||
			write_enable_A_o !== 0 || write_enable_B_o !== 1 || write_enable_C_o !== 0 || 
			row_o !== instr_i[17:13] || col_o !== instr_i[12:8] || reg_write_enable_o !== 0) begin
			$display("Problem with lbm instruction");
			$stop();
		end
	endtask
	
	task lacc_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (tpu_instr || read_data1_o !== mem[instr_i[19:15]] || start_o !== 0 ||
			write_enable_A_o !== 0 || write_enable_B_o !== 0 || write_enable_C_o !== 1 || 
			row_o !== instr_i[17:13] || col_o !== instr_i[12:8] || reg_write_enable_o !== 0) begin
			$display("Problem with lacc instruction");
			$stop();
		end
	endtask
	
	task racc_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (tpu_instr || start_o !== 0 || write_reg_sel_o !== instr_i[24:20] || wb_sel_o !== 2 ||
			write_enable_A_o !== 0 || write_enable_B_o !== 0 || write_enable_C_o !== 0 || 
			row_o !== instr_i[17:13] || col_o !== instr_i[12:8] || reg_write_enable_o !== 1) begin
			$display("Problem with racc instruction");
			$stop();
		end
	endtask
	
	task undef_check();
		@(posedge clk_i);
		@(negedge clk_i);
		if (reg_write_enable_o !== 0 || mem_write_enable_o !== 0 || write_enable_A_o !== 0 || d_op2_reg_o !== instr_i[14:10] ||
		    write_enable_B_o !== 0 || write_enable_C_o !== 0 || start_o !== 0 || pc_o !== pc_i || d_op1_reg_o !== instr_i[19:15]) begin
			$display("Problem with undefined instruction");
			$stop();
		end
	endtask
	
	//////////////////////////////////////////////////////////////
	// Task that uses opcode to call required instruction check //
	//////////////////////////////////////////////////////////////
	
	task call_checks();
    	case(instr_i[31:25])
            7'h00 : begin // NOP
				nop_check();
			end
			7'h01 : begin // add
				add_check();
			end
			7'h02 : begin // sub
				sub_check();
			end
			7'h03 : begin // xor
				xor_check();
			end
			7'h04 : begin // or
				or_check();
			end
			7'h05 : begin // and
				and_check();
			end
			7'h06 : begin // sll
				sll_check();
			end
			7'h07 : begin // srl
				srl_check();
			end
			7'h08 : begin // sra
				sra_check();
			end 
			7'h09 : begin // slt
				slt_check();
			end
			7'h0A : begin // mul
				mul_check();
			end
			7'h11 : begin // addi
				addi_check();
			end
			7'h13 : begin // xori
				xori_check();
			end
			7'h14 : begin // ori
				ori_check();
			end
			7'h15 : begin // andi
				andi_check();
			end
			7'h16 : begin // slli
				slli_check();
			end
			7'h17 : begin // srli
				srli_check();
			end
			7'h18 : begin // srai
				srai_check();
			end
			7'h19 : begin // slti
				slti_check();
			end
			7'h1B : begin // lui
				lui_check();
			end
			7'h20 : begin // lw
				lw_check();
			end
			7'h21 : begin // sw
				sw_check();
			end
			7'h3C : begin // beq
				beq_check();
			end
			7'h3D : begin // bne
				bne_check();
			end
			7'h3E : begin // blt
				blt_check();
			end
			7'h3F : begin // bgt
				bgt_check();
			end
			7'h50 : begin // matmul
				matmul_check();
			end
			7'h51 : begin // lam
				lam_check();
			end
			7'h52 : begin // lbm
				lbm_check();
			end
			7'h53 : begin // lacc
				lacc_check();
			end
			7'h54 : begin // racc
				racc_check();
			end
			7'h7E : begin // j
				j_check();
			end
			7'h7F : begin // jr
				jr_check();
			end
			default : begin
				undef_check();
			end
        	endcase
	endtask	
	
	initial begin
		clk_i = 0;
		rst_n_i = 1;
		pc_i = 0;
		flush_i = 0;
		stall_i = 0;
		@(posedge clk_i);
		
		// Test 1: Flush Test //
		flush_i = 1;
		@(posedge clk_i);
		@(negedge clk_i);
		flush_i = 0;
		// Check if important signals are flushed //
		if (reg_write_enable_o !== 0 || mem_write_enable_o !== 0 || write_enable_A_o !== 0 || 
		    write_enable_B_o !== 0 || write_enable_C_o !== 0 || start_o !== 0 || branch_type_o !== 0) begin
			$display("Flush not conducted properly");
			$stop();
		end
		
		// Test 2: Instructions with no writes //
		reg_write_enable_i = 0;
		for (int i = 0; i < TIME_PER_INSTR; i++) begin
			instr_i = $random();
			call_checks();
		end
		
		// Test 3: Stall Test //
		imm_sel_old = imm_sel_o;
		reg_write_enable_old = reg_write_enable_o;
		mem_write_enable_old = mem_write_enable_o;
		write_enable_A_old = write_enable_A_o;
		write_enable_B_old = write_enable_B_o;
		write_enable_C_old = write_enable_C_o;
		start_old = start_o;
		read_data1_old = read_data1_o;
		read_data2_old = read_data2_o;
		imm_old = imm_o;
		pc_old = pc_o;
		alu_op_old = alu_op_o;
		wb_sel_old = wb_sel_o;
		branch_type_old = branch_type_o;
		write_reg_sel_old = write_reg_sel_o;
		col_old = col_o;
		row_old = row_o;
	
		stall_i = 1;
		@(posedge clk_i);
		@(negedge clk_i);
		stall_i = 0;
		
		if (imm_sel_old !== imm_sel_o || reg_write_enable_old !== reg_write_enable_o ||
		    mem_write_enable_old !== mem_write_enable_o || write_enable_A_old !== write_enable_A_o ||
			write_enable_B_old !== write_enable_B_o || write_enable_C_old !== write_enable_C_o ||
			start_old !== start_o || read_data1_old !== read_data1_o || read_data2_old !== read_data2_o ||
			imm_old !== imm_o || pc_old !== pc_o || alu_op_old !== alu_op_o || wb_sel_old !== wb_sel_o ||
			branch_type_old !== branch_type_o || write_reg_sel_old !== write_reg_sel_o ||
			col_old !== col_o || row_old !== row_o) begin
			$display("Problem with the stall signal");
			$stop();
		end
		
		// Test 4: Reset Test //
		rst_n_i = 0;
		@(posedge clk_i);
		rst_n_i = 1;
		// Check if important signals are reset //
		if (reg_write_enable_o !== 0 || mem_write_enable_o !== 0 || write_enable_A_o !== 0 || 
		    write_enable_B_o !== 0 || write_enable_C_o !== 0 || start_o !== 0 || branch_type_o !== 0) begin
			$display("Reset not conducted properly");
			$stop();
		end

		$display("Yahoo! All Tests Passed");
		$stop();
	end
	
	always
		#5 clk_i = ~clk_i;

endmodule