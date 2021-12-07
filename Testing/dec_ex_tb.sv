module dec_ex_tb();
	// Decode and Execute is one big block 			  //
	// Vary Decode inputs and observe execute outputs //
	
	localparam TIME_PER_INSTR = 10**4;
	
	logic clk_i, rst_n_i, flush_dec, reg_write_enable_dec, stall_dec;
	logic [4:0] reg_write_dst_dec;
	logic [31:0] instr_i, write_data_i, pc_dec;
	logic [4:0] d_op2_reg_o, d_op1_reg_o;
	
	logic flush_ex, stall_ex;
	logic [31:0] read_data1_i, read_data2_i, imm_i, pc_i, forward_data_i;
	logic [3:0] alu_op_i;
	logic imm_sel_i, reg_write_enable_i, mem_write_enable_i;
	logic [1:0] branch_type_i, forward_en_i, wb_sel_i;
	logic [4:0] reg_write_dst_i, col_i, row_i;
	logic start_i, write_enable_A_i, write_enable_B_i, write_enable_C_i;
	
	logic signed [31:0] result_o;
	logic [31:0] pc_o, cout_o, read_data2_o;
	logic reg_write_enable_o, mem_write_enable_o, branch_dec_o;
	logic [4:0] reg_write_dst_o;
	logic [4:0] e_dest_reg_o;
	logic [1:0] branch_inst_o, wb_sel_o;
	logic e_valid_o;
	
	logic [31:0] mem [31:0];
	logic signed [31:0] exp_result;
	
	initial
		$readmemh("./test_1.txt", mem);
		
	decode dec_DUT (.clk_i(clk_i), .rst_n_i(rst_n_i), .instr_i(instr_i), .write_data_i(write_data_i),
					.flush_i(flush_dec), .stall_i(stall_dec), .reg_write_enable_i(reg_write_enable_dec), .reg_write_dst_i(reg_write_dst_dec),
					.pc_i(pc_dec), .reg_write_enable_o(reg_write_enable_i), .mem_write_enable_o(mem_write_enable_i), .write_enable_A_o(write_enable_A_i),
					.write_enable_B_o(write_enable_B_i), .write_enable_C_o(write_enable_C_i), .start_o(start_i), .read_data1_o(read_data1_i), .read_data2_o(read_data2_i),
					.imm_o(imm_i), .pc_o(pc_i), .alu_op_o(alu_op_i), .wb_sel_o(wb_sel_i), .branch_type_o(branch_type_i), .reg_write_dst_o(reg_write_dst_i), .col_o(col_i),
					.row_o(row_i), .imm_sel_o(imm_sel_i), .d_op2_reg_o(d_op2_reg_o), .d_op1_reg_o(d_op1_reg_o));
					
	execute ex_DUT (.clk_i(clk_i), .rst_n_i(rst_n_i), .flush_i(flush_ex), .stall_i(stall_ex), .read_data1_i(read_data1_i), .read_data2_i(read_data2_i), .imm_i(imm_i),
					.pc_i(pc_i), .forward_data_i(forward_data_i), .alu_op_i(alu_op_i), .imm_sel_i(imm_sel_i), .wb_sel_i(wb_sel_i), .reg_write_enable_i(reg_write_enable_i),
					.mem_write_enable_i(mem_write_enable_i), .branch_type_i(branch_type_i), .forward_en_i(forward_en_i), .reg_write_dst_i(reg_write_dst_i), .col_i(col_i), 
					.row_i(row_i), .start_i(start_i), .write_enable_A_i(write_enable_A_i), .write_enable_B_i(write_enable_B_i), .write_enable_C_i(write_enable_C_i),
					.result_o(result_o), .pc_o(pc_o), .cout_o(cout_o), .read_data2_o(read_data2_o), .wb_sel_o(wb_sel_o), .reg_write_enable_o(reg_write_enable_o),
					.mem_write_enable_o(mem_write_enable_o), .branch_dec_o(branch_dec_o), .reg_write_dst_o(reg_write_dst_o), .e_dest_reg_o(e_dest_reg_o),
					.branch_inst_o(branch_inst_o), .e_valid_o(e_valid_o));
					
	// Tasks to reuse frequently used checks //
	
	function R_I_instr();
		R_I_instr = (pc_o !==  pc_dec || wb_sel_o !== 0 || reg_write_enable_o !== 1 || mem_write_enable_o !== 0 || reg_write_dst_o !== instr_i[24:20]);
	endfunction
		
	function B_instr();
		B_instr = (result_o !== 32'hxxxx || reg_write_enable_o !== 0 || mem_write_enable_o !== 0);
	endfunction
	
	// NOP Check //
	
	task nop_check();
		if (pc_o !==  pc_dec || reg_write_enable_o !== 0 || mem_write_enable_o !== 0) begin
			$display("nop instruction does not work");
			$stop();
		end
	endtask
	
	// R Instructions //
	
	task add_check();
		exp_result = mem[instr_i[14:10]] + mem[instr_i[19:15]];
		if (R_I_instr || result_o !== exp_result) begin
			$display("add instruction not working correctly");
			$stop();
		end
	endtask
	
	task sub_check();
		exp_result =  mem[instr_i[19:15]] -  mem[instr_i[14:10]];
		if (R_I_instr || result_o !== exp_result) begin
			$display("sub instruction not working correctly");
			$stop();
		end
	endtask
	
	task xor_check();
		exp_result = mem[instr_i[19:15]] ^ mem[instr_i[14:10]];
		if (R_I_instr || result_o !== exp_result) begin
			$display("xor instruction not working correctly");
			$stop();
		end
	endtask
	
	task or_check();
		exp_result = mem[instr_i[19:15]] | mem[instr_i[14:10]];
		if (R_I_instr || result_o !== exp_result) begin
			$display("or instruction not working correctly");
			$stop();
		end
	endtask
	
	task and_check();
		exp_result = mem[instr_i[19:15]] & mem[instr_i[14:10]];
		if (R_I_instr || result_o !== exp_result) begin
			$display("and instruction not working correctly");
			$stop();
		end
	endtask
	
	task sll_check();
		exp_result = mem[instr_i[19:15]] << mem[instr_i[14:10]][4:0];
		if (R_I_instr || result_o !== exp_result) begin
			$display("sll instruction not working correctly");
			$stop();
		end
	endtask
	
	task srl_check();
		exp_result = mem[instr_i[19:15]] >> mem[instr_i[14:10]][4:0];
		if (R_I_instr || result_o !== exp_result) begin
			$display("srl instruction not working correctly");
			$stop();
		end
	endtask
	
	task sra_check();
		exp_result = $signed(mem[instr_i[19:15]]) >>> mem[instr_i[14:10]][4:0];
		if (R_I_instr || result_o !== exp_result) begin
			$display("sra instruction not working correctly");
			$stop();
		end
	endtask
	
	task slt_check();
		exp_result = $signed(mem[instr_i[19:15]]) < $signed(mem[instr_i[14:10]]);
		if (R_I_instr || result_o !== exp_result) begin
			$display("slt instruction not working correctly");
			$stop();
		end
	endtask
	
	task mul_check();
		exp_result = mem[instr_i[19:15]] * mem[instr_i[14:10]];
		if (R_I_instr || result_o !== exp_result) begin
			$display("mul instruction not working correctly");
			$stop();
		end
	endtask
	
	// Immediate Instructions //
	
	task addi_check();
		exp_result = mem[instr_i[19:15]] + {{17{instr_i[14]}}, instr_i[14:0]};
		if (R_I_instr || result_o !== exp_result) begin
			$display("addi instruction not working correctly");
			$stop();
		end
	endtask
	
	task subi_check();
		exp_result =  mem[instr_i[19:15]] -  {{17{instr_i[14]}}, instr_i[14:0]};
		if (R_I_instr || result_o !== exp_result) begin
			$display("subi instruction not working correctly");
			$stop();
		end
	endtask
	
	task xori_check();
		exp_result = mem[instr_i[19:15]] ^ {{17{instr_i[14]}}, instr_i[14:0]};
		if (R_I_instr || result_o !== exp_result) begin
			$display("xori instruction not working correctly");
			$stop();
		end
	endtask
	
	task ori_check();
		exp_result = mem[instr_i[19:15]] | {{17{instr_i[14]}}, instr_i[14:0]};
		if (R_I_instr || result_o !== exp_result) begin
			$display("ori instruction not working correctly");
			$stop();
		end
	endtask
	
	task andi_check();
		exp_result = mem[instr_i[19:15]] & {{17{instr_i[14]}}, instr_i[14:0]};
		if (R_I_instr || result_o !== exp_result) begin
			$display("andi instruction not working correctly");
			$stop();
		end
	endtask
	
	task slli_check();
		exp_result = mem[instr_i[19:15]] << instr_i[4:0];
		if (R_I_instr || result_o !== exp_result) begin
			$display("slli instruction not working correctly");
			$stop();
		end
	endtask
	
	task srli_check();
		exp_result = mem[instr_i[19:15]] >> instr_i[4:0];
		if (R_I_instr || result_o !== exp_result) begin
			$display("srli instruction not working correctly");
			$stop();
		end
	endtask
	
	task srai_check();
		exp_result = $signed(mem[instr_i[19:15]]) >>> instr_i[4:0];
		if (R_I_instr || result_o !== exp_result) begin
			$display("srai instruction not working correctly");
			$stop();
		end
	endtask
	
	task slti_check();
		exp_result = $signed(mem[instr_i[19:15]]) < $signed(instr_i[4:0]);
		if (R_I_instr || result_o !== exp_result) begin
			$display("slti instruction not working correctly");
			$stop();
		end
	endtask
	
	task lui_check();
		exp_result = {{17{instr_i[14]}}, instr_i[14:0]} << 12;
		if (R_I_instr || result_o !== exp_result) begin
			$display("lui instruction not working correctly");
			$stop();
		end
	endtask
	
	// Branch Instructions //
	
	task beq_check();
		if (B_instr) begin
			$display("beq is not working correctly");
			$stop();
		end
		if (mem[instr_i[19:15]] === mem[instr_i[14:10]]) begin
			if (pc_o !== pc_dec + {{17{instr_i[24]}}, instr_i[24:20], instr_i[9:0]}) begin
				$display("beq is not updating pc");
				$stop();
			end
		end
		else
			if (pc_o !== pc_dec) begin
				$display("beq is not holding pc");
				$stop();
			end
	endtask
	
	task bne_check();
		if (B_instr) begin
			$display("bne is not working correctly");
			$stop();
		end
		if (mem[instr_i[19:15]] !== mem[instr_i[14:10]]) begin
			if (pc_o !== pc_dec + {{17{instr_i[24]}}, instr_i[24:20], instr_i[9:0]}) begin
				$display("bne is not updating pc");
				$stop();
			end
		end
		else
			if (pc_o !== pc_dec) begin
				$display("bne is not holding pc");
				$stop();
			end
	endtask
	
	task bgt_check();
		if (B_instr) begin
			$display("bgt is not working correctly");
			$stop();
		end
		if ($signed(mem[instr_i[19:15]]) > $signed(mem[instr_i[14:10]])) begin
			if (pc_o !== pc_dec + {{17{instr_i[24]}}, instr_i[24:20], instr_i[9:0]}) begin
				$display("bgt is not updating pc");
				$stop();
			end
		end
		else
			if (pc_o !== pc_dec) begin
				$display("bgt is not holding pc");
				$stop();
			end
	endtask
	
	task blt_check();
		if (B_instr) begin
			$display("blt is not working correctly");
			$stop();
		end
		if ($signed(mem[instr_i[19:15]]) < $signed(mem[instr_i[14:10]])) begin
			if (pc_o !== pc_dec + {{17{instr_i[24]}}, instr_i[24:20], instr_i[9:0]}) begin
				$display("blt is not updating pc");
				$stop();
			end
		end
		else
			if (pc_o !== pc_dec) begin
				$display("blt is not holding pc");
				$stop();
			end
	endtask
	
	// Jump Instructions //
	
	task j_check();
		if (pc_o !== pc_dec + {{17{instr_i[14]}}, instr_i[14:0]} ||
			reg_write_enable_o !== 0 || mem_write_enable_o !== 0) begin
			$display("j is bad");
			$stop();
		end
	endtask

	task jr_check();
		if (pc_o !== mem[instr_i[19:15]] || reg_write_enable_o !== 0 || mem_write_enable_o !== 0) begin
			$display("jr is bad");
			$stop();
		end
	endtask
	
	// load and store instructions //
	
	task lw_check();
		if (result_o !== $signed(mem[instr_i[19:15]]) + $signed({{17{instr_i[14]}}, instr_i[14:0]}) ||
			pc_o !== pc_dec || reg_write_enable_o !== 1 || mem_write_enable_o !== 0 || reg_write_dst_o !== instr_i[24:20] ||
			wb_sel_o !== 1) begin
			$display("lw is not functioning correctly");
			$stop();
		end
	endtask
	
	task sw_check();
		if (result_o !== $signed(mem[instr_i[19:15]]) + $signed({{17{instr_i[24]}}, instr_i[24:20], instr_i[9:0]}) || 
		    read_data2_o !== mem[instr_i[14:10]] || pc_o !== pc_dec || reg_write_enable_o !== 0 || mem_write_enable_o !== 1) begin
			$display("sw is not functioning correctly");
			$stop();
		end
	endtask
	
	// tpu instruction //
		
	task matmul_check();
		fork
			begin : timeout1
				repeat(10**5) @(posedge clk_i);
				$display("Timed out waiting for TPU to complte");
				$stop();
			end
			begin
				while(e_valid_o !== 1) #1;
				disable timeout1;
			end
		join
		if (pc_o !== pc_dec || reg_write_enable_o !== 0 || mem_write_enable_o !== 0) begin
			$display("matmul signals are bad");
			$stop();
		end
	endtask
		
	task lam_check();
		if (pc_o !== pc_dec || reg_write_enable_o !== 0 || mem_write_enable_o !== 0) begin
			$display("lam does not default the outputs");
			$stop();
		end
	endtask
	
	task lbm_check();
		if (pc_o !== pc_dec || reg_write_enable_o !== 0 || mem_write_enable_o !== 0) begin
			$display("lbm does not default the outputs");
			$stop();
		end
	endtask
	
	task lacc_check();
		if (pc_o !== pc_dec || reg_write_enable_o !== 0 || mem_write_enable_o !== 0) begin
			$display("lacc does not default the outputs");
			$stop();
		end
	endtask
	
	task racc_check();
		if (pc_o !== pc_i || reg_write_enable_o !== 1 || mem_write_enable_o !== 0 || reg_write_dst_o !== instr_i[24:20] ||
			wb_sel_o !== 2) begin
			$display("racc signals are bad");
			$stop();
		end
	endtask
	
	task undef_check();
		if (pc_o !== pc_dec || reg_write_enable_o !== 0 || mem_write_enable_o !== 0) begin
			$display("Undefined opcode is bad");
			$stop();
		end
	endtask
	
	task call_checks();
	
		// 2 stages to go through //
		repeat(2) @(posedge clk_i);
		@(negedge clk_i);
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
			7'h3E : begin // bgt
				bgt_check();
			end
			7'h3F : begin // blt
				blt_check();
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
		rst_n_i = 1;
		clk_i = 0;
		flush_dec = 0;
		flush_ex = 0;
		stall_dec = 0;
		stall_ex = 0;
		reg_write_enable_dec = 0;
		pc_dec = $random();
		forward_en_i = 0;
		@(posedge clk_i);
		
		// Test 1: Random Instructions //
		for (int i = 0; i < TIME_PER_INSTR; i++) begin
			instr_i = $random();
			call_checks();
		end
		
		rst_n_i = 0;
		@(posedge clk_i);
		rst_n_i = 1;
		
		// Test 2: Reset Test //
		if (pc_o !== 0 || reg_write_enable_o !== 0 || mem_write_enable_o !== 0) begin
			$display("Problem with the reset");
			$stop();
		end
		
		$display("Yahoo! All Tests Passed");
		$stop();
	end

	always
		#5 clk_i =  ~clk_i;
endmodule