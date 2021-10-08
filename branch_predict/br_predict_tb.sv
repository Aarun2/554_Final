module br_predict_tb();

	logic clk, rst_n;
	logic taken, take;

	br_predict pred_dut (.clk(clk), .rst_n(rst_n), .taken(taken), .take(take));

	initial begin
		clk = 0;
		rst_n = 0;
		@(posedge clk);
		rst_n = 1;
		for (int i = 0; i < 10; i++) begin
			taken = ;
			
		end
	end
	
	always begin
		#5 clk = ~clk;
	end


endmodule