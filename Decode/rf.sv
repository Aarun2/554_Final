module rf
	(
	 input clk_i, rst_n_i, write_enable_i, 
	 input [4:0] read_reg2_sel_i, reg_write_dst_i, read_reg1_sel_i,
	 input [31:0] write_data_i, 
	 output [31:0] read_data1_o, read_data2_o
	);
	
	reg [31:0] mem [31:0];
	
	initial	
		$readmemh("./test_1.txt", mem);
	
	assign read_data1_o = write_enable_i ? (reg_write_dst_i == read_reg1_sel_i) ? write_data_i : mem[read_reg1_sel_i] : mem[read_reg1_sel_i];
	assign read_data2_o = write_enable_i ? (reg_write_dst_i == read_reg2_sel_i) ? write_data_i : mem[read_reg2_sel_i] : mem[read_reg2_sel_i];
	
	always_ff @(posedge clk_i, negedge rst_n_i)
		for (int i = 0; i < 32; i++) begin
			if (!rst_n_i)
				mem[i] <= 0;
			else if (write_enable_i && (reg_write_dst_i == i))
				mem[i] <= write_data_i;
		end
			
endmodule