module matrix_A_fifo
	#(
	parameter DEPTH = 8,
	parameter BITS = 8
	)
	(
	input clk, rst_n, en, WrEn,
	input [$clog2(DEPTH)-1:0] col,
	input [$clog2(DEPTH)-1:0] row,
	input signed [BITS-1:0] d,
	output signed [BITS-1:0] q [DEPTH-1:0]
	);
	
	// Transposed Load with Shifting
	
	// Store
	reg signed [BITS-1:0] tword [DEPTH-1:0][DEPTH-1:0];
	
	// Instance
	integer i, j;
	always_ff @(posedge clk) begin
		// Reset
		if (~rst_n) begin
			for (i = 0; i < DEPTH; i++) begin
				for (j = 0; j < DEPTH; j++) begin
					tword[i][j] <= 0;
				end
			end
		end
		
		// WrEn
		else if (WrEn) begin
			tword[row][col] <= d;
		end
		
		// en
		else if (en) begin
			for (i = 0; i < DEPTH; i++) begin
				for (j = 1; j < DEPTH; j++) begin
					tword[i][j-1] <= tword[i][j];
				end
				tword[i][DEPTH-1] <= 0;
			end
		end
	end

	// Assign output
	genvar g;
	generate 
		for (g = 0; g < DEPTH; g++) begin
			assign q[g] = tword[g][0];
		end
	endgenerate

endmodule
