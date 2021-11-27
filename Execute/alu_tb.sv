module alu_tb();
	
	logic signed [31:0] a_i, b_i, result_o, expected;
	logic signed [63:0] mult_result;
	logic [3:0] alu_op_i;
	logic branch_o, expected_branch;
	
	parameter loop_checks = 1000;
	
	alu alu_DUT (.*);
	
	initial begin
		
		// Test 1: Add Test, Op: 4'b0001 //
		for (int i = 0; i < loop_checks; i++) begin
			a_i = $random();
			b_i = $random();
			expected = a_i + b_i;
			alu_op_i = 4'b0001;
			fork
				begin : timeout1
					repeat(70000) #1;
					$display("Timed out waiting for add result_o to change");
					$stop();
				end
				begin
					while (result_o !== expected) begin
						if (branch_o) begin
							$display("branch_o should not be asserted on add instruction");
							$stop();
						end
						#1;
					end
					disable timeout1;
				end
			join
			
		end
		$display("Test 1 passed");
		
		// Test 2: Subtract Test, Op: 4'b0010 //
		for (int i = 0; i < loop_checks; i++) begin
			a_i = $random();
			b_i = $random();
			expected = a_i - b_i;
			alu_op_i = 4'b0010;
			fork
				begin : timeout1
					repeat(70000) #1;
					$display("Timed out waiting for subtract result_o to change");
					$stop();
				end
				begin
					while (result_o !== expected) begin
						if (branch_o) begin
							$display("branch_o should not be asserted on subtract instruction");
							$stop();
						end
						#1;
					end
					disable timeout1;
				end
			join
			
		end
		$display("Test 2 passed");
		
		// Test 3: Xor Test, Op: 4'b0011 //
		for (int i = 0; i < loop_checks; i++) begin
			a_i = $random();
			b_i = $random();
			expected = a_i ^ b_i;
			alu_op_i = 4'b0011;
			fork
				begin : timeout1
					repeat(70000) #1;
					$display("Timed out waiting for xor result_o to change");
					$stop();
				end
				begin
					while (result_o !== expected) begin
						if (branch_o) begin
							$display("branch_o should not be asserted on xor instruction");
							$stop();
						end
						#1;
					end
					disable timeout1;
				end
			join
			
		end
		$display("Test 3 passed");
		
		// Test 4: Or Test, Op: 4'b0100 //
		for (int i = 0; i < loop_checks; i++) begin
			a_i = $random();
			b_i = $random();
			expected = a_i | b_i;
			alu_op_i = 4'b0100;
			fork
				begin : timeout1
					repeat(70000) #1;
					$display("Timed out waiting for Or result_o to change");
					$stop();
				end
				begin
					while (result_o !== expected) begin
						if (branch_o) begin
							$display("branch_o should not be asserted on Or instruction");
							$stop();
						end
						#1;
					end
					disable timeout1;
				end
			join
			
		end
		$display("Test 4 passed");
		
		// Test 5: And Test, Op: 4'b0101 //
		for (int i = 0; i < loop_checks; i++) begin
			a_i = $random();
			b_i = $random();
			expected = a_i & b_i;
			alu_op_i = 4'b0101;
			fork
				begin : timeout1
					repeat(70000) #1;
					$display("Timed out waiting for And result_o to change");
					$stop();
				end
				begin
					while (result_o !== expected) begin
						if (branch_o) begin
							$display("branch_o should not be asserted on And instruction");
							$stop();
						end
						#1;
					end
					disable timeout1;
				end
			join
			
		end
		$display("Test 5 passed");
		
		// Test 6: SLL Test, Op: 4'b0110 //
		for (int i = 0; i < loop_checks; i++) begin
			a_i = $random();
			b_i = $random();
			expected = a_i << b_i[4:0];
			alu_op_i = 4'b0110;
			fork
				begin : timeout1
					repeat(70000) #1;
					$display("Timed out waiting for SLL result_o to change");
					$stop();
				end
				begin
					while (result_o !== expected) begin
						if (branch_o) begin
							$display("branch_o should not be asserted on SLL instruction");
							$stop();
						end
						#1;
					end
					disable timeout1;
				end
			join
			
		end
		$display("Test 6 passed");
		
		// Test 7: SRL Test, Op: 4'b0111 //
		for (int i = 0; i < loop_checks; i++) begin
			a_i = $random();
			b_i = $random();
			expected = a_i >> b_i[4:0];
			alu_op_i = 4'b0111;
			fork
				begin : timeout1
					repeat(70000) #1;
					$display("Timed out waiting for SRL result_o to change");
					$stop();
				end
				begin
					while (result_o !== expected) begin
						if (branch_o) begin
							$display("branch_o should not be asserted on SRL instruction");
							$stop();
						end
						#1;
					end
					disable timeout1;
				end
			join
			
		end
		$display("Test 7 passed");
		
		// Test 8: SRA Test, Op: 4'b1000 //
		for (int i = 0; i < loop_checks; i++) begin
			a_i = $random();
			b_i = $random();
			expected = a_i >>> b_i[4:0];
			alu_op_i = 4'b1000;
			fork
				begin : timeout1
					repeat(70000) #1;
					$display("Timed out waiting for SRA result_o to change");
					$stop();
				end
				begin
					while (result_o !== expected) begin
						if (branch_o) begin
							$display("branch_o should not be asserted on SRA instruction");
							$stop();
						end
						#1;
					end
					disable timeout1;
				end
			join
			
		end
		$display("Test 8 passed");
		
		// Test 9: SLT Test, Op: 4'b1001 //
		for (int i = 0; i < loop_checks; i++) begin
			a_i = $random();
			b_i = $random();
			expected = (a_i < b_i);
			alu_op_i = 4'b1001;
			fork
				begin : timeout1
					repeat(70000) #1;
					$display("Timed out waiting for SLT result_o to change");
					$stop();
				end
				begin
					while (result_o !== expected) begin
						if (branch_o) begin
							$display("branch_o should not be asserted on SLT instruction");
							$stop();
						end
						#1;
					end
					disable timeout1;
				end
			join
			
		end
		$display("Test 9 passed");
		
		// Test 10: Multiply Test, Op: 4'b1010 //
		for (int i = 0; i < loop_checks; i++) begin
			a_i = $random();
			b_i = $random();
			mult_result = a_i*b_i;
			expected = mult_result[31:0];
			alu_op_i = 4'b1010;
			fork
				begin : timeout1
					repeat(70000) #1;
					$display("Timed out waiting for MULT result_o to change");
					$stop();
				end
				begin
					while (result_o !== expected) begin
						if (branch_o) begin
							$display("branch_o should not be asserted on MULT instruction");
							$stop();
						end
						#1;
					end
					disable timeout1;
				end
			join
		end
		$display("Test 10 passed");
		
		// Test 11: LUI Test, Op: 4'b1011 //
		for (int i = 0; i < loop_checks; i++) begin
			a_i = $random();
			b_i = $random();
			expected = b_i << 12;
			alu_op_i = 4'b1011;
			fork
				begin : timeout1
					repeat(70000) #1;
					$display("Timed out waiting for LUI result_o to change");
					$stop();
				end
				begin
					while (result_o !== expected) begin
						if (branch_o) begin
							$display("branch_o should not be asserted on LUI instruction");
							$stop();
						end
						#1;
					end
					disable timeout1;
				end
			join
		end
		$display("Test 11 passed");
		
		// Test 11: Beq Test, Op: 4'b1100 //
		alu_op_i = 4'b1100;
		for (int i = 0; i < loop_checks; i++) begin
			expected_branch = $random() % 2; // two possible options: 1 or 0
			case (expected_branch)
				0: begin // set not equal should not branch_o here
					a_i = $random();
					b_i = $random();
				end
				default: begin // equal so sould branch_o here
					a_i = $random();
					b_i = a_i;
				end
			endcase
			fork
				begin : timeout1
					repeat(70000) #1;
					$display("Timed out waiting for Beq result_o to change");
					$stop();
				end
				begin
					while (branch_o !== expected_branch) begin
						#1;
						if (result_o !== 32'hXXXXXXXX) begin
							$display("result_o should be default value of all X's");
							$stop();
						end
					end
					disable timeout1;
				end
			join
		end
		$display("Test 11 passed");
		
		// Test 12: Bne Test, Op: 4'b1101 //
		alu_op_i = 4'b1101;
		for (int i = 0; i < loop_checks; i++) begin
			expected_branch = $random() % 2; // two possible options: 1 or 0
			case (expected_branch)
				0: begin // set equal should not branch_o here
					a_i = $random();
					b_i = a_i;
				end
				default: begin // set not equal and should branch_o here
					a_i = $random();
					b_i = $random();
 				end
			endcase
			fork
				begin : timeout1
					repeat(70000) #1;
					$display("Timed out waiting for Beq result_o to change");
					$stop();
				end
				begin
					while (branch_o !== expected_branch) begin
						#1;
						if (result_o !== 32'hXXXXXXXX) begin
							$display("result_o should be default value of all X's");
							$stop();
						end
					end
					disable timeout1;
				end
			join
		end
		$display("Test 12 passed");
		
		// Test 13: Bgt Test, Op: 4'b1110 //
		alu_op_i = 4'b1110;
		for (int i = 0; i < loop_checks; i++) begin
			expected_branch = $random() % 2; // two possible options: 1 or 0
			case (expected_branch)
				0: begin // set a_i less than or equal to b_i should not branch_o here
					a_i = $random();
					b_i = $random();
					while (a_i > b_i) begin
						b_i = $random();
						a_i--;	
					end
				end
				default: begin // set a_i greater than b_i should branch_o here
					a_i = $random();
					b_i = $random();
					while (a_i <= b_i) begin
						b_i = $random();
						a_i++;	
					end
 				end
			endcase
			fork
				begin : timeout1
					repeat(70000) #1;
					$display("Timed out waiting for Beq result_o to change");
					$stop();
				end
				begin
					while (branch_o !== expected_branch) begin
						#1;
						if (result_o !== 32'hXXXXXXXX) begin
							$display("result_o should be default value of all X's");
							$stop();
						end
					end
					disable timeout1;
				end
			join
		end
		$display("Test 13 passed");
		
		// Test 14: Blt Test, Op: 4'b1111 //
		alu_op_i = 4'b1111;
		for (int i = 0; i < loop_checks; i++) begin
			expected_branch = $random() % 2; // two possible options: 1 or 0
			case (expected_branch)
				0: begin // set a_i greater than or equal to b_i should not branch_o here
					a_i = $random();
					b_i = $random();
					while (a_i < b_i) begin
						b_i = $random();
						a_i++;	
					end
				end
				default: begin // set a_i less than b_i should branch_o here
					a_i = $random();
					b_i = $random();
					while (a_i >= b_i) begin
						b_i = $random();
						a_i--;	
					end
 				end
			endcase
			fork
				begin : timeout1
					repeat(70000) #1;
					$display("Timed out waiting for Beq result_o to change");
					$stop();
				end
				begin
					while (branch_o !== expected_branch) begin
						#1;
						if (result_o !== 32'hXXXXXXXX) begin
							$display("result_o should be default value of all X's");
							$stop();
						end
					end
					disable timeout1;
				end
			join
		end
		$display("Test 14 passed");
		
		$display("Yahoo Tests Passed!");
		$stop();
	end

endmodule