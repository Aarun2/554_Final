module extend_tb();

	logic [14:0] imm_15;
	logic [31:0] imm_15_ext, expected;
	
	extend_15 ext15_DUT (.imm(imm_15), .imm_ext(imm_15_ext));
	
	////////////////////////////////////
	// Function that waits given time // 
	// for immediate extension of 15  //
	// bit random values.             //
	////////////////////////////////////
	task wait_rand_15ext(int repeat_tim);
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct 15 bit immediate extension");
				$stop();
			end
			begin
				imm_15 = $random();
				expected = {{17{imm_15[14]}}, imm_15}; 
				while (expected !== imm_15_ext)
					#1;
				disable timeout1;
			end
		join
	endtask
	
	////////////////////////////////////
	// Function that waits given time // 
	// for immediate extension of the //
	// given 15 bit random values.    //
	////////////////////////////////////
	task wait_spec_15ext(int repeat_tim, input[14:0] extend);
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct 15 bit immediate extension");
				$stop();
			end
			begin
				imm_15 = extend;
				expected = {{17{imm_15[14]}}, imm_15}; 
				while (expected !== imm_15_ext)
					#1;
				disable timeout1;
			end
		join
	endtask
	
	initial begin
		// Test 1: Random 15 bit Values //
		$display("Random 15 Bit Value Test");
		for (int i = 0; i < 500; i++) begin
			wait_rand_15ext(100);
		end
		
		// Test 2: Exhaustive 15 bit Value Test //
		$display("Exhaustive 15 Bit Value Test");
		for (int i = 0; i < 2**15; i++) begin
			wait_spec_15ext(100, i);
		end
		
		$display("Yahoo! All Tests Passed");
		$stop();
	end


endmodule