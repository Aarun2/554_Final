`timescale 1ns/1ns
module rf_tb();

	logic clk, rst_n, write, bool;
	logic [4:0] read1regsel, read2regsel, writeregsel, rand_read1_sel, rand_read2_sel, rand_writeregsel;
	logic [31:0] writedata, read1data, read2data;
	
	logic [31:0] mem [31:0];
	
	rf rf_DUT (.clk_i(clk), .rst_n_i(rst_n), .read_reg1_sel_i(read1regsel), .read_reg2_sel_i(read2regsel), .write_enable_i(write), 
	           .reg_write_dst_i(writeregsel), .write_data_i(writedata), .read_data1_o(read1data), .read_data2_o(read2data));
	
	initial
		$readmemh("./test.txt", mem);
	
	/////////////////////////////////////////////////////////////////
	// Task that reads a random index and checks if read is valid  //
	/////////////////////////////////////////////////////////////////
	task random_reads();
		rand_read1_sel = $random();
		rand_read2_sel = $random();
		read1regsel = rand_read1_sel;
		read2regsel = rand_read2_sel;
		@(posedge clk);
		if (mem[read1regsel] !== read1data) begin
			$display("Read1 data is not accurate");
			$stop();
		end
		
		if (mem[read2regsel] !== read2data) begin
			$display("Read2 data is not accurate");
			$stop();
		end	
	endtask
	
	//////////////////////////////////////////////////////////////////////////////////////
	// Task that reads from first select line at a specific index and checks if correct //
	//////////////////////////////////////////////////////////////////////////////////////
	task read_specifc1(integer i);
		read1regsel = i;
		read2regsel = $random();
		@(posedge clk);
		if (mem[i] !== read1data) begin
			$display("Read1 data is not accurate");
			$stop();
		end
	endtask
	
	//////////////////////////////////////////////////////////////////////////////////////
	// Task that reads from second select line at a specific index and checks if correct//
	//////////////////////////////////////////////////////////////////////////////////////
	task read_specifc2(integer i);
		read1regsel = $random();
		read2regsel = i;
		@(posedge clk);
		if (mem[i] !== read2data) begin
			$display("Read2 data is not accurate");
			$stop();
		end
	endtask
	
	//////////////////////////////////////////////////////////////////////////////////////
	// Task that writes a random value to a specific index and checks if correct        //
	//////////////////////////////////////////////////////////////////////////////////////
	task write_specific(integer i);
		writeregsel = i;
		write = 1;
		writedata = $random();
		mem[i] = writedata;
		@(posedge clk);
		write = 0;
		writeregsel = $random();
		writedata = $random();
		read1regsel = i;
		read2regsel = $random();
		@(posedge clk);
		if (mem[i] !== read1data) begin
			$display("Sequential data write is broken");
			$stop();
		end
	endtask
	
	//////////////////////////////////////////////////////////////////////////////////////
	// Task that writes a random value and read at the same specific index              //
	//////////////////////////////////////////////////////////////////////////////////////
	task read_write_specific(integer i);
		writeregsel = i;
		write = 1;
		writedata = $random();
		mem[i] = writedata;
		read1regsel = i;
		read2regsel = $random();
		@(posedge clk);
		write = 0;
		writeregsel = $random();
		writedata = $random();
		if (mem[i] !== read1data) begin
			$display("Read and Write to and from same location fails");
			$stop();
		end
	endtask
	
	/////////////////////////////////////////////////////////////////
	// Write to a random location and pick a random port to check  //
	/////////////////////////////////////////////////////////////////
	task random_writes();
		rand_writeregsel = $random();
		write = 1;
		writeregsel = rand_writeregsel;
		writedata = $random(); // write a random value
		mem[rand_writeregsel] = writedata;
		@(posedge clk);
		// don't write again
		write = 0;
		writeregsel = $random();
		writedata = $random();
		
		bool = $random() % 2; // what port to read from
		if (bool) begin // first regsel
			read1regsel = rand_writeregsel;
			read2regsel = $random();
			@(posedge clk);
			if (mem[rand_writeregsel] !== read1data) begin
				$display("Random data write is broken");
				$stop();
			end
		end
		else begin
			read1regsel = $random();
			read2regsel = rand_writeregsel;
			@(posedge clk);
			if (mem[rand_writeregsel] !== read2data) begin
				$display("Random data write is broken");
				$stop();
			end
		end
	endtask
			   
	initial begin
		clk = 0;
		rst_n = 1;
		write = 0;
		// Test 1: Do some random reads //
		$display("Random Reads Test");
		for (int i = 0; i < 500; i++) begin
			random_reads();
		end
		$display("Random Reads Test Complete");
		
		// Test 2: Exhaustive select1 read //
		$display("Exhaustive Select 1 Read Test");
		for (int i = 0; i < 32; i++) begin
			read_specifc1(i);
		end
		$display("Exhaustive Select 1 Read Test Complete");
		
		// Test 3: Exhaustive select2 read //
		$display("Exhaustive Select 2 Read Test");
		for (int i = 0; i < 32; i++) begin
			read_specifc2(i);
		end
		$display("Exhaustive Select 2 Read Test Complete");
		
		// Test 4: Do some random writes and check it //
		$display("Random Write Test");
		for (int i = 0; i < 500; i++) begin
			random_writes();
		end
		$display("Random Write Test Complete");
		
		// Test 5: Exhaustive Write Test //
		$display("Exhaustive Write Test");
		for (int i = 0; i < 32; i++) begin
			write_specific(i);
		end
		$display("Exhaustive Write Test Complete");
		
		// Test 6: Same Read and Write Exhaustive Test //
		$display("Exhaustive Read and Write Test");
		for (int i = 0; i < 32; i++) begin
			read_write_specific(i);
		end
		$display("Exhaustive Read and Write Test Complete");
		
		// Test 7: Reset Memory Test //
		$display("Memory Reset Test");
		rst_n = 0;
		@(posedge clk);
		rst_n = 1;
		for (int i = 0, j = 0; i < 31; i += 2) begin
			j = i+1;
			read1regsel = i;
			read2regsel = j;
			@(posedge clk);
			if (read1data !== 0) begin
				$display("Value at %d is not reset instead it is %h", i, read1data);
				$stop();
			end
			if (read2data !== 0) begin
				$display("Value at %d is not reset instead it is %h", j, read2data);
				$stop();
			end
		end
		$display("Memory Reset Test Complete");
		
		$display("Yahoo Tests Passed!");
		$stop();
	end
	
	always #5 clk = ~clk;

endmodule
