module writeback
  (
  input flush_i, stall_i, reg_write_enable_i, forward_en_i,
  input [1:0] wb_sel_i,
  input [31:0] result_i, mem_data_i, cout_i, forward_data_i,
  output [31:0] reg_write_data_o,
  output reg_write_enable_o
  ); 

  logic [31:0] result_d;
  
  assign reg_write_enable_o =  flush_i ? 0 : reg_write_enable_i;
  
  assign result_d = (forward_en_i) ? forward_data_i : result_i;
    
  assign reg_write_data_o = (wb_sel_i == 2'b00) ? result_i : (wb_sel_i == 2'b01) ? mem_data_i : (wb_sel_i == 2'b10) ? cout_i : result_d;

endmodule