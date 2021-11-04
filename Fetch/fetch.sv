module fetch(clk, rst_n, instr, pcIn, pcOut, branch, stall);
	
	localparam PC_BITS = 16;
	
	input clk, rst_n, branch, stall;
	input [PC_BITS-1:0] pcIn;
	
	output reg [PC_BITS-1:0] instr, pcOut;
	
	wire [PC_BITS-1:0] pcReg;
	reg [PC_BITS-1:0] addr;
	
	assign pcReg = branch ? pcIn : pcOut;
	assign pcOut = stall ? pcOut : addr + 4;
	
	//pc reg
	always_ff @(posedge clk) begin
		if (!rst_n)
			addr <= 0;
		else if (!stall)
			addr <= pcReg;
	end
	
	//fetch instr (clk, rst_n not needed as of now)
	i_cache iICACHE(.clk(clk), .rst_n(rst_n), .addr(addr), .instr(instr));
	
endmodule