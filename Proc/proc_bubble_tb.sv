module proc_bubble_tb();

	logic clk;
	logic rst_n;
	
	localparam REG_SIZE = 32;
	
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
	
	
	logic [REG_SIZE-1:0] local_pc, next_pc;
	logic [REG_SIZE-1:0] local_inst_mem [(2**16)-1:0];
	logic [REG_SIZE-1:0] local_data_mem [(2**16)-1:0];
	logic [REG_SIZE-1:0] local_rf [4:0];
	logic [(REG_SIZE/2) - 1: 0] local_A [4:0][4:0];
	logic [(REG_SIZE/2) - 1: 0] local_B [4:0][4:0];
	logic [REG_SIZE - 1: 0] local_C [4:0][4:0];
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
		changeType change;
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
		function void setUp();
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
					this.change = NOTHING;
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
			step();
			checkPrev();
			//checkAll();
			checkChange();
		end
	end
	
	initial begin
		$readmemh("test_inst.txt", local_inst_mem);
		$readmemh("test_data.txt", local_data_mem);
		if(~rst_n) begin
			local_pc = 0;
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
		end
	end
	
	function void checkPrev();
		if(complete_inst.change == CHANGE_REG) begin
			
		end
		
		if(wb_inst.change == CHANGE_MEM) begin
		
		end
		
		if(me_inst.change == CHANGE_PC) begin
		
		end
		
		if(me_inst.change == CHANGE_A) begin
		
		end
		
		if(me_inst.change == CHANGE_B) begin
		
		end
		
		if(me_inst.change == CHANGE_C) begin
		
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
		
		if(ex_isnt.change == CHANGE_B) begin
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
			fe_inst.setUp(local_inst_mem[pc]);
		end
	endfunction
	
	function compare(logic [REG_SIZE-1:0] inst);
		case(inst[31:25])
				NOP: begin
				end
				ADD: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD ADD: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				SUB: begin 
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD SUB: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				XOR: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD XOR: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				OR: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD OR: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				AND: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD AND: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				SLL: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD SLL: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				SRL: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD SRL: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				SRA: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD SRA: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				SLT: begin 
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD SLT: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				MUL: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD MUL: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				ADDI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD ADDI: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				XORI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD XORI: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				ORI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD ORI: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				ANDI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD ANDI: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				SLLI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD SLLI: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				SRLI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD SRLI: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				SRAI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD SRAI: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				SLTI: begin 
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD SLTI: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				LUI: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD LUI: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				LW: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD LW: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
						$stop();
					end
				end
				SW: begin
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic [9:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = inst[9:0];
					local_data_mem[reg1Val + imm] = reg2Val;
					if(local_data_mem[reg1Val + imm] != dut.memory.d_cache.instr_mem[reg1Val + imm]) begin
						$display("BAD SW: EXPECTED: %d GOT: %d", dut.decode.rf.mem[reg1Val + imm], local_rf[reg1Val + imm]);
						$stop();
					end
				end
				BE: begin
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic [9:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = inst[9:0];
					next_pc = (reg1Val == reg2Val) ? (local_pc + imm):(next_pc);
					if(local_pc != dut.fetch.pc_reg) begin
						$display("BAD BE: EXPECTED: %d GOT: %d", local_pc, dut.fetch.pc_reg);
						$stop();
					end
				end
				BNE: begin
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic [9:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = inst[9:0];
					if(local_pc != dut.fetch.pc_reg) begin
						$display("BAD BNE: EXPECTED: %d GOT: %d", local_pc, dut.fetch.pc_reg);
						$stop();
					end
				end
				BLT: begin 
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic [9:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = inst[9:0];
					if(local_pc != dut.fetch.pc_reg) begin
						$display("BAD BLT: EXPECTED: %d GOT: %d", local_pc, dut.fetch.pc_reg);
						$stop();
					end
				end
				BGT: begin
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic [9:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = inst[9:0];
					if(local_pc != dut.fetch.pc_reg) begin
						$display("BAD BGT: EXPECTED: %d GOT: %d", local_pc, dut.fetch.pc_reg);
						$stop();
					end
				end
				J: begin
					logic imm [14:0];
					imm = inst[14:0];
					if(local_pc != dut.fetch.pc_reg) begin
						$display("BAD J: EXPECTED: %d GOT: %d", local_pc, dut.fetch.pc_reg);
						$stop();
					end
				end
				JR: begin 
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					if(local_pc != dut.fetch.pc_reg) begin
						$display("BAD JR: EXPECTED: %d GOT: %d", local_pc, dut.fetch.pc_reg);
						$stop();
					end
				end
				MATMUL: begin end
				LAM: begin 
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					logic [4:0] row;
					logic [4:0] col;
					reg1 = inst[24:20];
					reg1Val = local_rf[reg1];
					row = inst[17:13];
					col = inst[12:8];
					if(local_A [row][col] != dut.execute.tpuv1.iMEMA.iMATRIXAFIFO.tword[row][col]) begin
						$display("BAD LAM: EXPECTED: %d GOT: %d", local_A [row][col], dut.execute.tpuv1.iMEMA.iMATRIXAFIFO.tword[row][col]);
						$stop();
					end
				end
				LBM: begin
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					logic [4:0] row;
					logic [4:0] col;
					reg1 = inst[24:20];
					reg1Val = local_rf[reg1];
					row = inst[17:13];
					col = inst[12:8];
					if(local_B [row][col] != dut.execute.tpuv1.iMEMB.iMATRIXBFIFO.tword[row][col]) begin
						$display("BAD LBM: EXPECTED: %d GOT: %d", local_B [row][col], dut.execute.tpuv1.iMEMB.iMATRIXBFIFO.tword[row][col]);
						$stop();
					end
				end
				LACC: begin
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					logic [4:0] row;
					logic [4:0] col;
					reg1 = inst[24:20];
					reg1Val = local_rf[reg1];
					row = inst[17:13];
					col = inst[12:8];
					if(local_C [row][col] != dut.execute.tpuv1.iMEMC.iMATRIXCFIFO.tword[row][col]) begin
						$display("BAD LACC: EXPECTED: %d GOT: %d", local_A [row][col], dut.execute.tpuv1.iSYSARRY.macCOut[row][col]);
						$stop();
					end
				end
				RACC: begin
					logic [4:0] dst;
					dst = inst[24:20];
					if(local_rf[dst] != dut.decode.rf.mem[dst]) begin
						$display("BAD RACC: EXPECTED: %d GOT: %d", dut.decode.rf.mem[dst], local_rf[dst]);
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
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					local_rf [dst] = (local_rf[reg2] >= REG_SIZE) ? ({32{local_rf[reg1][REG_SIZE-1]}}) : 
																	({local_rf[reg2]{local_rf[reg1][REG_SIZE-1]}, local_rf[reg1][REG_SIZE - 1 - local_rf[reg2]:0]}});
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
					logic [14:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = inst[14:0];
					local_rf [dst] = reg1Val + imm;
				end
				XORI: begin
					logic [4:0] dst;
					logic [14:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = inst[14:0];
					local_rf [dst] = reg1Val ^ imm;
				end
				ORI: begin
					logic [4:0] dst;
					logic [14:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = inst[14:0];
					local_rf [dst] = reg1Val | imm;
				end
				ANDI: begin
					logic [4:0] dst;
					logic [14:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = inst[14:0];
					local_rf [dst] = reg1Val & imm;
				end
				SLLI: begin
					logic [4:0] dst;
					logic [14:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = inst[14:0];
					local_rf [dst] = reg1Val << imm;
				end
				SRLI: begin
					logic [4:0] dst;
					logic [14:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = inst[14:0];
					local_rf [dst] = reg1Val >> imm;
				end
				SRAI: begin
					logic [4:0] dst;
					logic [14:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = inst[14:0];
					local_rf [dst] = (imm >= REG_SIZE) ? ({32{local_rf[reg1][REG_SIZE-1]}}) : 
																	({imm{local_rf[reg1][REG_SIZE-1]}, local_rf[reg1][REG_SIZE - 1 - imm:0]}});
				
				end
				SLTI: begin 
					logic [4:0] dst;
					logic [14:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = inst[14:0];
					local_rf [dst] = reg1Val < imm;
				end
				LUI: begin
					logic [4:0] dst;
					logic [14:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = inst[14:0];
					local_rf [dst] = imm < 12;
				end
				LW: begin
					logic [4:0] dst;
					logic [14:0] imm;
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					dst = inst[24:20];
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					imm = inst[14:0];
					local_rf[dst] = local_data_mem[reg1Val + imm];
				end
				SW: begin
					logic [4:0] reg1;
					logic [9:0] imm;
					logic [4:0] reg2;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = inst[9:0];
					local_data_mem[reg1Val + imm] = reg2Val;
				end
				BE: begin
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic [9:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = inst[9:0];
					next_pc = (reg1Val == reg2Val) ? (local_pc + imm):(next_pc);
				end
				BNE: begin
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic [9:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = inst[9:0];
					next_pc = (reg1Val != reg2Val) ? (local_pc + imm):(next_pc);
				end
				BLT: begin 
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic [9:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = inst[9:0];
					next_pc = (reg1Val < reg2Val) ? (local_pc + imm):(next_pc);
				end
				BGT: begin
					logic [4:0] reg1;
					logic [4:0] reg2;
					logic [9:0] imm;
					logic [31:0] reg1Val;
					logic [31:0] reg2Val;
					reg1 = inst[19:15];
					reg2 = inst[14:10];
					reg1Val = local_rf[reg1];
					reg2Val = local_rf[reg2];
					imm = inst[9:0];
					next_pc = (reg1Val > reg2Val) ? (local_pc + imm):(next_pc);
				end
				J: begin
					logic [14:0] imm;
					imm = inst[14:0];
					next_pc = local_pc + imm;
				end
				JR: begin 
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					reg1 = inst[19:15];
					reg1Val = local_rf[reg1];
					next_pc = reg1Val;
				end
				MATMUL: begin end
				LAM: begin 
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					logic [4:0] row;
					logic [4:0] col;
					reg1 = inst[24:20];
					reg1Val = local_rf[reg1];
					row = inst[17:13];
					col = inst[12:8];
					local_A [row][col] = reg1Val;
				end
				LBM: begin
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					logic [4:0] row;
					logic [4:0] col;
					reg1 = inst[24:20];
					reg1Val = local_rf[reg1];
					row = inst[17:13];
					col = inst[12:8];
					local_B [row][col] = reg1Val;
				end
				LACC: begin
					logic [4:0] reg1;
					logic [31:0] reg1Val;
					logic [4:0] row;
					logic [4:0] col;
					reg1 = inst[24:20];
					reg1Val = local_rf[reg1];
					row = inst[17:13];
					col = inst[12:8];
					local_C [row][col] = reg1Val;
				end
				RACC: begin
					logic [4:0] reg1;
					logic [4:0] row;
					logic [4:0] col;
					reg1 = inst[24:20];
					row = inst[17:13];
					col = inst[12:8];
					local_rf[reg1] = local_A [row][col];
				end
			endcase
	
	endfunction
	
	
	
	/*
	Notes:
		PC starts at 0
	
	
	
	*/
		
endmodule
