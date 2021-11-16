`timescale 1ns/1ns
module fetch_tb();

	localparam PC_BITS = 16;

	logic clk_i, rst_n_i, stall_i, branch_i;
	logic [PC_BITS-1:0] pc_i, pc_o, instr_o;
	
	logic [PC_BITS-1:0] pc_check, pc_prev;
	
	fetch fetch_DUT (.clk_i(clk_i), .rst_n_i(rst_n_i), .instr_o(instr_o), .pc_i(pc_i), 
										.pc_o(pc_o), .branch_i(branch_i), .stall_i(stall_i));
	
	////////////////////////////////////////////////////////////////////
	// Init task
	////////////////////////////////////////////////////////////////////
	task init();
		clk_i = 0;
		rst_n_i = 1'b1;
		@(posedge clk_i);
		rst_n_i = 1'b0;
		stall_i = 1'b0;
		branch_i = 1'b0;
		@(posedge clk_i);
		rst_n_i = 1'b1;
	endtask
	
	////////////////////////////////////////////////////////////////////
	// Task that tests random PC inputs for branch_i condition and checks for correct output //
	////////////////////////////////////////////////////////////////////
	task random_pcIn();
		@(posedge clk_i);
		branch_i = 1'b1;
		stall_i = 1'b0;
		pc_i = $random();
		pc_check = pc_i + 4;
		@(posedge clk_i);
		@(posedge clk_i);
		if (pc_check !== pc_o) begin
			$display("Random pc_i was not incremented correctly	%h %h", pc_check, pc_o);
			$stop();
		end
	endtask
	
	////////////////////////////////////////////////////////////////////
	// Task that exhaustively tests PC inputs for branch_i condition    //
	////////////////////////////////////////////////////////////////////
	task exhaustive_pcIn(integer i);
		@(posedge clk_i);
		branch_i = 1'b1;
		stall_i = 1'b0;
		pc_i = i;
		pc_check = pc_i + 4;
		@(posedge clk_i);
		@(posedge clk_i);
		if (pc_check !== pc_o) begin
			$display("pc_i was not incremented correctly	%h %h", pc_check, pc_o);
			$stop();
		end
	endtask
	
	///////////////////////////////////////////////////////////////////////////
	// Task checks when branch_i signal is low, pc_i has no impact on pc_o   //
	// This doubles as making sure the PC increments by 4 each cycle				//
	//////////////////////////////////////////////////////////////////////////
	task branch_is_low_pcIn();
		branch_i = 1'b0;
		stall_i = 1'b0;
		pc_i = $random();
		@(posedge clk_i);
		pc_check = pc_o + 4;
		@(posedge clk_i);
		if (pc_check !== pc_o) begin
			$display("err: pc_i should have no impact when branch_i is low %d %d", pc_check, pc_o);
			$stop();
		end
	endtask
	
	////////////////////////////////////////////////////////////////////
	// Task that checks stall_i does not change pc   //
	////////////////////////////////////////////////////////////////////
	task stall_test();
		stall_i = 1'b1;
		pc_prev = pc_o;
		@(posedge clk_i);
		if (pc_o !== pc_prev) begin
			$display("err: stall_i should not allow pc to change!!");
			$stop();
		end
	endtask
	
	initial begin
		//Set up signals
		init();
		
		// Test 1: Do some random pcIns //
		$display("Random pc_i Test");
		for (int i = 0; i < 1000; i++) begin
			random_pcIn();
		end
		$display("Random pc_i Test Complete");
		
		// Test 2: Exhaustive pcIns //
		$display("Exhaustiv pc_i Test");
		for (int i = 0; i < 2**PC_BITS; i++) begin
			exhaustive_pcIn(i);
		end
		$display("Exhaustive pc_i Test Complete");
		
		// Test 3: pc_i has no impact when branch_i is low  and pc incs by 4 each cycle//
		$display("pc_i no impact Test");
		for (int i = 0; i < 1000; i++) begin
			branch_is_low_pcIn();
		end
		$display("pc_i no impact Test Complete");
		
		// Test 4: Make sure stall_i does not allow PC to change //
		$display("stall_i Test");
		for (int i = 0; i < 1000; i++) begin
			stall_test();
		end
		$display("stall_i Test Complete");
		
		// Test 5: Reset Memory Test //
		$display("Memory Reset Test");
		rst_n_i = 0;
		stall_i = 1'b0;
		@(posedge clk_i);
		rst_n_i = 1;
		@(posedge clk_i);
		if (pc_o !== 4) begin
			$display("Err: reset should make PC go to 4! (because of adder after flop)");
			$stop();
		end

		$display("Memory Reset Test Complete");
		
		$display("Yahoo Tests Passed!");
		$stop();
	end
	
	always #5 clk_i = ~clk_i;

endmodule