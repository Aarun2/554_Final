module proc_bubble_cache_tb();

	logic clk;
	logic rst_n;
	
	localparam REG_SIZE = 32;
	localparam MAT_DIM = 32;
	
	localparam NOP = 		7'b0000000;
	localparam ADD = 		7'b0000001;
	localparam SUB = 		7'b0000010;
	localparam XOR = 		7'b0000011;
	localparam OR = 		7'b0000100;
	localparam AND = 		7'b0000101;
	localparam SLL = 		7'b0000110;
	localparam SRL = 		7'b0000111;
	localparam SRA = 		7'b0001000;
	localparam SLT = 		7'b0001001;
	localparam MUL = 		7'b0001010;
	
	localparam ADDI = 		7'b0010001;
	localparam XORI = 		7'b0010011;
	localparam ORI = 		7'b0010100;
	localparam ANDI = 		7'b0010101;
	localparam SLLI = 		7'b0010110;
	localparam SRLI =		7'b0010111;
	localparam SRAI = 		7'b0011000;
	localparam SLTI = 		7'b0011001;
	localparam LUI = 		7'b0011011;
	
	localparam LW = 		7'b0100000;
	localparam SW = 		7'b0100001;
	
	localparam BE = 		7'b0111100;
	localparam BNE = 		7'b0111101;
	localparam BLT = 		7'b0111111;
	localparam BGT = 		7'b0111110;
	
	localparam J = 			7'b1111110;
	localparam JR = 		7'b1111111;
	
	localparam MATMUL = 	7'b1010000;
	localparam LAM = 		7'b1010001;
	localparam LBM = 		7'b1010010;
	localparam LACC = 		7'b1010011;
	localparam RACC = 		7'b1010100;
	
	
	logic [REG_SIZE-1:0] local_pc, next_pc, prev_pc;
	//logic [(REG_SIZE/4)-1:0] local_inst_mem [(2**(16+2))-1:0];
	//logic [(REG_SIZE/4)-1:0] local_data_mem [(2**(16+2))-1:0];
	logic [7:0] local_mem [(2**16)-1 : 0];
	logic [REG_SIZE-1:0] local_rf [REG_SIZE-1:0];
	logic [(REG_SIZE/2) - 1: 0] local_A [31:0][31:0];
	logic [(REG_SIZE/2) - 1: 0] local_B [31:0][31:0];
	logic [REG_SIZE - 1: 0] local_C [31:0][31:0];
	logic f_stall, d_stall, e_stall, m_stall, w_stall, f_flush, d_flush, e_flush, m_flush, w_flush;
	assign f_stall = dut.cf_to_fe_f_stall;
	assign d_stall = dut.cf_to_de_d_stall;
	assign e_stall = dut.cf_to_ex_e_stall;
	assign m_stall = dut.cf_to_mem_m_stall;
	assign w_stall = dut.cf_to_wb_w_stall;
	
	assign f_flush = dut.cf_to_fe_f_flush;
	assign d_flush = dut.cf_to_de_d_flush;
	assign e_flush = dut.cf_to_ex_e_flush;
	assign m_flush = dut.cf_to_mem_m_flush;
	assign w_flush = dut.cf_to_wb_w_flush;
	
	proc_bubble_cache dut(
		.clk(clk),
		.rst_n(rst_n)
	);
	
	logic [31:0] mem_32 [(2**16)-1:0];
	
	
	// Idea: Make local memory, local Rf, local TPU A, B, C, local PC,
	// Read instructions from local I-cache as well
	// ASSUMPTION: 	WHEN AN INSTRUCTION REACHES THE STAGE WHERE IT IS TO MAKE A CHANGE
	// 				ASSUME THAT ALL DEPENDENCIES HAVE BEEN TAKEN CARE OF AND THAT THE
	//				CURRENT STATE OF THE MACHINE REFLECTS THE COMPLETE CHANGES OF ALL
	//				PRIOR INSTRUCTIONS. ALSO ASSUMES CONTROL SIGNALS WORK PROPERLY
	
	// CHANGES TO:
	
	// REG: Done in WB, check in WB + 1
	// MEM: done in MEM, check in WB
	// PC: done in EX, check in mem
	// MatA: done in EX, check in mem
	// MatB: done in Ex, check in mem
	// MatC: done in Ex, check in mem
	enum {NOTHING, CHANGE_REG, CHANGE_MEM, CHANGE_PC, CHANGE_A, CHANGE_B, CHANGE_C} changeType;
	class Inst;
		int change;
		logic [REG_SIZE-1:0] instruction;
		function void copy(Inst curDst);
			this.change = curDst.change;
			this.instruction = curDst.instruction;
		endfunction
		function void clear();
			this.change = NOTHING;
			this.instruction = 0;
			//TODO:
		endfunction
		function void setUp(logic [REG_SIZE - 1: 0] instruction);
			this.instruction = instruction;
			case(instruction[31:25])
				NOP: begin 
					this.change = NOTHING;
				end
				ADD: begin 
					this.change = CHANGE_REG;
				end
				SUB: begin
					this.change = CHANGE_REG;
				end
				XOR: begin
					this.change = CHANGE_REG;
				end
				OR: begin
					this.change = CHANGE_REG;
				end
				AND: begin
					this.change = CHANGE_REG;
				end
				SLL: begin
					this.change = CHANGE_REG;
				end
				SRL: begin
					this.change = CHANGE_REG;
				end
				SRA: begin 
					this.change = CHANGE_REG;
				end
				SLT: begin 
					this.change = CHANGE_REG;
				end
				MUL: begin 
					this.change = CHANGE_REG;
				end
				ADDI: begin 
					this.change = CHANGE_REG;
				end
				XORI: begin
					this.change = CHANGE_REG;
				end
				ORI: begin
					this.change = CHANGE_REG;
				end
				ANDI: begin
					this.change = CHANGE_REG;
				end
				SLLI: begin
					this.change = CHANGE_REG;
				end
				SRLI: begin
					this.change = CHANGE_REG;
				end
				SRAI: begin
					this.change = CHANGE_REG;
				end
				SLTI: begin
					this.change = CHANGE_REG;
				end
				LUI: begin
					this.change = CHANGE_REG;
				end
				LW: begin
					this.change = CHANGE_REG;
				end
				SW: begin
					this.change = CHANGE_MEM;
				end
				BE: begin
					this.change = CHANGE_PC;
				end
				BNE: begin
					this.change = CHANGE_PC;
				end
				BLT: begin
					this.change = CHANGE_PC;
				end
				BGT: begin 
					this.change = CHANGE_PC;
				end
				J: begin
					this.change = CHANGE_PC;
				end
				JR: begin
					this.change = CHANGE_PC;
				end
				MATMUL: begin 
					this.change = CHANGE_C;
				end
				LAM: begin
					this.change = CHANGE_A;
				end
				LBM: begin
					this.change = CHANGE_B;
				end
				LACC: begin
					this.change = CHANGE_C;
				end
				RACC: begin
					this.change = CHANGE_REG;
				end
			endcase
		endfunction
	endclass
	
	Inst fe_inst;
	Inst de_inst;
	Inst ex_inst;
	Inst me_inst;
	Inst wb_inst;
	Inst complete_inst;
	
	always@(posedge clk) begin
		if(rst_n) begin
			if(local_pc != 388) begin
				//step();
				checkPrev();
				//checkAll();
				checkChange();
				step();
			end else begin
				$display("TB is over!");
				$stop();
			end
		end
	end
	
	always #5 clk = ~clk;
	
	initial begin
		//$readmemh("simple_add_bytes.txt", local_inst_mem);
		$readmemh("test_cache.txt", local_mem);
		$readmemh("prog.hex", mem_32);
		for (int i = 0; i < 2**10; i++) begin
			local_mem[(i*4)] = mem_32[i][31:24];
			local_mem[(i*4) + 1] = mem_32[i][23:16];
			local_mem[(i*4) + 2] = mem_32[i][15:8];
			local_mem[(i*4) + 3] = mem_32[i][7:0];
		
		end
		fe_inst = new();
		fe_inst.clear();
		de_inst = new();
		de_inst.clear();
		ex_inst = new();
		ex_inst.clear();
		me_inst = new();
		me_inst.clear();
		wb_inst = new();
		wb_inst.clear();
		complete_inst = new();
		complete_inst.clear();
		local_pc = 0;
		next_pc = 4;
		for(int i = 0; i < 32; i++) begin
			local_rf[i] = 0;
		end
		for(int j = 0; j < 32; j++) begin
			for (int k = 0; k < 32; k++) begin
				local_A [j][k] = 0;
				local_B [j][k] = 0;
				local_C [j][k] = 0;
			end
		end
		clk = 0;
		rst_n = 0;
		@(posedge clk);
		@(posedge clk);
		rst_n = 1;
		
		
	end
	
	function void checkPrev();
		if(complete_inst.change == CHANGE_REG) begin
			compare(complete_inst.instruction);
		end
		
		if(wb_inst.change == CHANGE_MEM) begin
			compare(wb_inst.instruction);
		end
		
		if(me_inst.change == CHANGE_PC) begin
			compare(me_inst.instruction);
		end
		
		if(me_inst.change == CHANGE_A) begin
			compare(me_inst.instruction);
		end
		
		if(me_inst.change == CHANGE_B) begin
			compare(me_inst.instruction);
		end
		
		if(me_inst.change == CHANGE_C) begin
			compare(me_inst.instruction);
		end
	
	endfunction
	
	function void checkChange();
		if(wb_inst.change == CHANGE_REG) begin
			doChange(wb_inst.instruction);
		end
		
		if(me_inst.change == CHANGE_MEM) begin
			doChange(me_inst.instruction);
		end
		
		if(ex_inst.change == CHANGE_PC) begin
			doChange(ex_inst.instruction);
		end
		
		if(ex_inst.change == CHANGE_A) begin
			doChange(ex_inst.instruction);
		end
		
		if(ex_inst.change == CHANGE_B) begin
			doChange(ex_inst.instruction);
		end
		
		if(ex_inst.change == CHANGE_C) begin
			doChange(ex_inst.instruction);
		end
	endfunction
	
	// Moves instructions based on stall and flush signals
	function void step();
		// Complete
		if(w_flush) begin
			complete_inst.clear();
		end else begin
			complete_inst.copy(wb_inst);
		end
		
		// Writeback
		if(w_stall) begin
		
		end else begin 
			if(m_flush) begin
				wb_inst.clear();
			end else begin
				wb_inst.copy(me_inst);
			end
		end
		
		// Memory
		if(m_stall) begin
		
		end else begin
			if(e_flush) begin
				me_inst.clear();
			end else begin 
				me_inst.copy(ex_inst);
			end
		end
		
		// Execute
		if(e_stall) begin
		
		end else begin
			if(d_flush) begin
				ex_inst.clear();
			end else begin
				ex_inst.copy(de_inst);
			end
		
		end
		
		// Decode
		if(d_stall) begin
		
		end else begin
			if(f_flush) begin
				de_inst.clear();
			end else begin
				de_inst.copy(fe_inst);
			end
		
		end
		
		// Fetch
		
		if(f_stall) begin
			
		end else begin
			local_pc = next_pc;
			next_pc = local_pc + 4;
			//prev_pc = local_pc;
			//local_pc = local_pc + 4;
		end
		fe_inst.setUp(virtRead(local_pc));
	endfunction
	
	function void compare(logic [REG_SIZE-1:0] inst);
		case(inst[31:25])
				NOP: begin
				end
				ADD: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD ADD: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				SUB: begin 
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD SUB: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				XOR: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD XOR: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				OR: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD OR: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				AND: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD AND: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				SLL: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD SLL: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				SRL: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD SRL: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				SRA: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD SRA: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				SLT: begin 
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD SLT: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				MUL: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD MUL: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				ADDI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD ADDI: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				XORI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD XORI: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				ORI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD ORI: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				ANDI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD ANDI: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				SLLI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD SLLI: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				SRLI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD SRLI: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				SRAI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD SRAI: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				SLTI: begin 
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD SLTI: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				LUI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD LUI: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				LW: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD LW: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
				SW: begin
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic signed [REG_SIZE-1:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					logic [31:0] A ,B;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = {{17{inst[24]}}, inst[24:20], inst[9:0]};
					A = virtRead(local_rf[reg1] + imm);
					B = realRead(local_rf[reg1] + imm);
					//virtDataWrite(local_rf[reg1] + imm, local_rf[reg2]);
					if(A != B) begin
						$display("BAD SW: EXPECTED: %d GOT: %d", virtRead(local_rf[reg1] + imm), realRead(local_rf[reg1] + imm));
						$stop();
					end
				end
				BE: begin
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic signed [REG_SIZE-1:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = {{17{inst[24]}}, inst[24:20], inst[9:0]};
					//next_pc = (reg1Val == reg2Val) ? (local_pc + imm):(next_pc);
					if(local_pc != dut.fetch.addr) begin
						$display("BAD BE: EXPECTED: %d GOT: %d", local_pc, dut.fetch.addr);
						$stop();
					end
				end
				BNE: begin
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic signed [REG_SIZE-1:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = {{17{inst[24]}}, inst[24:20], inst[9:0]};
					if(local_pc != dut.fetch.addr) begin
						$display("BAD BNE: EXPECTED: %d GOT: %d", local_pc, dut.fetch.addr);
						$stop();
					end
				end
				BLT: begin 
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic signed [REG_SIZE-1:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = {{17{inst[24]}}, inst[24:20], inst[9:0]};
					if(local_pc != dut.fetch.addr) begin
						$display("BAD BLT: EXPECTED: %d GOT: %d", local_pc, dut.fetch.addr);
						$stop();
					end
				end
				BGT: begin
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic signed [REG_SIZE-1:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = {{17{inst[24]}}, inst[24:20], inst[9:0]};
					if(local_pc != dut.fetch.addr) begin
						$display("BAD BGT: EXPECTED: %d GOT: %d", local_pc, dut.fetch.addr);
						$stop();
					end
				end
				J: begin
					logic [14:0] imm ;
					imm = {{17{inst[14]}}, inst[14:0]};
					if(local_pc != dut.fetch.addr) begin
						$display("BAD J: EXPECTED: %d GOT: %d", local_pc, dut.fetch.addr);
						$stop();
					end
				end
				JR: begin 
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					if(local_pc != dut.fetch.addr) begin
						$display("BAD JR: EXPECTED: %d GOT: %d", local_pc, dut.fetch.addr);
						$stop();
					end
				end
				MATMUL: begin
					int x, y;
					for( x = 0; x < MAT_DIM; x++) begin
						for( y = 0; y < MAT_DIM; y++) begin
							if(local_C[x][y] != dut.execute.i_tpuv1.iSYSARRY.macCOut[x][y]) begin
								$display("BAD MATMUL: EXPECTED: %d GOT: %d at [%d][%d]", local_C[x][y], dut.execute.i_tpuv1.iSYSARRY.macCOut[x][y], x, y);
								$stop();
							end
						
						end
					
					end


				end
				LAM: begin 
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					logic [4:0] row;
					logic [4:0] col;
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					row = inst[14:10];
					col = inst[9:5];
					if(local_A [row][col] != dut.execute.i_tpuv1.iMEMA.iMATRIXAFIFO.tword[row][col]) begin
						$display("BAD LAM: EXPECTED: %d GOT: %d at [%d][%d]", local_A [row][col], dut.execute.i_tpuv1.iMEMA.iMATRIXAFIFO.tword[row][col], row, col);
						$stop();
					end
				end
				LBM: begin
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					logic [4:0] row;
					logic [4:0] col;
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					row = inst[14:10];
					col = inst[9:5];
					if(local_B [row][col] != dut.execute.i_tpuv1.iMEMB.iMATRIXBFIFO.tword[row][col]) begin
						$display("BAD LBM: EXPECTED: %d GOT: %d", local_B [row][col], dut.execute.i_tpuv1.iMEMB.iMATRIXBFIFO.tword[row][col]);
						$stop();
					end
				end
				LACC: begin
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					logic [4:0] row;
					logic [4:0] col;
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					row = inst[14:10];
					col = inst[9:5];
					if(local_C [row][col] != dut.execute.i_tpuv1.iSYSARRY.macCOut[row][col]) begin
						$display("BAD LACC: EXPECTED: %d GOT: %d", local_A [row][col], dut.execute.i_tpuv1.iSYSARRY.macCOut[row][col]);
						$stop();
					end
				end
				RACC: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != realRegRead(dst)) begin
						$display("BAD RACC: EXPECTED: %d GOT: %d", local_rf[dst], realRegRead(dst));
						$stop();
					end
				end
			endcase
	endfunction
	
	function void doChange(logic [REG_SIZE-1:0] inst);
		case(inst[31:25])
				NOP: begin
				end
				ADD: begin
					logic [4:0] dst;
					logic [4:0] reg1;
					logic [4:0] reg2;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					local_rf [dst] = local_rf[reg1] + local_rf[reg2];
				end
				SUB: begin 
					logic [4:0] dst;
					logic [4:0] reg1;
					logic [4:0] reg2;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					local_rf [dst] = local_rf[reg1] - local_rf[reg2];
				end
				XOR: begin
					logic [4:0] dst;
					logic [4:0] reg1;
					logic [4:0] reg2;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					local_rf [dst] = local_rf[reg1] ^ local_rf[reg2];
				end
				OR: begin
					logic [4:0] dst;
					logic [4:0] reg1;
					logic [4:0] reg2;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					local_rf [dst] = local_rf[reg1] | local_rf[reg2];
				end
				AND: begin
					logic [4:0] dst;
					logic [4:0] reg1;
					logic [4:0] reg2;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					local_rf [dst] = local_rf[reg1] & local_rf[reg2];
				end
				SLL: begin
					logic [4:0] dst;
					logic [4:0] reg1;
					logic [4:0] reg2;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					local_rf [dst] = local_rf[reg1] << local_rf[reg2];
				end
				SRL: begin
					logic [4:0] dst;
					logic [4:0] reg1;
					logic [4:0] reg2;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					local_rf [dst] = local_rf[reg1] >> local_rf[reg2];
				end
				SRA: begin
					logic [4:0] dst;
					logic [4:0] reg1;
					logic [4:0] reg2;
					//logic [REG_SIZE-1:0] reg1Val;
					//logic [REG_SIZE-1:0] reg2Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					//reg1Val = local_rf[reg1];
					//reg2Val = local_rf[reg2];
					//local_rf [dst] = reg1Val >>> reg2Val[4:0];
					local_rf[dst] = local_rf[reg1] >>> local_rf[reg2][4:0];
				end
				SLT: begin 
					logic [4:0] dst;
					logic [4:0] reg1;
					logic [4:0] reg2;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					local_rf [dst] = local_rf[reg1] < local_rf[reg2];
				end
				MUL: begin
					logic [4:0] dst;
					logic [4:0] reg1;
					logic [4:0] reg2;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					local_rf [dst] = local_rf[reg1] + local_rf[reg2];
				end
				ADDI: begin
					logic [4:0] dst;
					logic signed [REG_SIZE-1:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = {{17{inst[14]}}, inst[14:0]};
					local_rf [dst] = reg1Val + imm;
				end
				XORI: begin
					logic [4:0] dst;
					logic signed [REG_SIZE-1:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = {{17{inst[14]}}, inst[14:0]};
					local_rf [dst] = reg1Val ^ imm;
				end
				ORI: begin
					logic [4:0] dst;
					logic signed [REG_SIZE-1:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = {{17{inst[14]}}, inst[14:0]};
					local_rf [dst] = reg1Val | imm;
				end
				ANDI: begin
					logic [4:0] dst;
					logic signed [REG_SIZE-1:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = {{17{inst[14]}}, inst[14:0]};
					local_rf [dst] = reg1Val & imm;
				end
				SLLI: begin
					logic [4:0] dst;
					logic signed [REG_SIZE-1:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = {{17{inst[14]}}, inst[14:0]};
					local_rf [dst] = reg1Val << imm;
				end
				SRLI: begin
					logic [4:0] dst;
					logic signed [REG_SIZE-1:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = {{17{inst[14]}}, inst[14:0]};
					local_rf [dst] = reg1Val >> imm;
				end
				SRAI: begin
					logic [4:0] dst;
					logic signed [REG_SIZE-1:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = {{17{inst[14]}}, inst[14:0]};
					local_rf [dst] = reg1Val >>> imm[4:0];
				
				end
				SLTI: begin 
					logic [4:0] dst;
					logic signed [REG_SIZE-1:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = {{17{inst[14]}}, inst[14:0]};
					local_rf [dst] = reg1Val < imm;
				end
				LUI: begin
					logic [4:0] dst;
					logic signed [REG_SIZE-1:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = {{17{inst[14]}}, inst[14:0]};
					local_rf [dst] = imm << 12;
				end
				LW: begin
					logic [4:0] dst;
					logic signed [REG_SIZE-1:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = {{17{inst[14]}}, inst[14:0]};
					local_rf[dst] = virtRead(reg1Val + imm);
				end
				SW: begin
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic signed [REG_SIZE-1:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = {{17{inst[24]}}, inst[24:20], inst[9:0]};
					//local_data_mem[reg1Val + imm] = reg2Val;
					virtWrite((reg1Val + imm),reg2Val);
				end
				BE: begin
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic signed [REG_SIZE-1:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = {{17{inst[24]}}, inst[24:20], inst[9:0]};
					local_pc = (reg1Val == reg2Val) ? (local_pc - 4 + imm):(local_pc);
					next_pc = local_pc + 4;
				end
				BNE: begin
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic signed [REG_SIZE-1:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = {{17{inst[24]}}, inst[24:20], inst[9:0]};
					local_pc = (reg1Val != reg2Val) ? (local_pc - 4 + imm):(local_pc);
					next_pc = local_pc + 4;
				end
				BLT: begin 
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic signed [REG_SIZE-1:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = {{17{inst[24]}}, inst[24:20], inst[9:0]};
					local_pc = (reg1Val < reg2Val) ? (local_pc - 4 + imm):(local_pc);
					next_pc = local_pc + 4;
				end
				BGT: begin
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic signed [REG_SIZE-1:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = {{17{inst[24]}}, inst[24:20], inst[9:0]};
					local_pc = (reg1Val > reg2Val) ? (local_pc - 4 + imm):(local_pc);
					next_pc = local_pc + 4;
				end
				J: begin
					logic signed [REG_SIZE-1:0] imm;
					imm = {{17{inst[14]}}, inst[14:0]};
					local_pc = local_pc  - 4 + imm;
					next_pc = local_pc + 4;
				end
				JR: begin 
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					local_pc = reg1Val;
					next_pc = local_pc + 4;
				end
				MATMUL: begin
					int x,y,z;
					for(x = 0; x < MAT_DIM; x++) begin
						for(y = 0; y < MAT_DIM; y++) begin
							logic [REG_SIZE-1:0] sum;
							sum = 0;
							for(z = 0; z < MAT_DIM; z++) begin
								sum = sum  + (local_A[x][z] * local_B[z][y]);
							end
							local_C [x][y] = sum;
						end
					
					end
				
				end
				LAM: begin 
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					logic [4:0] row;
					logic [4:0] col;
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					row = inst[14:10];
					col = inst[9:5];
					local_A [row][col] = reg1Val;
				end
				LBM: begin
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					logic [4:0] row;
					logic [4:0] col;
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					row = inst[14:10];
					col = inst[9:5];
					local_B [row][col] = reg1Val;
				end
				LACC: begin
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					logic [4:0] row;
					logic [4:0] col;
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					row = inst[14:10];
					col = inst[9:5];
					local_C [row][col] = reg1Val;
				end
				RACC: begin
					logic [4:0] dst;
					logic [4:0] row;
					logic [4:0] col;
					dst = inst[24:20];
					row = inst[14:10];
					col = inst[9:5];
					local_rf[dst] = local_C [row][col];
				end
			endcase
	
	endfunction
	
	function logic [REG_SIZE-1:0] virtRead(logic [REG_SIZE-1:0] addr);
		return {local_mem[addr], 
				local_mem[addr + 1], 
				local_mem[addr + 2], 
				local_mem[addr + 3]};
	endfunction 
	
	
	function void virtWrite(logic [REG_SIZE-1:0] addr, logic [REG_SIZE-1:0] data);
		local_mem[addr] = data[31:24] ;
		local_mem[addr + 1] = data[23:16];
		local_mem[addr + 2] = data[15:8];
		local_mem[addr + 3] = data[7:0];
	endfunction
	
	
	function logic [REG_SIZE-1:0] realRead(logic [REG_SIZE-1:0] addr);
		return {dut.dma.Mem[addr],
			dut.dma.Mem[addr + 1],
			dut.dma.Mem[addr + 2],
			dut.dma.Mem[addr + 3]};
	endfunction
	
	
	function logic [REG_SIZE-1:0] realRegRead(logic [REG_SIZE-1:0] addr);
		return dut.decode.reg_file.mem[addr];
	endfunction
	
	
	/*
	Notes:
		PC starts at 0
	
	
	
	*/
		
endmodule
