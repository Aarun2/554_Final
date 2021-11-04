module memB_tb();

    localparam BITS = 8;
	localparam DEPTH = 8;

    // Stims
    reg en, WrEn, rst_n, clk;
    reg signed [BITS-1:0] in;
	reg [$clog2(DEPTH)-1:0] row;
	reg [$clog2(DEPTH)-1:0] col;
    
    // Monitor
    wire signed [BITS-1:0] out [DEPTH-1:0];

    // Instance of DUT
    memB #(.BITS_AB(BITS),.DEPTH(DEPTH)) DUT(
    .clk(clk),
	.rst_n(rst_n),
	.en(en),
	.WrEn(WrEn),
	.row(row),
	.col(col),
    .Bin(in),
    .Bout(out)
   );
   
	// Test
	reg signed [BITS-1:0] test[DEPTH-1:0][DEPTH-1:0];
    
//------------------------------------------------------------------------------------------------------------------------------------

// clk
    always @( clk ) begin
        clk <= #5 ~clk;
    end

//------------------------------------------------------------------------------------------------------------------------------------

    integer i, j, k, error;
    initial begin
		// Init
		clk = 1;
		en = 0;
		WrEn = 0;
		rst_n = 1;
		in = 0;
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
		repeat(DEPTH*3) begin
			@(posedge clk) begin
				for (i = 0; i < DEPTH; i++) begin
					if (out[i] !== 0) begin
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
					in = test[i][j];
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
		
		repeat(DEPTH*3) @(posedge clk);
		
		@(posedge clk) begin
			en = 0;
		end
		
		$stop();

	end
	
//------------------------------------------------------------------------------------------------------------------------------------

endmodule


