module d_cache#(
	parameter PC_BITS = 16
	)
	(
	input clk_i, 
	input rst_n_i, 
	input write_read_i, 
	input cache_en_i, 
	input [PC_BITS-1:0] addr_i, 
	input [PC_BITS-1:0] data_i,
	output [PC_BITS-1:0] data_o
	);
	
	logic [PC_BITS-1:0] instr_mem [(2**PC_BITS) - 1:0];
	
	assign data_o = (cache_en_i & !write_read_i) ? instr_mem[addr_i] : 'b0;
	
	always_ff@(posedge clk_i) begin
		if (!rst_n_i) begin
			
		end else begin
			if (cache_en_i) begin
				if (write_read_i == 1) begin
					instr_mem[addr_i] <= data_i;
				end 
			end
		end
	end
	
	initial	
		$readmemh("test_icache.txt", instr_mem);

endmodule