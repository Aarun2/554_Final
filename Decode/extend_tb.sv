module extend_tb();
	logic [19:0] imm_20;
	logic [11:0] imm_12;
	logic [31:0] imm_20_ext, imm_12_ext, expected;
	
	extend_20 ext20_DUT (.imm(imm_20), .imm_ext(imm_20_ext));
	extend_12 ext12_DUT (.imm(imm_12), .imm_ext(imm_12_ext));
	
	////////////////////////////////////
	// Function that waits given time // 
	// for immediate extension of 12  //
	// bit random values.             //
	////////////////////////////////////
	task wait_rand_12ext(int repeat_tim);
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct 12 bit immediate extension");
				$stop();
			end
			begin
				imm_12 = $random();
				expected = {{20{imm_12[11]}}, imm_12}; 
				while (expected !== imm_12_ext)
					#1;
				disable timeout1;
			end
		join
	endtask
	
	////////////////////////////////////
	// Function that waits given time // 
	// for immediate extension of 20  //
	// bit random values.             //
	////////////////////////////////////
	task wait_rand_20ext(int repeat_tim);
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct 12 bit immediate extension");
				$stop();
			end
			begin
				imm_20 = $random();
				expected = {{12{imm_20[19]}}, imm_20}; 
				while (expected !== imm_20_ext)
					#1;
				disable timeout1;
			end
		join
	endtask
	
	////////////////////////////////////
	// Function that waits given time // 
	// for immediate extension of the //
	// given 12 bit random values.    //
	////////////////////////////////////
	task wait_spec_12ext(int repeat_tim, input[11:0] extend);
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct 12 bit immediate extension");
				$stop();
			end
			begin
				imm_12 = extend;
				expected = {{20{imm_12[11]}}, imm_12}; 
				while (expected !== imm_12_ext)
					#1;
				disable timeout1;
			end
		join
	endtask
	
	////////////////////////////////////
	// Function that waits given time // 
	// for immediate extension of the //
	// given 20 bit random values.    //
	////////////////////////////////////
	task wait_spec_20ext(int repeat_tim, input[19:0] extend);
		fork
			begin : timeout1
				repeat(repeat_tim) #1;
				$display("ERROR Timed out waiting for correct 12 bit immediate extension");
				$stop();
			end
			begin
				imm_20 = extend;
				expected = {{12{imm_20[19]}}, imm_20}; 
				while (expected !== imm_20_ext)
					#1;
				disable timeout1;
			end
		join
	endtask
	
	initial begin
		// Test 1: Random 12 bit Values //
		$display("Random 12 Bit Value Test");
		for (int i = 0; i < 500; i++) begin
			wait_rand_12ext(100);
		end
		
		// Test 2: Exhaustive 12 bit Value Test //
		$display("Exhaustive 12 Bit Value Test");
		for (int i = 0; i < 2**12; i++) begin
			wait_spec_12ext(100, i);
		end
		
		// Test 3: Random 20 bit Values //
		$display("Random 20 Bit Value Test");
		for (int i = 0; i < 500; i++) begin
			wait_rand_20ext(100);
		end
		
		// Test 4: Exhaustive 20 bit Value Test //
		$display("Exhaustive 20 Bit Value Test");
		for (int i = 0; i < 2**20; i++) begin
			wait_spec_20ext(100, i);
		end
		
		$display("Yahoo! All Tests Passed");
		$stop();
	end
	
endmodule