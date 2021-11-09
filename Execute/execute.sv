module execute #(parameter PC_BITS = 16) (clk, rst_n, flush, writeregsel_d, read1data, read2data, imm, alu_op, pc_d, imm_sel,
                                          wb_sel_d, write_d, m_write_d, branch, result, wb_sel, write, m_write, writeregsel, pc);
			   
	input clk, rst_n, flush;
	input [31:0] read1data, read2data, imm;
	input [3:0] alu_op;
	input imm_sel, wb_sel_d, write_d, m_write_d;
	input [1:0] branch;
	input [4:0] writeregsel_d;
	input [PC_BITS-1:0] pc_d;
	
	output logic [31:0] result;
	output logic wb_sel, write, m_write;
	output logic [4:0] writeregsel;
	output logic [PC_BITS-1:0] pc;
	
	wire [31:0] b, result_d;
	wire [PC_BITS-1:0] pc_out;
	wire branch_dec;
	
	assign b = (imm_sel) ? imm : read2data; 
	
	alu i_alu (.a(read1data), .b(b), .alu_op(alu_op), .result(result_d), .branch(branch_dec));
	
	branch_pc #(.PC_BITS(PC_BITS)) br_pc (.pc_in(pc_d), .imm(imm), .read1data(read1data), .branch_dec(branch_dec), 
	                                      .branch(branch), .pc(pc_out));
	
	//////////////////
	// EX/MEM Flops //
	//////////////////
	
	always_ff @(posedge clk, negedge rst_n)
		if (!rst_n)
			pc <= 0;
		else if (flush)
			pc <= pc_d;
		else
			pc <= pc_out;
			
	always_ff @(posedge clk)
		writeregsel <=  writeregsel_d;
	
	always_ff @(posedge clk)
		result <= result_d;
			
	always_ff @(posedge clk, negedge rst_n)
		if (!rst_n)
			write <= 0;
		else if (flush)
			write <= 0;
		else
			write <= write_d;
	
	always_ff @(posedge clk, negedge rst_n)
		if (!rst_n)
			m_write <= 0;
		else if (flush)
			m_write <= 0;
		else
			m_write <= m_write_d;
	
	always_ff @(posedge clk)
		wb_sel <= wb_sel_d;

endmodule