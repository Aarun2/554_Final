module execute_tb();

	localparam NUM_ALU_OPS = 10**5;
	
	logic clk_i, rst_n_i, flush_i, stall_i;
	logic signed [31:0] read_data1_i, read_data2_i, imm_i, forward_data_i;
	logic [31:0] pc_i;
	logic [3:0] alu_op_i;
	logic imm_sel_i, reg_write_enable_i, mem_write_enable_i;
	logic [1:0] branch_type_i, forward_en_i, wb_sel_i;
	logic [4:0] reg_write_dst_i, col_i, row_i;
	logic start_i, write_enable_A_i, write_enable_B_i, write_enable_C_i;
	
	logic [31:0] result_o;
	logic reg_write_enable_o, mem_write_enable_o;
	logic [4:0] reg_write_dst_o;
	logic [31:0] pc_o, cout_o, read_data2_o;
	logic [4:0] e_dest_reg_o;
	logic [1:0] branch_inst_o, wb_sel_o;
	logic e_valid_o, branch_dec_o;
	
	logic [31:0] result_old;
	logic [1:0] wb_sel_old;
	logic reg_write_enable_old, mem_write_enable_old;
	logic [4:0] write_reg_sel_old;
	logic [31:0] pc_old, cout_old, read_data2_old;
	
	logic signed [31:0] b_i, expected;
	
	execute e_DUT (.*);
	
	// Tasks that check functionality if design //
	
	// Branch Checks //
	task no_branch();
		if (pc_o !== pc_i) begin
			$display("Not a branch or jump but pc changes");
			$stop();
		end
	endtask
	
	task br_branch();
		b_i = imm_sel_i ? imm_i : read_data2_i;
		case (alu_op_i)
			4'b1100 : // beq
				if (read_data1_i == b_i) begin
					if (pc_o !== pc_i + imm_i) begin
						$display("Branch equals was true but pc not updated");
						$stop();
					end
				end
				else begin
					if (pc_o !== pc_i) begin
						$display("Branch was not equal so pc should not update");
						$stop();
					end
				end
			4'b1101 : // bne
				if (read_data1_i != b_i) begin
					if (pc_o !== pc_i + imm_i) begin
						$display("Branch not equal but pc not updated");
						$stop();
					end
				end
				else begin
					if (pc_o !== pc_i) begin
						$display("Branch was equal so pc should not update");
						$stop();
					end
				end
			4'b1110 : // bgt
				if (read_data1_i > b_i) begin
					if (pc_o !== pc_i + imm_i) begin
						$display("Branch greater than but pc not updated");
						$stop();
					end
				end
				else begin
					if (pc_o !== pc_i) begin
						$display("Branch was not greater than so pc should not update");
						$stop();
					end
				end
			4'b1111 : // blt
				if (read_data1_i < b_i) begin
					if (pc_o !== pc_i + imm_i) begin
						$display("Branch less than but pc not updated");
						$stop();
					end
				end
				else begin
					if (pc_o !== pc_i) begin
						$display("Branch was not less than so pc should not update");
						$stop();
					end
				end
			default :
				if (pc_o !== pc_i) begin
					$display("Not a valid branch so should not update");
					$stop();
				end
		endcase
	endtask
	
	task j_branch();
		if (pc_o !== pc_i + imm_i) begin
			$display("Jump Instruction should always update PC");
			$stop();
		end
	endtask
	
	task jr_branch();
		if (pc_o !== read_data1_i) begin
			$display("Jr Instruction should always update PC");
			$stop();
		end
	endtask
	
	task branch_check();
		case (branch_type_i)
			2'b00 :
				no_branch();
			2'b01 :
				br_branch();
			2'b10 :
				j_branch();
			default :
				jr_branch();
		endcase
	endtask
	
	// EX/MEM Checks //
	task ex_mem_check();
		if (wb_sel_o !== wb_sel_i || reg_write_enable_o !== reg_write_enable_i ||
			mem_write_enable_o !== mem_write_enable_i || reg_write_dst_o !== reg_write_dst_i ||
			read_data2_o !== read_data2_i) begin
			$display("No data is forwarded with no flush or stalls and so mem stage should get execute signals");
			$stop();
		end
	endtask

	// ALU Checks //
	task add_check();
		b_i = imm_sel_i ? imm_i : read_data2_i;
		expected = read_data1_i + b_i;
		if (expected !== result_o) begin
			$display("Problem with the add instruction");
			$stop();
		end
	endtask
	
	task sub_check();
		b_i = imm_sel_i ? imm_i : read_data2_i;
		expected = read_data1_i - b_i;
		if (expected !== result_o) begin
			$display("Problem with the sub instruction");
			$stop();
		end
	endtask
	
	task xor_check();
		b_i = imm_sel_i ? imm_i : read_data2_i;
		expected = read_data1_i ^ b_i;
		if (expected !== result_o) begin
			$display("Problem with the xor instruction");
			$stop();
		end
	endtask
	
	task or_check();
		b_i = imm_sel_i ? imm_i : read_data2_i;
		expected = read_data1_i | b_i;
		if (expected !== result_o) begin
			$display("Problem with the or instruction");
			$stop();
		end
	endtask
	
	task and_check();
		b_i = imm_sel_i ? imm_i : read_data2_i;
		expected  = read_data1_i & b_i;
		if (expected !== result_o) begin
			$display("Problem with the and instruction");
			$stop();
		end
	endtask
	
	task sll_check();
		b_i = imm_sel_i ? imm_i : read_data2_i;
		expected = read_data1_i << b_i[4:0]; 
		if (expected !== result_o) begin
			$display("Problem with the sll instruction");
			$stop();
		end
	endtask
	
	task srl_check();
		b_i = imm_sel_i ? imm_i : read_data2_i;
		expected = read_data1_i >> b_i[4:0];
		if (expected !== result_o) begin
			$display("Problem with the srl instruction");
			$stop();
		end
	endtask
	
	task sra_check();
		b_i = imm_sel_i ? imm_i : read_data2_i;
		expected = read_data1_i >>> b_i[4:0];
		if (expected !== result_o) begin
			$display("Problem with the sra instruction");
			$stop();
		end
	endtask
	
	task slt_check();
		b_i = imm_sel_i ? imm_i : read_data2_i;
		expected = (read_data1_i < b_i);
		if (expected !== result_o) begin
			$display("Problem with the slt instruction");
			$stop();
		end
	endtask
	
	task mult_check();
		b_i = imm_sel_i ? imm_i : read_data2_i;
		expected = read_data1_i * b_i;
		if (expected !== result_o) begin
			$display("Problem with the mult instruction");
			$stop();
		end
	endtask
	
	task lui_check();
		b_i = imm_sel_i ? imm_i : read_data2_i;
		expected = b_i << 12; 
		if (expected !== result_o) begin
			$display("Problem with the lui instruction");
			$stop();
		end
	endtask
	
	task alu_check();
		case (alu_op_i)
			4'b0001 : add_check(); // a_i + b_i
            4'b0010 : sub_check(); // a_i - b_i
            4'b0011 : xor_check(); // a_i ^ b_i
            4'b0100 : or_check(); // a_i | b_i
            4'b0101 : and_check(); // a_i & b_i
            4'b0110 : sll_check(); // a_i sll b_i
            4'b0111 : srl_check(); // a_i srl b_i
            4'b1000 : sra_check(); // a_i sra b_i
            4'b1001 : slt_check(); // set less than 
            4'b1010 : mult_check(); // a_i * b_i
			4'b1011 : lui_check(); // load upper immediate
			default : ; // do nothing
		endcase
	endtask
	
	initial begin
		clk_i = 0;
		rst_n_i = 0;
		flush_i = 0;
		stall_i = 0;
		pc_i = $random();
		forward_en_i = 0;
		start_i = 0;
		write_enable_A_i = 0;
		write_enable_B_i = 0;
		write_enable_C_i = 0;
		@(posedge clk_i);
		rst_n_i = 1;
		// Test 1: Reset Test //
		if (reg_write_enable_o !== 0 || mem_write_enable_o !== 0 || pc_o !== 0) begin
			$display("Problem with reset");
			$stop();
		end
		
		// Test 2: Alu and Branch Test //
		for (int i = 0; i < NUM_ALU_OPS; i++) begin
			read_data1_i = $random();
			read_data2_i = $random();
			imm_i = $random();
			pc_i = $random();
			alu_op_i = $random();
			imm_sel_i = $random();
			wb_sel_i = $random();
			reg_write_enable_i = $random();
			mem_write_enable_i = $random();
			branch_type_i = $random();
			reg_write_dst_i = $random();
			@(posedge clk_i);
			@(negedge clk_i);
			branch_check();
			alu_check();
			ex_mem_check();
		end
	
		// Test 3: Stall Test //
		stall_i = 1;
		result_old = result_o;
		wb_sel_old = wb_sel_o;
		reg_write_enable_old = reg_write_enable_o;
		mem_write_enable_old = mem_write_enable_o;
		write_reg_sel_old = reg_write_dst_o;
		pc_old = pc_o;
		cout_old = cout_o;
		read_data2_old = read_data2_o;
		
		@(posedge clk_i);
		stall_i = 0;
		if (result_old !== result_o || wb_sel_old !== wb_sel_o || reg_write_enable_old !== reg_write_enable_o ||
		    mem_write_enable_old !== mem_write_enable_o || write_reg_sel_old !== reg_write_dst_o || pc_old !== pc_o ||
			cout_old !== cout_o || read_data2_old !== read_data2_o) begin
			$display("Stall is not working correctly");
			$stop();
		end
		
		// Test 4: Flush Test //
		flush_i = 1;
		@(posedge clk_i);
		@(negedge clk_i);
		flush_i = 0;
		
		if (reg_write_enable_o !== 0 || mem_write_enable_o !== 0 || pc_o !== pc_i) begin
			$display("Problem with flush");
			$stop();
		end
		
		$display("Yahoo! All Good");
		$stop();
	end
	
	always
		#5 clk_i = ~clk_i;

endmodule