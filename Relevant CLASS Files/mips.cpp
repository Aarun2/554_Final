//////////////////////////////////////////////////////////////////////////////
//
//    CLASS - Cloud Loader and ASsembler System
//    Copyright (C) 2021 Winor Chen
//
//    This program is free software; you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation; either version 2 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License along
//    with this program; if not, write to the Free Software Foundation, Inc.,
//    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//
//////////////////////////////////////////////////////////////////////////////
#include "mips.h"

namespace priscas
{
	int friendly_to_numerical(const char * fr_name)
	{
		int len = strlen(fr_name);
		if(len < 2) return INVALID;

		REGISTERS reg_val
			=
			// Can optimize based off of 
			fr_name[1] == 'r' ?
                !strcmp("$r1", fr_name) ? $r1 :
                !strcmp("$r2", fr_name) ? $r2 :
                !strcmp("$r3", fr_name) ? $r3 :
                !strcmp("$r4", fr_name) ? $r4 :
                !strcmp("$r5", fr_name) ? $r5 :
                !strcmp("$r6", fr_name) ? $r6 :
                !strcmp("$r7", fr_name) ? $r7 :
                !strcmp("$r8", fr_name) ? $r8 :
                !strcmp("$r9", fr_name) ? $r9 :
                !strcmp("$r10", fr_name) ? $r10 :
                !strcmp("$r11", fr_name) ? $r11 :
                !strcmp("$r12", fr_name) ? $r12 :
                !strcmp("$r13", fr_name) ? $r13 :
                !strcmp("$r14", fr_name) ? $r14 :
                !strcmp("$r15", fr_name) ? $r15 :
                !strcmp("$r16", fr_name) ? $r16 :
                !strcmp("$r17", fr_name) ? $r17 :
                !strcmp("$r18", fr_name) ? $r18 :
                !strcmp("$r19", fr_name) ? $r19 :
                !strcmp("$r20", fr_name) ? $r20 :
                !strcmp("$r21", fr_name) ? $r21 :
                !strcmp("$r22", fr_name) ? $r22 :
                !strcmp("$r23", fr_name) ? $r23 :
                !strcmp("$r24", fr_name) ? $r24 :
                !strcmp("$r25", fr_name) ? $r25 :
                !strcmp("$r26", fr_name) ? $r26 :
                !strcmp("$r27", fr_name) ? $r27 :
                !strcmp("$r28", fr_name) ? $r28 :
                !strcmp("$r29", fr_name) ? $r29 :
                !strcmp("$r30", fr_name) ? $r30 :
                !strcmp("$r31", fr_name) ? $r31 : INVALID
            :
			fr_name[1] == 'p' ?
				!strcmp("$pc", fr_name) ? $pc : INVALID
			:
			fr_name[1] == 'z' ?
				!strcmp("$zero", fr_name) ? $zero : INVALID
			: INVALID;

		return reg_val;
	}

	std::string MIPS_32::get_reg_name(int id)
	{
		std::string name =
			id == 0 ? "$zero" :
			id == 1 ? "$r1" :
			id == 2 ? "$r2" :
			id == 3 ? "$r3" :
			id == 4 ? "$r4" :
			id == 5 ? "$r5" :
			id == 6 ? "$r6" :
			id == 7 ? "$r7" :
			id == 8 ? "$r8" :
			id == 9 ? "$r9" :
			id == 10 ? "$r10" :
			id == 11 ? "$r11" :
			id == 12 ? "$r12" :
			id == 13 ? "$r13" :
			id == 14 ? "$r14" :
			id == 15 ? "$r15" :
			id == 16 ? "$r16" :
			id == 17 ? "$r17" :
			id == 18 ? "$r18" :
			id == 19 ? "$r19" :
			id == 20 ? "$r20" :
			id == 21 ? "$r21" :
			id == 22 ? "$r22" :
			id == 23 ? "$r23" :
			id == 24 ? "$r24" :
			id == 25 ? "$r25" :
			id == 26 ? "$r26" :
			id == 27 ? "$r27" :
			id == 28 ? "$r28" :
			id == 29 ? "$r29" :
            id == 30 ? "$r30" :
            id == 31 ? "$r31" :
			id == 32 ? "$pc" : "";
		
		if(name == "")
		{
			throw reg_oob_exception();
		}
		
		return name;
	}

    bool no_inst(opcode operation)
    {
        return
            operation == NOP ? true : false;
    }

	bool r_inst(opcode operation)
	{
		return
			operation == ADD ? true :
            operation == SUB ? true :
            operation == XOR ? true :
            operation == OR ? true :
            operation == SLL ? true :
            operation == SRL ? true :
            operation == SRA ? true :
            operation == SLT ? true :
            operation == MUL ? true :
			false ;
	}

	bool i_inst(opcode operation)
	{
		return
			operation == ADDI ? true :
            operation == XORI ? true :
            operation == ORI ? true :
            operation == ANDI ? true :
            operation == SLLI ? true :
            operation == SRLI ? true :
            operation == SRAI ? true :
            operation == SLTI ? true :
			operation == LUI ? true : 
            false ;
	}

	bool j_inst(opcode operation)
	{
		return
			operation == JMP ? true :
			operation == JR ? true: false;
	}

    bool b_inst(opcode operation)
    {
        return
            operation == BEQ ? true :
            operation == BNE ? true :
            operation == BLT ? true :
            operation == BGT ? true : false;
    }

	bool mem_inst(opcode operation)
	{
		return
			(mem_write_inst(operation) || mem_read_inst(operation))?
			true : false;
	}

	bool mem_write_inst(opcode operation)
	{
		return
			(operation == SW)?
			true : false;
	}

	bool mem_read_inst(opcode operation)
	{
		return
			(operation == LW)?
			true : false;
	}

	bool reg_write_inst(opcode operation)
	{
		return
			(mem_read_inst(operation)) || 
            (operation == ADD) ||
            (operation == SUB) || 
            (operation == XOR) || 
            (operation == OR) || 
            (operation == AND) || 
            (operation == SLL) ||  
            (operation == SRL) || 
            (operation == SRA) || 
            (operation == SLT) || 
            (operation == MUL) ||
            (operation == ADDI) ||
            (operation == XORI) ||
            (operation == ORI) ||
            (operation == ANDI) ||
            (operation == SLLI) ||
            (operation == SRLI) ||
            (operation == SRAI) ||
            (operation == SLTI) ||
            (operation == LUI) ||
            (operation == LW) ||
            (operation == RACC);
	}

	bool shift_inst(opcode operation)
	{
		return
			operation == SLL ? true :
			operation == SRL ? true :
            operation == SRA ? true :
            operation == SLLI ? true :
            operation == SRLI ? true :
            operation == SRAI ? true :
			false;
	}

	bool jorb_inst(opcode operation)
	{
		// First check jumps
		bool is_jump = j_inst(operation);

		bool is_branch =
			operation == BEQ ? true :
			operation == BNE ? true :
			operation == BLT ? true :
			operation == BGT ? true : false;

		return is_jump || is_branch;
	}

    bool c_inst(opcode operation)
	{
		return
			operation == MATMUL ? true : false;
	}

    bool ml_inst(opcode operation)
	{
		return
			operation == LAM ? true :
			operation == LBM ? true: 
            operation == LACC ? true : false;
	}

    bool mr_inst(opcode operation)
	{
		return
			operation == RACC ? true : false;
	}

    // The encode instruction function
	BW_32 generic_mips32_encode(int rs1, int rs2, int rd, int imm, int row, int col, opcode op)
	{
		BW_32 w = 0;

        //not needed but showing nop for sanity
        if(no_inst(op))
        {
            w = 0;
        }

        // general formula w = (w.AsUInt32() | ((type & (1 << type's num of bits) - 1)) << total bits used so far))
		if(r_inst(op))
		{
			w = (w.AsUInt32() | (0 & ((1 << 10) - 1) )); // [9:0] are dont cares, write as 0
			w = (w.AsUInt32() | ((rs2 & ((1 << 5) - 1) ) << 10 ));
			w = (w.AsUInt32() | ((rs1 & ((1 << 5) - 1) ) << 15 ));
			w = (w.AsUInt32() | ((rd & ((1 << 5) - 1) ) << 20 ));
			w = (w.AsUInt32() | ((op & ((1 << 7) - 1) ) << 25 ));
		}

		if(i_inst(op))
		{
			w = (w.AsUInt32() | (imm & ((1 << 15) - 1)));
			w = (w.AsUInt32() | ((rs1 & ((1 << 5) - 1) ) << 15 ));
			w = (w.AsUInt32() | ((rd & ((1 << 5) - 1) ) << 20 ));
			w = (w.AsUInt32() | ((op & ((1 << 7) - 1) ) << 25 ));
		}

        if(mem_inst(op))
		{
            if (op == SW)
            {
                // formula for immHigh (((1 << k) - 1) & (number >> (p - 1))) where k is num of high bits, p is position
                int immLow = imm & ((1 << 10) - 1);
                int immHigh = ((1 << 5) - 1) & (imm >> (9 - 1));

                w = (w.AsUInt32() | (immLow & ((1 << 10) - 1))); //imm[9:0]
			    w = (w.AsUInt32() | ((rs2 & ((1 << 5) - 1) ) << 10 )); 
			    w = (w.AsUInt32() | ((rs1 & ((1 << 5) - 1) ) << 15 )); 
			    w = (w.AsUInt32() | ((immHigh & ((1 << 5) - 1) ) << 20 )); // imm[24:20]
                w = (w.AsUInt32() | ((op & ((1 << 7) - 1) ) << 25 ));
            }
            // LW
            else 
            {
                w = (w.AsUInt32() | (imm & ((1 << 15) - 1)));
			    w = (w.AsUInt32() | ((rs1 & ((1 << 5) - 1) ) << 15 ));
			    w = (w.AsUInt32() | ((rd & ((1 << 5) - 1) ) << 20 ));
			    w = (w.AsUInt32() | ((op & ((1 << 7) - 1) ) << 25 ));
            }	
		}

        if(b_inst(op))
        {
            // Same as SW
            // formula for immHigh (((1 << k) - 1) & (number >> (p - 1))) where k is num of high bits, p is position
            int immLow = imm & ((1 << 10) - 1);
            int immHigh = ((1 << 5) - 1) & (imm >> (9 - 1));

            w = (w.AsUInt32() | (immLow & ((1 << 10) - 1))); //imm[9:0]
            w = (w.AsUInt32() | ((rs2 & ((1 << 5) - 1) ) << 10 )); 
            w = (w.AsUInt32() | ((rs1 & ((1 << 5) - 1) ) << 15 )); 
            w = (w.AsUInt32() | ((immHigh & ((1 << 5) - 1) ) << 20 )); // imm[24:20]
            w = (w.AsUInt32() | ((op & ((1 << 7) - 1) ) << 25 ));
        }

		if(j_inst(op))
		{
            w = (w.AsUInt32() | (imm & ((1 << 15) - 1)));
            w = (w.AsUInt32() | ((rs1 & ((1 << 5) - 1) ) << 15));
             w = (w.AsUInt32() | ((0 & ((1 << 5) - 1) ) << 20 )); // [[24:20] dont cares 
			w = (w.AsUInt32() | ((op & ((1 << 7) - 1) ) << 25 ));
		}

        if(c_inst(op))
        {
            w = (w.AsUInt32() | (0 & ((1 << 25) - 1))); // [24:0] dont care
            w = (w.AsUInt32() | ((op & ((1 << 7) - 1) ) << 25 ));
        }

        if(ml_inst(op))
		{
			w = (w.AsUInt32() | (0 & ((1 << 5) - 1) )); // [4:0] dont care
			w = (w.AsUInt32() | ((col & ((1 << 5) - 1) ) << 5 ));
			w = (w.AsUInt32() | ((row & ((1 << 5) - 1) ) << 10 ));
            w = (w.AsUInt32() | ((rs1 & ((1 << 5) - 1) ) << 15 ));
            w = (w.AsUInt32() | ((0 & ((1 << 5) - 1) ) << 20 )); // [24:20] dont care
			w = (w.AsUInt32() | ((op & ((1 << 7) - 1) ) << 25 ));
		}

        if(mr_inst(op))
        {
            w = (w.AsUInt32() | (0 & ((1 << 5) - 1) )); // [4:0] dont care
			w = (w.AsUInt32() | ((col & ((1 << 5) - 1) ) << 5 ));
			w = (w.AsUInt32() | ((row & ((1 << 5) - 1) ) << 10 ));
            w = (w.AsUInt32() | ((0 & ((1 << 5) - 1) ) << 15 )); // [19:15] dont care
            w = (w.AsUInt32() | ((rd & ((1 << 5) - 1) ) << 20 ));
			w = (w.AsUInt32() | ((op & ((1 << 7) - 1) ) << 25 ));
        }

		return w;
	}

	BW_32 offset_to_address_br(BW_32 current, BW_32 target)
	{
		BW_32 ret = target.AsUInt32() - current.AsUInt32();
		//ret = ret.AsUInt32() - 4;
		//ret = (ret.AsUInt32() >> 2);
		return ret;
	}

	// Main interpretation routine
	mBW MIPS_32::assemble(const Arg_Vec& args, const BW& baseAddress, syms_table& jump_syms) const
	{
		if(args.size() < 1)
			return std::shared_ptr<BW>(new BW_32());

		priscas::opcode current_op = priscas::SYS_RES;

		int rs1 = 0;
		int rs2 = 0;
		int rd = 0;
		int imm = 0;
        int row = 0;
        int col = 0;

		// Mnemonic resolution
		
        //NOP
		if("nop" == args[0]) { current_op = priscas::NOP; }

        // R format
        else if("add" ==  args[0]) { current_op = priscas::ADD; }
        else if("sub" == args[0]) { current_op = priscas::SUB; }
        else if("or" ==  args[0]) { current_op = priscas::OR; }
        else if("xor" ==  args[0]) { current_op = priscas::XOR; }
        else if("and" == args[0]) { current_op = priscas::AND; }
        else if("sll" == args[0]) { current_op = priscas::SLL; }
		else if("srl" == args[0]) { current_op = priscas::SRL; }
        else if("sra" == args[0]) { current_op = priscas::SRA; }
		else if("slt" == args[0]) { current_op = priscas::SLT; }
        else if("mul" == args[0]) { current_op = priscas::MUL; }		

        // I format
		else if("addi" == args[0]) { current_op = priscas::ADDI; }
        else if("xori" ==  args[0]) { current_op = priscas::XORI; }
        else if("ori" == args[0]) { current_op = priscas::ORI; }
        else if("andi" == args[0]) { current_op = priscas::ANDI; }
        else if("slli" == args[0]) { current_op = priscas::SLLI; }
		else if("srli" == args[0]) { current_op = priscas::SRLI; }
        else if("srai" == args[0]) { current_op = priscas::SRAI; }
		else if("slti" == args[0]) { current_op = priscas::SLTI; }
        else if("lui" == args[0]) { current_op = priscas::LUI; }

        // L format
        else if("lw" == args[0]) { current_op = priscas::LW; }

        //S format
		else if("sw" == args[0]) { current_op = priscas::SW; }
		
		// B format
        else if("beq" == args[0]) { current_op = priscas::BEQ; }
        else if("bne" == args[0]) { current_op = priscas::BNE; }
        else if("blt" == args[0]) { current_op = priscas::BLT; }
        else if("bgt" == args[0]) { current_op = priscas::BGT; }

        // J format
        else if("jmp" == args[0]) { current_op = priscas::JMP; }
        else if("jr" == args[0]) { current_op = priscas::JR; }

        // C format
        else if("matmul" == args[0]) { current_op = priscas::MATMUL; }

        // ML format
        else if("lam" == args[0]) { current_op = priscas::LAM; }
        else if("lbm" == args[0]) { current_op = priscas::LBM; }
        else if("lacc" == args[0]) { current_op = priscas::LACC; }

        // MR format
		else if("racc" == args[0]) { current_op = priscas::RACC; }

		else
		{
			throw mt_bad_mnemonic();
		}

		// Check for insufficient arguments
		if(args.size() >= 1)
		{
			if	(
					(r_inst(current_op) && args.size() != 4) ||
					(i_inst(current_op) && args.size() != 4 && current_op != LUI) ||
					(i_inst(current_op) && args.size() != 3 && current_op == LUI) ||
                    (mem_inst(current_op) && args.size() != 4) ||
                    (b_inst(current_op) && args.size() != 4) ||
					(j_inst(current_op) && args.size() != 2) ||
                    (c_inst(current_op) && args.size() != 1) ||
                    (ml_inst(current_op) && args.size() != 4) ||
                    (mr_inst(current_op) && args.size() != 4)				
				)
			{
				throw priscas::mt_asm_bad_arg_count();
			}

			////////////////////////// FIRST ARGUMENT PARSING ////////////////////////////// 
			if(r_inst(current_op))
			{		
                if((rd = priscas::friendly_to_numerical(args[1].c_str())) <= priscas::INVALID)
                    rd = priscas::get_reg_num(args[1].c_str());		
			}

			else if(i_inst(current_op))
			{
				// later, check for branches
				if((rd = priscas::friendly_to_numerical(args[1].c_str())) <= priscas::INVALID)
				    rd = priscas::get_reg_num(args[1].c_str());
			}

            else if(mem_inst(current_op))
            {
                if (current_op == LW)
                {
                    if((rd = priscas::friendly_to_numerical(args[1].c_str())) <= priscas::INVALID)
				        rd = priscas::get_reg_num(args[1].c_str());
                }
                // SW
                else 
                {
                    if((rs1 = priscas::friendly_to_numerical(args[1].c_str())) <= priscas::INVALID)
				        rs1 = priscas::get_reg_num(args[1].c_str());
                }   
            }

            else if(b_inst(current_op))
            {
                 if((rs1 = priscas::friendly_to_numerical(args[1].c_str())) <= priscas::INVALID)
                        rs1 = priscas::get_reg_num(args[1].c_str());
            }

			else if(j_inst(current_op))
			{
                // jump register (jr) so parse rs1
                if(current_op == priscas::JR)
                {
                    if((rs1 = priscas::friendly_to_numerical(args[1].c_str())) <= priscas::INVALID)
                        rs1 = priscas::get_reg_num(args[1].c_str());
                }

                // regular jump (jmp) so parse the imm
                else 
                {
                    if(jump_syms.has(args[1]))
				    {
					    priscas::BW_32 addr = baseAddress.AsUInt32();
					    priscas::BW_32 label_PC = static_cast<uint32_t>(jump_syms.lookup_from_sym(std::string(args[1].c_str())));
					    imm = priscas::offset_to_address_br(addr, label_PC).AsUInt32();
				    }
                    else
                    {
                        imm = priscas::get_imm(args[1].c_str());
                    }
                }
			}

            // No parsing needed for matmul
            else if(c_inst(current_op)){}

            else if(ml_inst(current_op))
            {
                if((rs1 = priscas::friendly_to_numerical(args[1].c_str())) <= priscas::INVALID)
                    rs1 = priscas::get_reg_num(args[1].c_str());
            }

            else if(mr_inst(current_op))
            {
                if((rd = priscas::friendly_to_numerical(args[1].c_str())) <= priscas::INVALID)
                    rd = priscas::get_reg_num(args[1].c_str());
            }
	
			else
			{
				priscas::mt_bad_mnemonic();
			} 
		}

		////////////////////////// SECOND ARGUMENT PARSING ////////////////////////////// 
		if(args.size() > 2)
		{
			if(r_inst(current_op))
			{
                if((rs1 = priscas::friendly_to_numerical(args[2].c_str())) <= priscas::INVALID)
                    rs1 = priscas::get_reg_num(args[2].c_str());	
			}
						
			else if(i_inst(current_op))
			{
                if(current_op != LUI)
                {
                    if((rs1 = priscas::friendly_to_numerical(args[2].c_str())) <= priscas::INVALID)
                        rs1 = priscas::get_reg_num(args[2].c_str());
                }
                // LUI
                else 
                {
                    imm = priscas::get_imm(args[2].c_str());                   
                }
			}

            else if(mem_inst(current_op))
            {
                if(current_op == LW)
                {
                    if((rs1 = priscas::friendly_to_numerical(args[2].c_str())) <= priscas::INVALID)
                        rs1 = priscas::get_reg_num(args[2].c_str());
                }
                // SW
                else
                {
                    if((rs2 = priscas::friendly_to_numerical(args[2].c_str())) <= priscas::INVALID)
                        rs2 = priscas::get_reg_num(args[2].c_str());
                }
            }

            else if(b_inst(current_op))
            {
                if((rs2 = priscas::friendly_to_numerical(args[2].c_str())) <= priscas::INVALID)
                    rs2 = priscas::get_reg_num(args[2].c_str());
            }

			else if(j_inst(current_op)){} // j types only have 1 arg

            else if(c_inst(current_op)){} // do nothing for matmul

            else if(ml_inst(current_op))
            {
                row = priscas::get_imm(args[2].c_str());
            }

            else if(mr_inst(current_op))
            {
                priscas::get_imm(args[2].c_str());
            }    
            
		}

		if(args.size() > 3)
		{
			////////////////////////// THIRD ARGUMENT PARSING ////////////////////////////// 
			if(r_inst(current_op))
			{
                if((rs2 = priscas::friendly_to_numerical(args[3].c_str())) <= priscas::INVALID)
                    rs2 = priscas::get_reg_num(args[3].c_str());	
			}
						
			else if(i_inst(current_op))
			{
                if (current_op != LUI)
                {
                    imm = priscas::get_imm(args[3].c_str());
                }
			}

            else if(mem_inst(current_op))
            {
                // Same for LW and SW
                imm = priscas::get_imm(args[3].c_str());
            }

            else if(b_inst(current_op))
            {
                if(jump_syms.has(args[3]))
                {
                    priscas::BW_32 addr = baseAddress.AsUInt32();
					priscas::BW_32 label_PC = static_cast<uint32_t>(jump_syms.lookup_from_sym(std::string(args[3].c_str())));
				    imm = priscas::offset_to_address_br(addr, label_PC).AsUInt32();
                }
                else
                {
                    imm = priscas::get_imm(args[3].c_str());
                }
            }

			else if(j_inst(current_op)){}

            else if(c_inst(current_op)){}

            else if(ml_inst(current_op))
            {
                col = priscas::get_imm(args[3].c_str());
            }

            else if(mr_inst(current_op))
            {
                col = priscas::get_imm(args[3].c_str());
            }
		}

		// Pass the values to the processor's encoding function
		BW_32 inst = generic_mips32_encode(rs1, rs2, rd, imm, row, col, current_op);

		return std::shared_ptr<BW>(new BW_32(inst));
	}

	// Returns register number corresponding with argument if any
	// Returns -1 if invalid or out of range
	int get_reg_num(const char * reg_str)
	{
		std::vector<char> numbers;
		int len = strlen(reg_str);
		if(len <= 1) throw priscas::mt_bad_imm();
		if(reg_str[0] != '$') throw priscas::mt_parse_unexpected("$", reg_str);
		for(int i = 1; i < len; i++)
		{
			if(reg_str[i] >= '0' && reg_str[i] <= '9')
			{
				numbers.push_back(reg_str[i]);
			}

			else throw priscas::mt_bad_reg_format();
		}

		int num = -1;

		if(numbers.empty()) throw priscas::mt_bad_reg_format();
		else
		{
			char * num_str = new char[numbers.size()];

			int k = 0;
			for(std::vector<char>::iterator itr = numbers.begin(); itr < numbers.end(); itr++)
			{
				num_str[k] = *itr;
				k++;
			}
			num = atoi(num_str);
			delete[] num_str;
		}

		return num;
	}

	// Returns immediate value if valid
	int get_imm(const char * str)
	{
		return StrOp::StrToUInt32(UPString(str));
	}
}
