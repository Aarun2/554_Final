module control
	(
	 input [6:0] op_i,
	 output imm_sel_o, [3:0] alu_op_o, [1:0] branch_type_o, 
	 [1:0] wb_sel_o, logic reg_write_enable_o, logic mem_write_enable_o
	);

	/*
	wire tpu_instr;
	
	assign tpu_instr = op_i[6] & ~op_i[5] & op_i[4];

	assign start = tpu_instr & op_i[3];
	
	assign WrEnA = tpu_instr & op_i[0];
	
	assign WrEnB = tpu_instr & op_i[1];
	
	assign WrEnC = tpu_instr & op_i[2];
	
	*/

	// Always Add for loads and stores //
	assign alu_op_o = wb_sel_o[0] ? 4'h1 : op_i[3:0];
	
	// branch_type_o or B instruction if 011                    //
	// All ones indicates a Jr instruction               //
	// All ones and last bit 0 indicates a J instruction //
	assign branch_type_o = (~op_i[6] & op_i[5] & op_i[4]) ? 2'b01 : (op_i[6] & op_i[5] & op_i[4] & op_i[3] & op_i[2] & op_i[1]) ? {1'b1, op_i[0]} : 2'b00;
	
	// Need to choose immediate for 010 and 001 //
	// So when one of those bits is a 1		    //
	assign imm_sel_o = op_i[4] ^ op_i[5];
	
	// 010 indicates a load or store instruction    //
	// May have to reg_write_enable_o to memory data to register //
	assign wb_sel_o[0] = (~op_i[6] & op_i[5] & ~op_i[4]);
	
	// 101 indicates a TPU operation     //
	// May have to reg_write_enable_o TPU data to reg //
	assign wb_sel_o[1] = (op_i[6] & ~op_i[5] & op_i[4]);
	
	always begin
		mem_write_enable_o = 0;
		reg_write_enable_o = 0;
		
		casex(op_i)
			7'h00 : begin // NOP
				reg_write_enable_o = 0;
			end
			7'h01 : begin // add
				reg_write_enable_o = 1;
			end
			7'h02 : begin // sub
				reg_write_enable_o = 1;
			end
			7'h03 : begin // xor
				reg_write_enable_o = 1;
			end
			7'h04 : begin // or
				reg_write_enable_o = 1;
			end
			7'h05 : begin // and
				reg_write_enable_o = 1;
			end
			7'h06 : begin // sll
				reg_write_enable_o = 1;
			end
			7'h07 : begin // srl
				reg_write_enable_o = 1;
			end
			7'h08 : begin // sra
				reg_write_enable_o = 1;
			end
			7'h09 : begin // slt
				reg_write_enable_o = 1;
			end
			7'h0A : begin // mul
				reg_write_enable_o = 1;
			end
			7'h11 : begin // addi
				reg_write_enable_o = 1;
			end
			7'h13 : begin // xori
				reg_write_enable_o = 1;
			end
			7'h14 : begin // ori
				reg_write_enable_o = 1;
			end
			7'h15 : begin // andi
				reg_write_enable_o = 1;
			end
			7'h16 : begin // slli
				reg_write_enable_o = 1;
			end
			7'h17 : begin // srli
				reg_write_enable_o = 1;
			end
			7'h18 : begin // srai
				reg_write_enable_o = 1;
			end
			7'h19 : begin // slti
				reg_write_enable_o = 1;
			end
			7'h1B : begin // lui
				reg_write_enable_o = 1;
			end
			7'h20 : begin // lw
				reg_write_enable_o = 1;
			end
			7'h21 : begin // sw
				reg_write_enable_o = 0;
				mem_write_enable_o = 1;
			end
			7'h3C : begin // beq
				reg_write_enable_o = 0;
			end
			7'h3D : begin // bne
				reg_write_enable_o = 0;
			end
			7'h3E : begin // blt
				reg_write_enable_o = 0;
			end
			7'h3F : begin // bgt
				reg_write_enable_o = 0;
			end
			7'h50 : begin // matmul
				reg_write_enable_o = 0;
			end
			7'h51 : begin // lam
				reg_write_enable_o = 0;
			end
			7'h52 : begin // lbm
				reg_write_enable_o = 0;
			end
			7'h53 : begin // lacc
				reg_write_enable_o = 0;
			end
			7'h54 : begin // racc
				reg_write_enable_o = 0;
			end
			7'h7E : begin // j
				reg_write_enable_o = 0;
			end
			7'h7F : begin // jr
				reg_write_enable_o = 0;
			end
			default : begin
				reg_write_enable_o = 0;
			end
		endcase
	end
endmodule