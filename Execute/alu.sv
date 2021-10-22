module alu(a, b, alu_op, result);
    input signed [31:0] a, b;
    input [3:0] alu_op;
    output reg signed [32:0] result;
    output branch;

    wire neg_shft;

    always @(*)
        case(alu_op[1:0])
            4'b00 : branch = &alu_op[3:2] & ~|(a^b); // beq
            4'b01 : branch = &alu_op[3:2] & |(a^b); // bne
            4'b10 : branch = (a > b); // a bgt b
            default : branch = (a < b); // a blt b
        endcase
    
    always @(*)
        case(alu_op)
            4'b0000 : result = a+b; // a + b
            4'b0001 : result = a-b; // a - b
            4'b0010 : result = a^b; // a ^ b
            4'b0011 : result = a|b; // a | b
            4'b0100 : result = a&b; // a & b
            4'b0101 : result = a << b; // a sll b
            4'b0110 : result = a >> b; // a srl b
            4'b0111 : result = |(b[31:5]) ? {32{a[31]}} : {{b{a[31]}}, a[31:b]};
            4'b1000 : result = (a < b) ? : 32'd1 : 32'd0; // set less than 
            4'b1001 : result = (a * b)[31:0]; // a * b
            default : result  = b << 12; // load upper immediate
        endcase

endmodule
