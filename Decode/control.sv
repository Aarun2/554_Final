module control(op, alu_op, branch, write, imm_sel, wb_sel);

	input [6:0] op;
	
	output [3:0] alu_op;
	output [1:0] branch;
	output imm_sel, wb_sel;
	output logic write;

	assign alu_op = (~op[6] & op[5] & ~op[4]) ? 4'h1 : op[3:0];
		
	assign branch = (~op[6] & op[5] & op[4]) ? 2'b01 : (op[6] & op[5] & op[4] & op[3] & op[2] & op[1]) ? {1'b1, op[0]} : 2'b00;
	
	assign imm_sel = op[4] ^ op[5];
	
	assign wb_sel = (~op[6] & op[5] & ~op[4]);
	
	always @(op)
		casex(op)
			7'h00 : begin // NOP
				write = 0;
			end
			7'h01 : begin // add
				write = 1;
			end
			7'h02 : begin // sub
				write = 1;
			end
			7'h03 : begin // xor
				write = 1;
			end
			7'h04 : begin // or
				write = 1;
			end
			7'h05 : begin // and
				write = 1;
			end
			7'h06 : begin // sll
				write = 1;
			end
			7'h07 : begin // srl
				write = 1;
			end
			7'h08 : begin // sra
				write = 1;
			end
			7'h09 : begin // slt
				write = 1;
			end
			7'h0A : begin // mul
				write = 1;
			end
			7'h11 : begin // addi
				write = 1;
			end
			7'h13 : begin // xori
				write = 1;
			end
			7'h14 : begin // ori
				write = 1;
			end
			7'h15 : begin // andi
				write = 1;
			end
			7'h16 : begin // slli
				write = 1;
			end
			7'h17 : begin // srli
				write = 1;
			end
			7'h18 : begin // srai
				write = 1;
			end
			7'h19 : begin // slti
				write = 1;
			end
			7'h1B : begin // lui
				write = 1;
			end
			7'h20 : begin // lw
				write = 1;
			end
			7'h21 : begin // sw
				write = 0;
			end
			7'h3C : begin // beq
				write = 0;
			end
			7'h3D : begin // bne
				write = 0;
			end
			7'h3E : begin // blt
				write = 0;
			end
			7'h3F : begin // bgt
				write = 0;
			end
			7'h50 : begin // matmul
				write = 0;
			end
			7'h51 : begin // lam
				write = 0;
			end
			7'h52 : begin // lbm
				write = 0;
			end
			7'h53 : begin // lacc
				write = 0;
			end
			7'h54 : begin // racc
				write = 0;
			end
			7'h7E : begin // j
				write = 0;
			end
			7'h7F : begin // jr
				write = 0;
			end
			default : begin
				write = 0;
			end
		endcase
endmodule