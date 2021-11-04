module memB
  #(
    parameter BITS_AB=8,
    parameter DEPTH=8
    )
   (
    input clk, rst_n, en, WrEn,
	input [$clog2(DEPTH)-1:0] row, col,
    input signed [BITS_AB-1:0] Bin,
    output signed [BITS_AB-1:0] Bout [DEPTH-1:0]
    );
	
	// Interconnect
	wire [BITS_AB-1:0] interB [DEPTH-1:0];
	
	// Loader
	matrix_B_fifo #(.DEPTH(DEPTH), .BITS(BITS_AB)) iMATRIXBFIFO(
		.clk(clk),
		.rst_n(rst_n),
		.en(en), 
		.WrEn(WrEn),
		.col(col),
		.row(row),
		.d(Bin),
		.q(interB)
	);
	
	// Fifo instances with stagering
	assign Bout[0] = interB[0];
	
	genvar x;
	generate
		for (x = 1; x < DEPTH; x++) begin
			fifo #(.DEPTH(x), .BITS(BITS_AB)) iFIFOB(
				.clk(clk),
				.rst_n(rst_n),
				.en(en),
				.d(interB[x]),
				.q(Bout[x])
				);
		end	
	endgenerate
	
endmodule