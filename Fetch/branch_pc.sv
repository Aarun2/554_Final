module branch_pc #(parameter PC_BITS = 16) (pc_in, imm, read1data, branch_dec, branch, pc);
// NOTE: Add stall, Flush signals if needed
// Also Test This

	input [PC_BITS-1:0] pc_in;
	input branch_dec;
	input [31:0] imm, read1data;
	input [1:0] branch;
	
	output logic [PC_BITS-1:0] pc;
	
	always begin
		case (branch)
			2'b11 : pc = read1data; // JR
			2'b10 : pc = pc + imm; // J
			2'b01 : // Br
				if (branch_dec)
					pc = pc + imm;
				else
					pc = pc;
			default : 
				pc = pc + imm;
		endcase
	end

endmodule