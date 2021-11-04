`timescale 1ns/1ns
module fetch_tb();

	localparam PC_BITS = 16;

	logic clk, rst_n, stall, branch;
	logic [PC_BITS-1:0] pcIn, pcOut, instr;
	
	logic [PC_BITS-1:0] pcCheck, pcPrev;
	
	fetch fetch_DUT (.clk(clk), .rst_n(rst_n), .instr(instr), .pcIn(pcIn), 
										.pcOut(pcOut), .branch(branch), .stall(stall));
	
	////////////////////////////////////////////////////////////////////
	// Init task
	////////////////////////////////////////////////////////////////////
	task init();
		clk = 0;
		rst_n = 1'b1;
		@(posedge clk);
		rst_n = 1'b0;
		stall = 1'b0;
		branch = 1'b0;
		@(posedge clk);
		rst_n = 1'b1;
	endtask
	
	////////////////////////////////////////////////////////////////////
	// Task that tests random PC inputs for branch condition and checks for correct output //
	////////////////////////////////////////////////////////////////////
	task random_pcIn();
		@(posedge clk);
		branch = 1'b1;
		stall = 1'b0;
		pcIn = $random();
		pcCheck = pcIn + 4;
		@(posedge clk);
		@(posedge clk);
		if (pcCheck !== pcOut) begin
			$display("Random pcIn was not incremented correctly	%h %h", pcCheck, pcOut);
			$stop();
		end
	endtask
	
	////////////////////////////////////////////////////////////////////
	// Task that exhaustively tests PC inputs for branch condition    //
	////////////////////////////////////////////////////////////////////
	task exhaustive_pcIn(integer i);
		@(posedge clk);
		branch = 1'b1;
		stall = 1'b0;
		pcIn = i;
		pcCheck = pcIn + 4;
		@(posedge clk);
		@(posedge clk);
		if (pcCheck !== pcOut) begin
			$display("pcIn was not incremented correctly	%h %h", pcCheck, pcOut);
			$stop();
		end
	endtask
	
	///////////////////////////////////////////////////////////////////////////
	// Task checks when branch signal is low, PcIn has no impact on PcOut   //
	// This doubles as making sure the PC increments by 4 each cycle				//
	//////////////////////////////////////////////////////////////////////////
	task branch_is_low_pcIn();
		branch = 1'b0;
		stall = 1'b0;
		pcIn = $random();
		@(posedge clk);
		pcCheck = pcOut + 4;
		@(posedge clk);
		if (pcCheck !== pcOut) begin
			$display("err: pcIn should have no impact when branch is low %d %d", pcCheck, pcOut);
			$stop();
		end
	endtask
	
	////////////////////////////////////////////////////////////////////
	// Task that checks stall does not change pc   //
	////////////////////////////////////////////////////////////////////
	task stall_test();
		stall = 1'b1;
		pcPrev = pcOut;
		@(posedge clk);
		if (pcOut !== pcPrev) begin
			$display("err: stall should not allow pc to change!!");
			$stop();
		end
	endtask
	
	initial begin
		//Set up signals
		init();
		
		// Test 1: Do some random pcIns //
		$display("Random PcIn Test");
		for (int i = 0; i < 1000; i++) begin
			random_pcIn();
		end
		$display("Random pcIn Test Complete");
		
		// Test 2: Exhaustive pcIns //
		$display("Exhaustiv pcIn Test");
		for (int i = 0; i < 2**PC_BITS; i++) begin
			exhaustive_pcIn(i);
		end
		$display("Exhaustive pcIn Test Complete");
		
		// Test 3: PcIn has no impact when branch is low  and pc incs by 4 each cycle//
		$display("pcIn no impact Test");
		for (int i = 0; i < 1000; i++) begin
			branch_is_low_pcIn();
		end
		$display("pcIn no impact Test Complete");
		
		// Test 4: Make sure stall does not allow PC to change //
		$display("Stall Test");
		for (int i = 0; i < 1000; i++) begin
			stall_test();
		end
		$display("Stall Test Complete");
		
		// Test 5: Reset Memory Test //
		$display("Memory Reset Test");
		rst_n = 0;
		stall = 1'b0;
		@(posedge clk);
		rst_n = 1;
		@(posedge clk);
		if (pcOut !== 4) begin
			$display("Err: reset should make PC go to 4! (because of adder after flop)");
			$stop();
		end

		$display("Memory Reset Test Complete");
		
		$display("Yahoo Tests Passed!");
		$stop();
	end
	
	always #5 clk = ~clk;

endmodule