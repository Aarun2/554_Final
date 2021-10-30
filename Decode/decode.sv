module decode(clk, rst_n, read1data, read2data, imm_ext);

	input clk, rst_n;
	input [31:0] instr;
	
	output [31:0] read1data, read2data, imm_ext;
	
	rf reg_file (.clk(clk), .rst_n(rst_n), .read1regsel(instr[19:15]), .read2regsel(), write, writeregsel, writedata, 
	             .read1data(read1data), .read2data(read2data));
				 
	extend_15 extension (.imm(instr[14:0]), .imm_ext(imm_ext));

endmodule