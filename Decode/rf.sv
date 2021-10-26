module rf(clk, rst_n, read1regsel, read2regsel, write, writeregsel, writedata, read1data, read2data);
	
	input clk, rst_n;
	input [4:0] read1regsel, read2regsel;
	input [4:0] writeregsel;
	input [31:0] writedata;
	input write;
	
	output [31:0] read1data;
	output [31:0] read2data;
	
	reg [31:0] mem [31:0];
	
	initial	
		$readmemh("test.txt", mem);
		
	assign read1data = write ? (writeregsel == read1regsel) ? writedata : mem[read1regsel] : mem[read1regsel];
	assign read2data = write ? (writeregsel == read2regsel) ? writedata : mem[read2regsel] : mem[read2regsel];
	
	always_ff @(posedge clk, negedge rst_n)
		for (int i = 0; i < 32; i++) begin
			if (!rst_n)
				mem[i] <= 0;
			else if (write && (writeregsel == i))
				mem[i] <= writedata;
		end
			
endmodule