module branch_tb();

	localparam TIMEOUT_VAL = 10;

	logic [31:0] pc_i, imm_i, read_data1_i;
	logic branch_dec_i;
	logic [1:0] branch_type_i;
	logic [31:0] pc_o;
	
	branch_pc branch_DUT (.*);
	
	initial begin
		// Test 1: Branch Type 00 		    //
		// PC should produce the same value //
		branch_type_i = 0;
		for (int i = 0; i < 10**5; i++) begin
			pc_i = $random();
			imm_i = $random();
			read_data1_i = $random();
			branch_dec_i = $random();
			fork
				begin : timeout1
					repeat(TIMEOUT_VAL) #1;
					$display("Timed out in test 1: branch type 00");
					$stop();
				end
				begin
					while (pc_o !== pc_i)
						#1;
					disable timeout1;
				end
			join
		end
		
		// Test 2: Branch Type 01 		      //
		// PC should update based on decision //
		branch_type_i = 1;
		for (int i = 0; i < 10**5; i++) begin
			pc_i = $random();
			imm_i = $random();
			read_data1_i = $random();
			branch_dec_i = $random();
			if (branch_dec_i)
				fork
					begin : timeout3
						repeat(TIMEOUT_VAL) #1;
						$display("Timed out in test 2: branch type 01");
						$stop();
					end
					begin
						while (pc_o !== pc_i + imm_i)
							#1;
						disable timeout3;
					end
				join
			else
				fork
					begin : timeout4
						repeat(TIMEOUT_VAL) #1;
						$display("Timed out in test 2: branch type 01");
						$stop();
					end
					begin
						while (pc_o !== pc_i)
							#1;
						disable timeout4;
					end
				join
		end
		
		// Test 3: Branch Type 10 		      	//
		// PC should always add immediate value //
		branch_type_i = 2;
		for (int i = 0; i < 10**5; i++) begin
			pc_i = $random();
			imm_i = $random();
			read_data1_i = $random();
			branch_dec_i = $random();
			fork
				begin : timeout5
					repeat(TIMEOUT_VAL) #1;
					$display("Timed out in test 3: branch type 10");
					$stop();
				end
				begin
					while (pc_o !== pc_i + imm_i)
						#1;
					disable timeout5;
				end
			join
		end
		
		// Test 4: Branch Type 11 		      		 //
		// PC should always update to register value //
		branch_type_i = 3;
		for (int i = 0; i < 10**5; i++) begin
			pc_i = $random();
			imm_i = $random();
			read_data1_i = $random();
			branch_dec_i = $random();
			fork
				begin : timeout6
					repeat(TIMEOUT_VAL) #1;
					$display("Timed out in test 4: branch type 11");
					$stop();
				end
				begin
					while (pc_o !== read_data1_i)
						#1;
					disable timeout6;
				end
			join
		end
		
		
		$display("Yahoo! All good");
		$stop();
	end

endmodule