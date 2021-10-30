module writeback(wb_sel, result, mem_data, wb_reg);
  input wb_sel;
  input [31:0] result, mem_data;
  output [31:0] wb_reg;
  
  assign wb_reg = (wb_sel) ? result : mem_data;
  
endmodule
