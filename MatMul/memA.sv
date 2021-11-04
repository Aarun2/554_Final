module memA
  #(
    parameter BITS_AB=8,
    parameter DEPTH=8
    )
   (
    input clk, rst_n, en, WrEn,
	input [$clog2(DEPTH)-1:0] row,
	input [$clog2(DEPTH)-1:0] col,
    input signed [BITS_AB-1:0] Ain,
    output signed [BITS_AB-1:0] Aout [DEPTH-1:0]
   );
	
	// Interconnects between loaders and Fifos
	wire signed [BITS_AB-1:0] interA [DEPTH-1:0];
   
	// Loader
	matrix_A_fifo #(.DEPTH(DEPTH), .BITS(BITS_AB)) iMATRIXAFIFO(
		.clk(clk),
		.rst_n(rst_n),
		.en(en), 
		.WrEn(WrEn),
		.col(col),
		.row(row),
		.d(Ain),
		.q(interA)
	);
   
	// Fifo instances to Aout
	assign Aout[0] = interA[0];
	genvar x;
	generate
		for (x = 1; x < DEPTH; x++) begin
			fifo #(.DEPTH(x), .BITS(BITS_AB)) iFIFOA (
				.clk(clk),
				.rst_n(rst_n),
				.en(en),
				.d(interA[x]),
				.q(Aout[x])
				);
		
		end	
	endgenerate
   
endmodule