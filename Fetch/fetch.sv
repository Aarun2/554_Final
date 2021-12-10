module fetch
	(
	input clk_i, rst_n_i, 
	input branch_i, stall_i, flush_i, data_cache_valid_i,
	input [31:0] pc_i, data_from_cache_i,
	output stall_o,
	output [31:0] addr_to_cache_o,
	output logic [31:0] instr_o, pc_o
	);
	
	logic [31:0] pc_reg, addr, pc_d, instr_d;
	
	assign stall_o = data_cache_valid_i ? 0 : 1; // for control flow 
	assign addr_to_cache_o = addr;
	assign instr_d = flush_i ? 0 : data_cache_valid_i ? data_from_cache_i : 0; // data_cache_valid_i should always be high
	
	// pc logic 
	assign pc_reg = branch_i ? pc_i : pc_d;
	//assign pc_d = stall_i ? pc_d : addr + 4;
	assign pc_d = stall_i ? addr : addr + 4;
	
	//pc reg
	always_ff @(posedge clk_i) begin
		if (!rst_n_i) begin
			addr <= 0;
		end
		//else if (!stall_i) begin
		else begin
			addr <= pc_reg;
		end
	end
	
	// flop outputs for pipeline
	always_ff @(posedge clk_i) begin
		if (!rst_n_i) begin
			pc_o <= 0;
		end
		else begin
			if (!stall_i) begin
				pc_o <= addr;
			end
		end
	end
	
	// flop outputs for pipeline
	always_ff @(posedge clk_i) begin
		if (!rst_n_i) begin
			instr_o <= 0;
		end
		else begin
			instr_o <= instr_d;
		end
	end
	
endmodule