///////////////////////
// Run on Questa Sim //
// Uses Verification //
//   Constructs      //
///////////////////////
class myPacket;
	randc bit [6:0] op;
	// to loop over random op's is any order
	// also won't repeat
endclass

module control_tb();

	logic [6:0] op;
	logic [3:0] alu_op;
	logic [1:0] branch;
	logic write, imm_sel, wb_sel;

	control ctrl_DUT (.op(op), .alu_op(alu_op), .branch(branch), .write(write), .imm_sel(imm_sel), .wb_sel(wb_sel));
	
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
				while (branch !== 2'h0 || write !== 1'b0)
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
				while (alu_op !== 4'h1 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b0 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h2 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b0 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h3 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b0 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h4 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b0 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h5 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b0 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h6 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b0 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h7 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b0 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h8 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b0 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h9 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b0 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'hA || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b0 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h1 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b1 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h3 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b1 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h4 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b1 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h5 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b1 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h6 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b1 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h7 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b1 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h8 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b1 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h9 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b1 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'hB || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b1 || wb_sel !== 1'b0)
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
				while (alu_op !== 4'h1 || branch !== 2'h0 || write !== 1'b1 || imm_sel !== 1'b1 || wb_sel !== 1'b1)
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
				while (alu_op !== 4'h1 || branch !== 2'h0 || write !== 1'b0 || imm_sel !== 1'b1)
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
				while (alu_op !== 4'hC || branch !== 2'h1 || write !== 1'b0 || imm_sel !== 1'b0)
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
				while (alu_op !== 4'hD || branch !== 2'h1 || write !== 1'b0 || imm_sel !== 1'b0)
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
				while (alu_op !== 4'hE || branch !== 2'h1 || write !== 1'b0 || imm_sel !== 1'b0)
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
				while (alu_op !== 4'hF || branch !== 2'b01 || write !== 1'b0 || imm_sel !== 1'b0)
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
    			$display("%h, %h", branch, write);	
				$stop();
			end
			begin
				while (branch !== 2'b10 || write !== 1'b0)
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
				while (branch !== 2'b11 || write !== 1'b0)
					#1;
				disable timeout1;
			end
		join
		$display("jr test passed");
	endtask
	
	task wait_undef(int repeat_tim);
    	$display("Undefined Opcode 0x%h test", op);
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for undefined opcode signals");
				$display("%b, %b", branch, write);
				$stop();
			end
			begin // branch should not be 2 or 3 as then it's a jump
			// otherwise alu decides and will be false for undefined opcodes
				while (branch[1] === 1'b1 || write !== 1'b0)
					#1;
				disable timeout1;
			end
		join
		$display("Undefined Opcode 0x%h test passed", op);
	endtask
	
	task call_wait();
    	case(op)
            	7'h00 : begin // NOP
				wait_nop(100);
			end
			7'h01 : begin // add
				wait_add(100);
			end
			7'h02 : begin // sub
				wait_sub(100);
			end
			7'h03 : begin // xor
				wait_xor(100);
			end
			7'h04 : begin // or
				wait_or(100);
			end
			7'h05 : begin // and
				wait_and(100);
			end
			7'h06 : begin // sll
				wait_sll(100);
			end
			7'h07 : begin // srl
				wait_srl(100);
			end
			7'h08 : begin // sra
				wait_sra(100);
			end
			7'h09 : begin // slt
				wait_slt(100);
			end
			7'h0A : begin // mul
				wait_mul(100);
			end
			7'h11 : begin // addi
				wait_addi(100);
			end
			7'h13 : begin // xori
				wait_xori(100);
			end
			7'h14 : begin // ori
				wait_ori(100);
			end
			7'h15 : begin // andi
				wait_andi(100);
			end
			7'h16 : begin // slli
				wait_slli(100);
			end
			7'h17 : begin // srli
				wait_srli(100);
			end
			7'h18 : begin // srai
				wait_srai(100);
			end
			7'h19 : begin // slti
				wait_slti(100);
			end
			7'h1B : begin // lui
				wait_lui(100);
			end
			7'h20 : begin // lw
				wait_lw(100);
			end
			7'h21 : begin // sw
				wait_sw(100);
			end
			7'h3C : begin // beq
				wait_beq(100);
			end
			7'h3D : begin // bne
				wait_bne(100);
			end
			7'h3E : begin // blt
				wait_blt(100);
			end
			7'h3F : begin // bgt
				wait_bgt(100);
			end
			7'h50 : begin // matmul
				
			end
			7'h51 : begin // lam

			end
			7'h52 : begin // lbm
				
			end
			7'h53 : begin // lacc
				
			end
			7'h54 : begin // racc
				
			end
			7'h7E : begin // j
				wait_j(100);
			end
			7'h7F : begin // jr
				wait_jr(100);
			end
			default : begin
				wait_undef(100);
			end
        	endcase
	endtask	

	initial begin
		myPacket pkt;
		pkt = new();
		
		// Test 1: Check 500 random exhaustive opcode checks
		for (int i = 0; i < 500; i++) begin
    			for (int i =0 ; i < 2**7; i++) begin
    				pkt.randomize();			
    				op = pkt.op;
    				call_wait();
    			end
		end
		
		$display("Yahoo! All tests Passed");
		$stop();
	end
	

endmodule
