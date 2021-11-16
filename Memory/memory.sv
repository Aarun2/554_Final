module memory
	#(
	parameter PC_BITS = 16
	)
	(
	input clk_i, rst_n_i, halt_i, flush_i, stall_i, cache_en_i, mem_write_i, wb_sel_i, reg_write_i,
	input [PC_BITS-1:0] result_i /*, TODO: figure if this is needed: read_data_i*/, write_data_i,
	output logic reg_write_o, wb_sel_o,
	output logic [PC_BITS-1:0] read_data_o, result_o
	); 
	
	//intermediate signals
	logic [PC_BITS-1:0] write_data;
	
	//flop in result_i, write_data_i, wb_sel_i, reg_write_i
	always_ff @(posedge clk_i) begin
		if (!rst_n_i) begin
			write_data <= 0;
		end
		else begin
			write_data <= write_data_i;
		end
	end
	
	always_ff @(posedge clk_i) begin
		if (!rst_n_i) begin
			result_o <= 0;
		end
		else begin
			result_o <= result_i;
		end
	end
	
	always_ff @(posedge clk_i) begin
		if (!rst_n_i) begin
			wb_sel_o <= 0;
		end
		else begin
			wb_sel_o <= wb_sel_i;
		end
	end
	
	always_ff @(posedge clk_i) begin
		if (!rst_n_i) begin
			reg_write_o <= 0;
		end
		else begin 
			reg_write_o <= reg_write_i;
		end
	end
	
	//instantiate data cache
	d_cache iDCACHE(
		.clk_i(clk_i), 
		.rst_n_i(rst_n_i), 
		.cache_en_i(cache_en_i),
		.write_read_i(mem_write_i),		
		.addr_i(result_o), 
		.data_i(write_data), 
		.data_o(read_data_o)
	);
	
endmodule