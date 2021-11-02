module writeback(clk, rst_n, flush, wb_sel, write_in, result, mem_data, wb_reg, write);
  
  input clk, rst_n, flush, wb_sel, write_in;
  input [31:0] result, mem_data;
  
  output logic [31:0] wb_reg;
  output logic write;
  
  wire [31:0] wb_reg_in;
  
  assign wb_reg_in = (wb_sel) ? mem_data : result;
  
  always_ff @(posedge clk)
	wb_reg <= wb_reg_in;

  always_ff @(posedge clk, negedge rst_n)
	if (!rst_n)
		write <= 0;
	else if (flush)
		write <= 0;
	else
		write <= write_in;

endmodule