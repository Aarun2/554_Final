module fetch
	#(
	parameter PC_BITS = 16
	)
	(
	input clk_i, rst_n_i, branch_i, stall_i,
	input [PC_BITS-1:0] pc_i,
	output [PC_BITS-1:0] instr_o, pc_o
	);
	
	logic [PC_BITS-1:0] pc_reg;
	logic [PC_BITS-1:0] addr;
	
	assign pc_reg = branch_i ? pc_i : pc_o;
	assign pc_o = stall_i ? pc_o : addr + 4;
	
	//pc reg
	always_ff @(posedge clk_i) begin
		if (!rst_n_i) begin
			addr <= 0;
		end
		else if (!stall_i) begin
			addr <= pc_reg;
		end
	end
	
	//fetch instr_o (clk_i, rst_n_i not needed as of now)
	i_cache iICACHE(.clk_i(clk_i), .rst_n_i(rst_n_i), .addr_i(addr), .instr_o(instr_o));
	
endmodule