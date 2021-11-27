module alu
	(
    input signed [31:0] a_i, b_i,
    input [3:0] alu_op_i,
    output logic signed [31:0] result_o,
    output logic branch_o
	);
	
	wire [31:0] mult;

	assign mult = a_i * b_i;

    always @(*)
        case(alu_op_i[1:0])
            2'b00 : branch_o = &alu_op_i[3:2] & ~|(a_i^b_i); // beq
            2'b01 : branch_o = &alu_op_i[3:2] & |(a_i^b_i); // bne
            2'b10 : branch_o = &alu_op_i[3:2] & (a_i > b_i); // a_i bgt b_i
			2'b11 : branch_o = &alu_op_i[3:2] & (a_i < b_i); // a_i blt b_i
            default : branch_o = 0; // don't branch_o
        endcase
    
    always @(*)
        case(alu_op_i)
            4'b0001 : result_o = a_i+b_i; // a_i + b_i
            4'b0010 : result_o = a_i-b_i; // a_i - b_i
            4'b0011 : result_o = a_i^b_i; // a_i ^ b_i
            4'b0100 : result_o = a_i|b_i; // a_i | b_i
            4'b0101 : result_o = a_i&b_i; // a_i & b_i
            4'b0110 : result_o = a_i << b_i[4:0]; // a_i sll b_i
            4'b0111 : result_o = a_i >> b_i[4:0]; // a_i srl b_i
            4'b1000 : result_o = a_i >>> b_i[4:0]; // a_i sra b_i
            4'b1001 : result_o = (a_i < b_i) ? 32'b1 : 32'b0; // set less than 
            4'b1010 : result_o = mult; // a_i * b_i
			4'b1011 : result_o = b_i << 12; // load upper immediate
			default : result_o  = {32{1'bX}}; // default all high
        endcase

endmodule
