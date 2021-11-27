module branch_pc 
	(
	input [31:0] pc_i, imm_i, read_data1_i,
	input branch_dec_i,
	input [1:0] branch_type_i,
	output logic [31:0] pc_o
	);
	
	always_comb begin
		pc_o = pc_i;
		
		case (branch_type_i)
			2'b11 : pc_o = read_data1_i; // JR
			2'b10 : pc_o = pc_i + imm_i; // J
			2'b01 : // Br
				if (branch_dec_i)
					pc_o = pc_i + imm_i;
				else
					pc_o = pc_i;
			default : 
				pc_o = pc_i;
		endcase
	end

endmodule