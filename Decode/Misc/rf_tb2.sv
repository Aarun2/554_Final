module rf_tb2();

	logic clk, rst_n, write, init;
	logic [4:0] read1regsel, read2regsel, writeregsel, rand_read1_sel, rand_read2_sel, rand_writeregsel;
	logic [31:0] writedata, read1data, read2data;
	
	logic [31:0] mem [31:0];
	
	integer file_handle;

	rf_2 rf_DUT (.clk(clk), .rst_n(rst_n), .init(init), .read1regsel(read1regsel), .read2regsel(read2regsel), .write(write), 
	           .writeregsel(writeregsel), .writedata(writedata), .read1data(read1data), .read2data(read2data));
	
	task gen_rand();
		file_handle = $fopen("test.txt", "w");
		error = $ferror(file_handle, err_str);
	endtask

endmodule