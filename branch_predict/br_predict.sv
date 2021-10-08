module br_predict(clk, rst_n, taken, take);
	input clk, rst_n;
	input taken;
	output logic take;
	
	typedef enum logic {S_TAKEN, TAKEN, N_TAKEN, SN_TAKEN} state_t;
	state_t state, nxt_state;
	
	always_ff @(posedge clk, negedge rst_n) begin
		if (!rst_n)
			state <= S_TAKEN;
		else
			state <= nxt_state;
	end
	
	always_comb begin
		nxt_state = state;
		case(state)
			S_TAKEN : begin
				if (~taken)
					nxt_state = TAKEN;
				take = 1;
			end
			TAKEN : begin
				if (taken)
					nxt_state = S_TAKEN;
				else
					nxt_state = N_TAKEN;
				take = 1;
			end
			N_TAKEN : begin
				if (taken)
					nxt_state = TAKEN;
				else
					nxt_state = SN_TAKEN;
				take = 0;
			end
			SN_TAKEN : begin
				if (taken)
					nxt_state = N_TAKEN;
				take = 0;
			end
		endcase
	end

endmodule