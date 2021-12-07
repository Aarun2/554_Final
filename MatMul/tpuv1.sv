module tpuv1
  #(
	parameter WORD = 32,
    parameter BITS_AB=8,
    parameter BITS_C=16,
    parameter DIM=8
    )
   (
    input clk, rst_n, start, WrEnA, WrEnB, WrEnC,
	input [$clog2(DIM)-1:0] col, row,
    input [BITS_C-1:0] dataIn,
    output [BITS_C-1:0] dataOut,
	output done
   );

//----------------------------------------------------------------------------------------

	// Control
	wire en;
	wire TESTING; // todo remove later
	
	// Reg
	reg [$clog2(DIM)+1:0] counter;

	// Interconnects
	wire [BITS_AB-1:0] interMemA[DIM-1:0];
	wire [BITS_AB-1:0] interMemB[DIM-1:0];
	
//----------------------------------------------------------------------------------------
	
	// Modules
	memA #(.BITS_AB(BITS_AB),.DEPTH(DIM)) iMEMA(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.WrEn(WrEnA),
		.row(row),
		.col(col),
		.Ain(dataIn[BITS_AB-1:0]),
		.Aout(interMemA)
		);
		
	memB #(.BITS_AB(BITS_AB),.DEPTH(DIM)) iMEMB(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.WrEn(WrEnB),
		.row(row),
		.col(col),
		.Bin(dataIn[BITS_AB-1:0]),
		.Bout(interMemB)
		);
	
	systolic_array #(.BITS_AB(BITS_AB), .BITS_C(BITS_C), .DIM(DIM)) iSYSARRY(
		.clk(clk),
		.rst_n(rst_n),
		.WrEn(WrEnC),
		.en(en),
		.A(interMemA),
		.B(interMemB),
		.Cin(dataIn),
		.row(row),
		.col(col),
		.Cout(dataOut)
		);
	
	// Counter/en sig
	assign TESTING = 1;
	assign en = |counter;
	assign done = &counter;
	always_ff @(posedge clk) begin
		if (~rst_n) begin
			counter <= 0;
		end	
		else if (start || en) begin
			counter <= counter+1;
		end
		else if (TESTING) begin
			counter <= 0;
		end
	end
   
endmodule