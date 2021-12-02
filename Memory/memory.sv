module memory
	(
	input clk_i, rst_n_i, 
	input flush_i, stall_i,
	input mem_write_en_i, reg_write_en_i, forward_en_i, data_cache_valid_i,	
	input [1:0] wb_sel_i,
	input [4:0] reg_write_dst_i,
	input [31:0] cout_i, result_i, read_data_2_i, forward_data_i, data_from_cache_i,
	output logic reg_write_en_o, // pass through 
	output logic wr_to_cache_o, stall_o,
	output logic [1:0] wb_sel_o, // pass through
	output logic [4:0] reg_write_dst_o, // pass through
	output logic [31:0] result_o, cout_o, // pass through
	output logic [31:0] read_data_o, data_to_cache_o, addr_to_cache_o
	); 
	
	//intermediate signals
	logic [31:0] read_data_d;
	
	assign stall_o = data_cache_valid_i ? 0 : 1; // for control flow 
	
	// outputs to D cache
	assign data_to_cache_o = flush_i ? 0 : stall_i ? data_to_cache_o : read_data_2_i;
	assign addr_to_cache_o = flush_i ? 0 : stall_i ? addr_to_cache_o : result_i;
	assign wr_to_cache_o = flush_i ? 0 : stall_i ? wr_to_cache_o : mem_write_en_i;
	
	// inputs back from D cache
	assign read_data_d = data_cache_valid_i ? data_from_cache_i : read_data_o;
	
	/////////////////////////////
	//flop outputs for pipeline //
	//////////////////////////////
	// reg_write_en_o
	always_ff @(posedge clk_i) begin
		if (!rst_n_i | flush_i) begin
			reg_write_en_o <= 0;
		end
		else if (stall_i) begin
			reg_write_en_o <= reg_write_en_o;
		end
		else begin 
			reg_write_en_o <= reg_write_en_i;
		end
	end
	
	// wb_sel_o
	always_ff @(posedge clk_i) begin
		if (!rst_n_i | flush_i) begin
			wb_sel_o <= 0;
		end
		else if (stall_i) begin
			wb_sel_o <= wb_sel_o;
		end
		else begin
			wb_sel_o <= wb_sel_i;
		end
	end
	
	//reg_write_dst_o
	always_ff @(posedge clk_i) begin
		if (!rst_n_i | flush_i) begin
			reg_write_dst_o <= 0;
		end
		else if (stall_i) begin
			reg_write_dst_o <= reg_write_dst_o;
		end
		else begin
			reg_write_dst_o <= reg_write_dst_i;
		end
	end
	
	// result_o
	always_ff @(posedge clk_i) begin
		if (!rst_n_i | flush_i) begin
			result_o <= 0;
		end
		else if (stall_i) begin
			result_o <= result_o;
		end
		else begin
			result_o <= result_i;
		end
	end
	
	// cout_o
	always_ff @(posedge clk_i) begin
		if (!rst_n_i | flush_i) begin
			cout_o <= 0;
		end
		else if (stall_i) begin
			cout_o <= cout_o;
		end
		else begin 
			cout_o <= cout_i;
		end
	end
	
	// read_data_o
	always_ff @(posedge clk_i) begin
		if (!rst_n_i | flush_i) begin
			read_data_o <= 0;
		end
		else if (stall_i) begin
			read_data_o <= read_data_o;
		end
		else begin 
			read_data_o <= read_data_d;
		end
	end

endmodule