module writeback(clk, rst_n, flush, wb_sel, write_d, result, mem_data, writedata, write);
  
  input clk, rst_n, flush, wb_sel, write_d;
  input [31:0] result, mem_data;
  
  output logic [31:0] writedata;
  output logic write;
    
  assign write =  flush ? 0 : write_d;
  
  assign writedata = (wb_sel) ? mem_data : result;

endmodule