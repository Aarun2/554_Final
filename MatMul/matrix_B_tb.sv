module matrix_B_tb();

    localparam BITS = 8;
	localparam DEPTH = 8;

    // Stims
    reg en, WrEn, rst_n, clk;
    reg signed [BITS-1:0] Ain;
	reg [$clog2(DEPTH)-1:0] row, col;
    
    // Monitor
    wire signed [BITS-1:0] Aout [DEPTH-1:0];

    // Instance of DUT
	matrix_B_fifo #(.DEPTH(DEPTH), .BITS(BITS)) DUT(
		.clk(clk),
		.rst_n(rst_n),
		.en(en), 
		.WrEn(WrEn),
		.col(col),
		.row(row),
		.d(Ain),
		.q(Aout)
	);
	
	// Test
	reg signed [BITS-1:0] test[DEPTH-1:0][DEPTH-1:0];
    
//------------------------------------------------------------------------------------------------------------------------------------

    // clk
    always @( clk ) begin
        clk <= #5 ~clk;
    end
	
//------------------------------------------------------------------------------------------------------------------------------------

    integer i, j, error;
    initial begin
		// Init
		clk = 1;
		en = 0;
		WrEn = 0;
		rst_n = 0; // Init low
		Ain = 0;
		row = 0;
		col = 0;
		
		// Reset
		@(negedge clk) begin
			rst_n = 0;
		end
		
		// Start
		@(posedge clk);
		@(negedge clk) begin
			rst_n = 1;
		end
		
		// Check to see if all zeroed
		@(negedge clk) begin
			en = 1;
		end
		repeat(DEPTH) begin
			@(posedge clk) begin
				for (i = 0; i < DEPTH; i++) begin
					if (Aout[i] !== 0) begin
						$display("Error in reset Zero");
						error++;
					end
				end
			end
		end
		@(negedge clk) begin
			en = 0;
		end
		
		// Randomizing test
		for (i = 0; i < DEPTH; i++) begin
			for (j = 0; j < DEPTH; j++) begin
				test[i][j] = $random%128;
				//$display("row: %d col: %d val: %d", i, j, test[i][j]);
			end
		end
		
		
		for (i = 0; i < DEPTH; i++) begin
			for (j = 0; j < DEPTH; j++) begin
				@(negedge clk) begin
					WrEn = 1;
					Ain = test[i][j];
					row = i;
					col = j;
				end
				
				@(posedge clk) begin
					
				end
				
				// Delay that may or may not happen
				@(negedge clk) begin
					WrEn = 0;
				end
				
			end
		end
		
		// Testing output
		@(posedge clk) begin
			en = 1;
		end
		
		for (i = 0; i < DEPTH; i++) begin
			@(negedge clk) begin
				for (j = 0; j < DEPTH; j++) begin
					if (test[i][j] !== Aout[j]) begin
						$display("Error row: %d col: %d exp: %d, got: %d", i, j, test[i][j], Aout[j]);
					end
				end
			end
		end
		
		// Rand wait
		repeat(5) @(posedge clk);
		
		@(negedge clk) begin
			en = 0;
		end
		
		// Rand reset
		@(negedge clk) begin
			rst_n = 0;
		end
		
		// Start
		@(posedge clk);
		@(negedge clk) begin
			rst_n = 1;
		end
		
		// Check to see if all zeroed
		@(negedge clk) begin
			en = 1;
		end
		repeat(DEPTH) begin
			@(posedge clk) begin
				for (i = 0; i < DEPTH; i++) begin
					if (Aout[i] !== 0) begin
						$display("Error in reset Zero");
						error++;
					end
				end
			end
		end
		@(negedge clk) begin
			en = 0;
		end
		
		// Randomizing test
		for (i = 0; i < DEPTH; i++) begin
			for (j = 0; j < DEPTH; j++) begin
				test[i][j] = $random%128;
				//$display("row: %d col: %d val: %d", i, j, test[i][j]);
			end
		end
		
		
		for (i = 0; i < DEPTH; i++) begin
			for (j = 0; j < DEPTH; j++) begin
				@(negedge clk) begin
					WrEn = 1;
					Ain = test[i][j];
					row = i;
					col = j;
				end
				
				@(posedge clk) begin
					
				end
				
				// Delay that may or may not happen
				@(negedge clk) begin
					WrEn = 0;
				end
				
			end
		end
		
		// Testing output
		@(posedge clk) begin
			en = 1;
		end
		
		for (i = 0; i < DEPTH; i++) begin
			@(negedge clk) begin
				for (j = 0; j < DEPTH; j++) begin
					if (test[i][j] !== Aout[j]) begin
						$display("Error row: %d col: %d exp: %d, got: %d", i, j, test[i][j], Aout[j]);
					end
				end
			end
		end
		
		// Next should be zeros
		@(negedge clk) begin
			for (j = 0; j < DEPTH; j++) begin
				if (0 !== Aout[j]) begin
					$display("Error zeroing, exp: 0, got: %d", Aout[j]);
				end
			end
		end
		
		@(posedge clk) begin
			en = 0;
		end
		
		// Rand wait
		repeat(5) @(posedge clk);
		
		$stop();

	end

//------------------------------------------------------------------------------------------------------------------------------------

endmodule


