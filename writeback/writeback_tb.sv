class myPacket;
	randc bit [31:0] result, mem_data; 

endclass

module writeback_tb();

	logic wb_sel;
	logic [31:0] result, mem_data, wb_reg, expected;
		
	writeback wb_DUT (.wb_sel(wb_sel), .result(result), .mem_data(mem_data), .wb_reg(wb_reg));

	task wait_reg(int repeat_tim);
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting wb_reg to have correct value");
				$stop();
			end
			begin
				while (wb_reg !== expected)
					#1;
				disable timeout1;
			end
		join		

	endtask

	initial begin
		myPacket pkt;
		pkt = new();
		// Test 1: 500 Random Exhaustive Tests //
		$display("Test 1");
		for (int r = 0; r < 10000; r++) begin
			pkt.randomize();
			mem_data = pkt.mem_data;
			result = pkt.result;
			wb_sel = $random();
			expected = wb_sel ? mem_data : result;
			wait_reg(100);
		end
		
		$display("Yahoo! All Done");
		$stop();

	end


endmodule
