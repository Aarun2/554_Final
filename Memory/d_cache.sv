module d_cache
	(
	input clk_i, rst_n_i,
	input pipeline_write_valid_i, 
	input [31:0] addr_in_pipeline_i, data_in_pipeline_i,
	output logic pipeline_valid_o,
	output logic [31:0] data_out_pipeline_o
	);
	
	//dummy cache
	logic [31:0] data_mem [(2**16) - 1:0];
	
	assign data_out_pipeline_o = pipeline_write_valid_i ? 0 : data_mem[addr_in_pipeline_i];
	assign pipeline_valid_o = 1'b1; // dummy cache always 1
	
	// write logic 
	always_ff @(posedge clk_i) begin
		if (!rst_n_i) begin
			// do nothing
		end else begin
			if (pipeline_write_valid_i) begin
				data_mem[addr_in_pipeline_i] <= data_in_pipeline_i;
			end 
		end
	end
	
	initial	
		$readmemh("test.txt", data_mem);

endmodule