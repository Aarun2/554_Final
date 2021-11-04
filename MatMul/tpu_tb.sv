module tpu_tb();

	localparam WORD = 8;
    localparam BITS_AB = 16;
	localparam BITS_C = 32;
	localparam DIM = 32;

    // Stims
    reg en, rst_n, clk, start, WrEnA, WrEnB, WrEnC;
    reg signed [BITS_C-1:0] in;
	reg [$clog2(DIM)-1:0] row, col;
    
    // Monitor
    wire signed [BITS_C-1:0] out;
	wire done;

    // Instance of DUT
	tpuv1 #(.WORD(WORD), .BITS_AB(BITS_AB), .BITS_C(BITS_C), .DIM(DIM)) iDUT (
		.clk(clk), 
		.rst_n(rst_n), 
		.start(start), 
		.WrEnA(WrEnA), 
		.WrEnB(WrEnB), 
		.WrEnC(WrEnC),
		.col(col), 
		.row(row),
		.dataIn(in),
		.dataOut(out),
		.done(done)
		);
	
	// Test
	reg signed [BITS_AB-1:0] testA[DIM-1:0][DIM-1:0];
	reg signed [BITS_AB-1:0] testB[DIM-1:0][DIM-1:0];
	reg signed [BITS_C-1:0] testC[DIM-1:0][DIM-1:0];
    
//------------------------------------------------------------------------------------------------------------------------------------

    // clk
    always @( clk ) begin
        clk <= #5 ~clk;
    end
	
//------------------------------------------------------------------------------------------------------------------------------------

    integer i, j, k, l, error;
    initial begin
		// Init
		clk = 1;
		start = 0;
		en = 0;
		WrEnA = 0;
		WrEnB = 0;
		WrEnC = 0;
		rst_n = 0; // Init low
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
			col = 0;
			row = 0;
		end
		for (i = 0; i < DIM; i++) begin
			for (j = 0; j < DIM; j++) begin
				@(negedge clk) begin
					row = i;
					col = j;
				end
				
				@(posedge clk) begin
					if (out !== 0) begin
						$display("Not Zeroed, row: %d col%d", i, j);
					end
				end
			end
		end
		
		
		@(negedge clk) begin
			en = 0;
		end
		
		// Randomizing test
		for (i = 0; i < DIM; i++) begin
			for (j = 0; j < DIM; j++) begin
				testA[i][j] = $random%(2**(BITS_AB-1));
				testB[i][j] = $random%(2**(BITS_AB-1));
				testC[i][j] = 0;
			end
		end
		
		// Calc C
		for (i = 0; i < DIM; i++) begin
			for (j = 0; j < DIM; j++) begin
				for (k = 0; k < DIM; k++) begin
					testC[i][j] += testA[i][k] * testB[k][j]; 
				end
			end
		end
		
		// Load matrix A
		for (i = 0; i < DIM; i++) begin
			for (j = 0; j < DIM; j++) begin
				@(negedge clk) begin
					row = i;
					col = j;
					WrEnA = 1;
					in = testA[i][j];
				end
			end
		end
		
		@(negedge clk) begin
			WrEnA = 0;
		end
		
		// Load matrix B
		for (i = 0; i < DIM; i++) begin
			for (j = 0; j < DIM; j++) begin
				@(negedge clk) begin
					row = i;
					col = j;
					WrEnB = 1;
					in = testB[i][j];
				end
			end
		end
		
		@(negedge clk) begin
			WrEnB = 0;
		end
		
		// Start
		@(negedge clk) begin
			start = 1; 
		end
		@(negedge clk) begin
			start = 0; 
		end
		
		// Wait till done
		@(posedge done);
		 
		// Check values
		for (i = 0; i < DIM; i++) begin
			for (j = 0; j < DIM; j++) begin
				@(negedge clk) begin
					row = i;
					col = j;
				end
				
				@(posedge clk) begin
					if (testC[i][j] !== out) begin
						$display("Incorrect Calc, row: %d col: %d exp: %d got: %d", i, j, testC[i][j], out);
					end
				end
			end
		end
		
		// Rand wait
		repeat(5) @(posedge clk);
		
		// random reset
		@(negedge clk) begin
			rst_n = 0;
		end
		
		// Start
		@(posedge clk);
		@(negedge clk) begin
			rst_n = 1;
		end
		
		// Check to see if all zeroed
		for (i = 0; i < DIM; i++) begin
			for (j = 0; j < DIM; j++) begin
				@(negedge clk) begin
					row = i;
					col = j;
				end
				
				@(posedge clk) begin
					if (out !== 0) begin
						$display("Not Zeroed, row: %d col%d", i, j);
					end
				end
			end
		end
		
		// Randomizing test
		for (i = 0; i < DIM; i++) begin
			for (j = 0; j < DIM; j++) begin
				testA[i][j] = $random%(2**(BITS_AB-1));
				testB[i][j] = $random%(2**(BITS_AB-1));
				testC[i][j] = $random%(2**(BITS_C-1));
			end
		end
		
		// Load C
		for (i = 0; i < DIM; i++) begin
			for (j = 0; j < DIM; j++) begin
				@(negedge clk) begin
					row = i;
					col = j;
					WrEnC = 1;
					in = testC[i][j];
				end
				
				@(posedge clk);
			end
		end
		@(negedge clk) begin
			WrEnC = 0;
		end
		
		// Check C Load
		for (i = 0; i < DIM; i++) begin
			for (j = 0; j < DIM; j++) begin
				@(negedge clk) begin
					row = i;
					col = j;
				end
				
				@(posedge clk) begin
					if (out !== testC[i][j]) begin
						$display("Not load correct, row: %d col: %d", i, j);
					end
				end
			end
		end
		
		// Calc C
		for (i = 0; i < DIM; i++) begin
			for (j = 0; j < DIM; j++) begin
				for (k = 0; k < DIM; k++) begin
					testC[i][j] += testA[i][k] * testB[k][j]; 
				end
			end
		end
		
		// Load matrix A
		for (i = 0; i < DIM; i++) begin
			for (j = 0; j < DIM; j++) begin
				@(negedge clk) begin
					row = i;
					col = j;
					WrEnA = 1;
					in = testA[i][j];
				end
			end
		end
		
		@(negedge clk) begin
			WrEnA = 0;
		end
		
		// Load matrix B
		for (i = 0; i < DIM; i++) begin
			for (j = 0; j < DIM; j++) begin
				@(negedge clk) begin
					row = i;
					col = j;
					WrEnB = 1;
					in = testB[i][j];
				end
			end
		end
		
		@(negedge clk) begin
			WrEnB = 0;
		end
		
		// Start
		@(negedge clk) begin
			start = 1; 
		end
		@(negedge clk) begin
			start = 0; 
		end
		
		// Wait till done
		@(posedge done);
		 
		// Check values
		for (i = 0; i < DIM; i++) begin
			for (j = 0; j < DIM; j++) begin
				@(negedge clk) begin
					row = i;
					col = j;
				end
				
				@(posedge clk) begin
					if (testC[i][j] !== out) begin
						$display("Incorrect Calc, row: %d col: %d exp: %d got: %d", i, j, testC[i][j], out);
					end
				end
			end
		end
		
		// Rand wait
		repeat(5) @(posedge clk);
		
		$stop();

	end

//------------------------------------------------------------------------------------------------------------------------------------

endmodule


