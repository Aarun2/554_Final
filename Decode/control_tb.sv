///////////////////////
// Run on Questa Sim //
// Uses Verification //
//   Constructs      //
///////////////////////
/*
class myPacket;
	randc bit [6:0] op_i;
	// to loop over random op_i's is any order
	// also won't repeat
endclass
*/

module control_tb();

	localparam TIMEOUT_VAL = 100;

	logic [6:0] op_i;
	logic [3:0] alu_op_o;
	logic [1:0] branch_type_o, wb_sel_o;
	logic reg_write_enable_o, imm_sel_o, mem_write_enable_o, tpu_start_o,  tpu_write_enable_A, tpu_write_enable_B, tpu_write_enable_C, mem_cache_valid;

	control ctrl_DUT (.*);
	
	/////////////////////////////
	// Functions to replicate  //
	// signal checks           //
	/////////////////////////////
	
	function R_instr;
		R_instr = (branch_type_o !== 2'h0 || reg_write_enable_o !== 1'b1 || imm_sel_o !== 1'b0 || mem_cache_valid !== 1'b0 ||
				   wb_sel_o !== 2'b0 || mem_write_enable_o !== 1'b0 || tpu_start_o !== 1'b0 || 
				   tpu_write_enable_A !== 1'b0 || tpu_write_enable_B !== 1'b0 || tpu_write_enable_C !== 1'b0);
	endfunction
	
	function I_instr;
		I_instr = (branch_type_o !== 2'h0 || reg_write_enable_o !== 1'b1 || imm_sel_o !== 1'b1 || mem_cache_valid !== 1'b0 ||
				   wb_sel_o !== 2'b0 || mem_write_enable_o !== 1'b0 || tpu_start_o !== 1'b0 ||
				   tpu_write_enable_A !== 1'b0 || tpu_write_enable_B !== 1'b0 || tpu_write_enable_C !== 1'b0);
	endfunction
	
	function B_instr;
		B_instr = (branch_type_o !== 2'h1 || reg_write_enable_o !== 1'b0 || imm_sel_o !== 1'b0 || mem_cache_valid !== 1'b0 ||
				   mem_write_enable_o !== 1'b0 || tpu_start_o !== 1'b0 || tpu_write_enable_A !== 1'b0 || 
				   tpu_write_enable_B !== 1'b0 || tpu_write_enable_C !== 1'b0);
	endfunction

	function TPU_instr;
		TPU_instr = (branch_type_o !== 2'h0 || mem_write_enable_o !== 1'b0 || mem_cache_valid !== 1'b0);
	endfunction
	
	/////////////////////////////
	// Below are tasks that    //
	// check to see if output  //
	// signals are correct     //
	/////////////////////////////
	
	task wait_nop(int repeat_tim);
    	$display("nop test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct nop signals");
				$stop();
			end
			begin
				while (branch_type_o !== 2'h0 || reg_write_enable_o !== 1'b0 || mem_write_enable_o !== 1'b0 || tpu_start_o !== 1'b0 || 
					   tpu_write_enable_A !== 1'b0 || tpu_write_enable_B !== 1'b0 || tpu_write_enable_C !== 1'b0)
					#1;
				disable timeout1;
			end
		join
		$display("nop test passed");
	endtask
	
	task wait_add(int repeat_tim);
		$display("add test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct add signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h1 || R_instr)
					#1;
				disable timeout1;
			end
		join
		$display("add test passed");
	endtask
	
	task wait_sub (int repeat_tim);
		$display("sub test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct sub signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h2 || R_instr)
					#1;
				disable timeout1;
			end
		join
		$display("sub test passed");
	endtask

	task wait_xor (int repeat_tim);
		$display("xor test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct xor signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h3 ||R_instr)
					#1;
				disable timeout1;
			end
		join
		$display("xor test passed");
	endtask

	task wait_or (int repeat_tim);
		$display("or test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct or signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h4 || R_instr)
					#1;
				disable timeout1;
			end
		join
		$display("or test passed");
	endtask

	task wait_and (int repeat_tim);
		$display("and test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct and signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h5 || R_instr)
					#1;
				disable timeout1;
			end
		join
		$display("and test passed");
	endtask

	task wait_sll (int repeat_tim);
		$display("sll test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct sll signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h6 || R_instr)
					#1;
				disable timeout1;
			end
		join
		$display("sll test passed");
	endtask

	task wait_srl (int repeat_tim);
		$display("srl test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct srl signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h7 || R_instr)
					#1;
				disable timeout1;
			end
		join
		$display("srl test passed");
	endtask

	task wait_sra (int repeat_tim);
		$display("sra test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct sra signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h8 || R_instr)
					#1;
				disable timeout1;
			end
		join
		$display("sra test passed");
	endtask

	task wait_slt (int repeat_tim);
		$display("slt test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct slt signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h9 || R_instr)
					#1;
				disable timeout1;
			end
		join
		$display("slt test passed");
	endtask

	task wait_mul (int repeat_tim);
		$display("mul test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct mul signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'hA || R_instr)
					#1;
				disable timeout1;
			end
		join
		$display("mul test passed");
	endtask
	
	task wait_addi (int repeat_tim);
		$display("addi test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct addi signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h1 || I_instr)
					#1;
				disable timeout1;
			end
		join
		$display("addi test passed");
	endtask

	task wait_xori (int repeat_tim);
		$display("xori test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct xori signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h3 || I_instr)
					#1;
				disable timeout1;
			end
		join
		$display("xori test passed");
	endtask

	task wait_ori (int repeat_tim);
		$display("ori test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct ori signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h4 || I_instr)
					#1;
				disable timeout1;
			end
		join
		$display("ori test passed");
	endtask

	task wait_andi (int repeat_tim);
		$display("andi test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct andi signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h5 || I_instr)
					#1;
				disable timeout1;
			end
		join
		$display("andi test passed");
	endtask	
	
	task wait_slli (int repeat_tim);
		$display("slli test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct slli signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h6 || I_instr)
					#1;
				disable timeout1;
			end
		join
		$display("slli test passed");
	endtask

	task wait_srli (int repeat_tim);
		$display("srli test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct srli signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h7 || I_instr)
					#1;
				disable timeout1;
			end
		join
		$display("srli test passed");
	endtask

	task wait_srai (int repeat_tim);
		$display("srai test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct srai signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h8 || I_instr)
					#1;
				disable timeout1;
			end
		join
		$display("srai test passed");
	endtask

	task wait_slti (int repeat_tim);
		$display("slti test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct slti signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h9 || I_instr)
					#1;
				disable timeout1;
			end
		join
		$display("slti test passed");
	endtask

	task wait_lui (int repeat_tim);
		$display("lui test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct lui signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'hB || I_instr)
					#1;
				disable timeout1;
			end
		join
		$display("lui test passed");
	endtask
	
	task wait_lw (int repeat_tim);
		$display("lw test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct lw signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h1 || branch_type_o !== 2'h0 || reg_write_enable_o !== 1'b1 || imm_sel_o !== 1'b1 || 
				       wb_sel_o !== 2'b1 || mem_write_enable_o !== 1'b0 || tpu_start_o !== 1'b0 || mem_cache_valid !== 1'b1 ||
					   tpu_write_enable_A !== 1'b0 || tpu_write_enable_B !== 1'b0 || tpu_write_enable_C !== 1'b0)
					#1;
				disable timeout1;
			end
		join
		$display("lw test passed");
	endtask
	
	task wait_sw (int repeat_tim);
		$display("sw test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct sw signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'h1 || branch_type_o !== 2'h0 || reg_write_enable_o !== 1'b0 || imm_sel_o !== 1'b1 ||
				       mem_write_enable_o !== 1'b1 || tpu_start_o !== 1'b0 || tpu_write_enable_A !== 1'b0 || mem_cache_valid !== 1'b1 ||
					   tpu_write_enable_B !== 1'b0 || tpu_write_enable_C !== 1'b0)
					#1;
				disable timeout1;
			end
		join
		$display("sw test passed");
	endtask
	
	task wait_beq (int repeat_tim);
		$display("beq test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct beq signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'hC || B_instr)
					#1;
				disable timeout1;
			end
		join
		$display("beq test passed");
	endtask
	
	task wait_bne (int repeat_tim);
		$display("bne test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct bne signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'hD || B_instr)
					#1;
				disable timeout1;
			end
		join
		$display("bne test passed");
	endtask
	
	task wait_blt (int repeat_tim);
		$display("blt test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct blt signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'hE || B_instr)
					#1;
				disable timeout1;
			end
		join
		$display("blt test passed");
	endtask
	
	task wait_bgt (int repeat_tim);
		$display("bgt test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct bgt signals");
				$stop();
			end
			begin
				while (alu_op_o !== 4'hF || B_instr)
					#1;
				disable timeout1;
			end
		join
		$display("bgt test passed");
	endtask
	
	task wait_j (int repeat_tim);
		$display("j test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct j signals");
    			$display("%h, %h", branch_type_o, reg_write_enable_o);	
				$stop();
			end
			begin
				while (branch_type_o !== 2'b10 || reg_write_enable_o !== 1'b0 || mem_write_enable_o !== 1'b0 || tpu_start_o !== 1'b0 || 
					   tpu_write_enable_A !== 1'b0 || tpu_write_enable_B !== 1'b0 || tpu_write_enable_C !== 1'b0)
					#1;
				disable timeout1;
			end
		join
		$display("j test passed");
	endtask
	
	task wait_jr (int repeat_tim);
		$display("jr test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct jr signals");
				$stop();
			end
			begin
				while (branch_type_o !== 2'b11 || reg_write_enable_o !== 1'b0 || mem_write_enable_o !== 1'b0 || tpu_start_o !== 1'b0 || 
					   tpu_write_enable_A !== 1'b0 || tpu_write_enable_B !== 1'b0 || tpu_write_enable_C !== 1'b0)
					#1;
				disable timeout1;
			end
		join
		$display("jr test passed");
	endtask
	 
	task wait_matmul(int repeat_tim);
		$display("matmul test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct matmul signals");
				$stop();
			end
			begin
				while (reg_write_enable_o !== 1'b0 || tpu_start_o !== 1'b1 || TPU_instr || 
					   tpu_write_enable_A !== 1'b0 || tpu_write_enable_B !== 1'b0 || tpu_write_enable_C !== 1'b0)
					#1;
				disable timeout1;
			end
		join
		$display("matmul test passed");
	endtask
	
	task wait_lam(int repeat_tim);
		$display("lam test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct lam signals");
				$stop();
			end
			begin
				while (reg_write_enable_o !== 1'b0 || tpu_start_o !== 1'b0 || TPU_instr || 
					   tpu_write_enable_A !== 1'b1 || tpu_write_enable_B !== 1'b0 || tpu_write_enable_C !== 1'b0)
					#1;
				disable timeout1;
			end
		join
		$display("lam test passed");
	endtask
	
	task wait_lbm(int repeat_tim);
		$display("lbm test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct lbm signals");
				$stop();
			end
			begin
				while (reg_write_enable_o !== 1'b0 || tpu_start_o !== 1'b0 || TPU_instr || 
					   tpu_write_enable_A !== 1'b0 || tpu_write_enable_B !== 1'b1 || tpu_write_enable_C !== 1'b0)
					#1;
				disable timeout1;
			end
		join
		$display("lbm test passed");
	endtask
	
	task wait_lacc(int repeat_tim);
		$display("lacc test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct lacc signals");
				$stop();
			end
			begin
				while (reg_write_enable_o !== 1'b0 || tpu_start_o !== 1'b0 || TPU_instr || 
					   tpu_write_enable_A !== 1'b0 || tpu_write_enable_B !== 1'b0 || tpu_write_enable_C !== 1'b1)
					#1;
				disable timeout1;
			end
		join
		$display("lacc test passed");
	endtask
	
	task wait_racc(int repeat_tim);
		$display("racc test");
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct racc signals");
				$stop();
			end
			begin
				while (reg_write_enable_o !== 1'b1 || tpu_start_o !== 1'b0 || TPU_instr || wb_sel_o !== 2'd2 ||
					   tpu_write_enable_A !== 1'b0 || tpu_write_enable_B !== 1'b0 || tpu_write_enable_C !== 1'b0)
					#1;
				disable timeout1;
			end
		join
		$display("racc test passed");
	endtask
	
	task wait_undef(int repeat_tim);
    	$display("Undefined Opcode 0x%h test", op_i);
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for undefined opcode signals");
				$display("%b, %b", branch_type_o, reg_write_enable_o);
				$stop();
			end
			begin // branch_type_o should not be 2 or 3 as then it's a jump
			// otherwise alu decides and will be false for undefined opcodes
				while (branch_type_o[1] !== 1'b0 || reg_write_enable_o !== 1'b0 || mem_write_enable_o !== 1'b0 || tpu_start_o !== 1'b0 || 
					   tpu_write_enable_A !== 1'b0 || tpu_write_enable_B !== 1'b0 || tpu_write_enable_C !== 1'b0)
					#1;
				disable timeout1;
			end
		join
		$display("Undefined Opcode 0x%h test passed", op_i);
	endtask
	
	task call_wait();
    	case(op_i)
            	7'h00 : begin // NOP
				wait_nop(TIMEOUT_VAL);
			end
			7'h01 : begin // add
				wait_add(TIMEOUT_VAL);
			end
			7'h02 : begin // sub
				wait_sub(TIMEOUT_VAL);
			end
			7'h03 : begin // xor
				wait_xor(TIMEOUT_VAL);
			end
			7'h04 : begin // or
				wait_or(TIMEOUT_VAL);
			end
			7'h05 : begin // and
				wait_and(TIMEOUT_VAL);
			end
			7'h06 : begin // sll
				wait_sll(TIMEOUT_VAL);
			end
			7'h07 : begin // srl
				wait_srl(TIMEOUT_VAL);
			end
			7'h08 : begin // sra
				wait_sra(TIMEOUT_VAL);
			end
			7'h09 : begin // slt
				wait_slt(TIMEOUT_VAL);
			end
			7'h0A : begin // mul
				wait_mul(TIMEOUT_VAL);
			end
			7'h11 : begin // addi
				wait_addi(TIMEOUT_VAL);
			end
			7'h13 : begin // xori
				wait_xori(TIMEOUT_VAL);
			end
			7'h14 : begin // ori
				wait_ori(TIMEOUT_VAL);
			end
			7'h15 : begin // andi
				wait_andi(TIMEOUT_VAL);
			end
			7'h16 : begin // slli
				wait_slli(TIMEOUT_VAL);
			end
			7'h17 : begin // srli
				wait_srli(TIMEOUT_VAL);
			end
			7'h18 : begin // srai
				wait_srai(TIMEOUT_VAL);
			end
			7'h19 : begin // slti
				wait_slti(TIMEOUT_VAL);
			end
			7'h1B : begin // lui
				wait_lui(TIMEOUT_VAL);
			end
			7'h20 : begin // lw
				wait_lw(TIMEOUT_VAL);
			end
			7'h21 : begin // sw
				wait_sw(TIMEOUT_VAL);
			end
			7'h3C : begin // beq
				wait_beq(TIMEOUT_VAL);
			end
			7'h3D : begin // bne
				wait_bne(TIMEOUT_VAL);
			end
			7'h3E : begin // blt
				wait_blt(TIMEOUT_VAL);
			end
			7'h3F : begin // bgt
				wait_bgt(TIMEOUT_VAL);
			end
			7'h50 : begin // matmul
				wait_matmul(TIMEOUT_VAL);
			end
			7'h51 : begin // lam
				wait_lam(TIMEOUT_VAL);
			end
			7'h52 : begin // lbm
				wait_lbm(TIMEOUT_VAL);
			end
			7'h53 : begin // lacc
				wait_lacc(TIMEOUT_VAL);
			end
			7'h54 : begin // racc
				wait_racc(TIMEOUT_VAL);
			end
			7'h7E : begin // j
				wait_j(TIMEOUT_VAL);
			end
			7'h7F : begin // jr
				wait_jr(TIMEOUT_VAL);
			end
			default : begin
				wait_undef(TIMEOUT_VAL);
			end
        	endcase
	endtask	

	initial begin
		/*
		myPacket pkt;
		pkt = new();
		*/
		
		// Test 1: Check 500 random exhaustive opcode checks
		for (int i = 0; i < 500; i++) begin
    			for (int i = 0; i < 2**7; i++) begin
    				op_i = $random();
    				call_wait();
    			end
		end
		$display("Yahoo! All tests Passed");
		$stop();
	end
	

endmodule
