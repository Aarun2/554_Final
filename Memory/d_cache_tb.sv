module d_cache_tb #()();
	localparam PC_BITS = 16;
	logic clk, rst_n, write_read, cache_en;
	logic [15:0] addr, data_in, data_out;

	logic [PC_BITS-1:0] test_mem [(2**PC_BITS) - 1:0];

	d_cache cache (
		.clk_i			(clk),
		.rst_n_i		(rst_n),
		.write_read_i	(write_read),
		.cache_en_i		(cache_en),
		.addr_i			(addr),
		.data_i			(data_in),
		.data_o			(data_out)
		);

	always #5 clk = ~clk;

	initial begin
		$readmemh("test_icache.txt", test_mem);
		clk = 0;
		rst_n = 1;
		cache_en = 1'b0;
		
		for (int i = 0; i < 32; i++) begin
			random_reads();
		end
		
		for (int i = 0; i < 32; i++) begin
			random_writes();
		end
		
	end
	
	
	task random_reads();
		addr = $random();
		cache_en = 1'b1;
		write_read = 1'b0;
		@(posedge clk);
		#1 if (test_mem[addr] !== data_out) begin
			$display("Random Read not accurate");
			$stop();
		end
		cache_en = 1'b0;
	endtask
	
	task random_writes();
		addr = $random();
		data_in = $random();
		cache_en = 1'b1;
		write_read = 1'b1;
		test_mem[addr] = data_in;
		@(posedge clk);
		write_read = 1'b0;
		@(posedge clk);
		#1 if(test_mem[addr] !== data_out) begin
			$display("Write did not work as expected!");
			$stop();
		end
		cache_en = 1'b0;
		
	endtask

endmodule
