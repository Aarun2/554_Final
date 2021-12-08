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
#ifndef __MIPS_H__
#define __MIPS_H__


/* A header for MacroCrew Intellectual Property specifc details
 * such as register name mappings
 * and a jump list for functional routines
 *
 * Instruction Formats:
 * NOP - 32 zeros
 * R - 7 opcode, 5 rs1, 5 rs2, 5 rd
 * I - 7 opcode, 5 rs1, 5 rd, 15 imm
 * L - 7 opcode, 5 rs1, 5 rd, 15 imm
 * S - 7 opcode, 5 rs1, 5 rs2
 * B - 7 opcode, 5 imm, 5 rs1, 5 rs2, 10 imm
 * J - 7 opcode, 5 rs1, 15 imm
 * C - 7 opcode
 * ML - 7 opcode, 5 rs1, 5 row, 5 col, ab 1
 * MR - 7 opcode, 5 rd, 5 row, 5 col,
 *
 *
 * wchen329 (the OG) craymond3 (the trainee)
 */
#include <cstring>
#include <cstddef>
#include <memory>
#include "ISA.h"
#include "mt_exception.h"
#include "primitives.h"
#include "priscas_global.h"
#include "syms_table.h"
#include "ustrop.h"

namespace priscas
{

	// Friendly Register Names -> Numerical Assignments
	enum REGISTERS
	{
		$zero = 0,
		$r1 = 1,
		$r2 = 2,
		$r3 = 3,
		$r4 = 4,
		$r5 = 5,
		$r6 = 6,
		$r7 = 7,
		$r8 = 8,
		$r9 = 9,
		$r10 = 10,
		$r11 = 11,
		$r12 = 12,
		$r13 = 13,
		$r14 = 14,
		$r15 = 15,
		$r16 = 16,
		$r17 = 17,
		$r18 = 18,
		$r19 = 19,
		$r20 = 20,
		$r21 = 21,
		$r22 = 22,
		$r23 = 23,
		$r24 = 24,
		$r25 = 25,
		$r26 = 26,
		$r27 = 27,
		$r28 = 28,
		$r29 = 29,
        $r30 = 30,
        $r31 = 31,
        $pc = 32,
		INVALID = -1
	};

	// instruction formats
	enum format
	{
		NO, R, I, L, S, B, J, C, ML, MR	
	};

	// Processor Opcodes
	enum opcode
	{
		NOP = 0,
        ADD = 1,
        SUB = 2,
        XOR = 3,
        OR = 4,
        AND = 5,
        SLL = 6,
        SRL = 7,
        SRA = 8,
        SLT = 9,
        MUL = 10,

        ADDI = 17,
        XORI = 19,
        ORI = 20,
        ANDI = 21,
        SLLI = 22,
        SRLI = 23,
        SRAI = 24,
        SLTI = 25,
        LUI = 27,

        LW = 32,
        SW = 33,

        BEQ = 60,
        BNE = 61,
        BLT = 63,
        BGT = 62,

        JMP = 126,
        JR = 127,

        MATMUL = 80,
        LAM = 81,
        LBM = 82,
        LACC = 83,
        RACC = 84,

		SYS_RES = -1	// system reserved for shell interpreter
	};

	int friendly_to_numerical(const char *);

	// From a register specifier, i.e. %so get an integer representation
	int get_reg_num(const char *);

	// From an immediate string, get an immediate value.
	int get_imm(const char *);

	namespace ALU
	{
		enum ALUOp
		{
            ADD = 0,
            SUB = 1,
            XOR = 2,
            OR = 3,
            AND = 4,
            SLL = 5,
            SRL = 6,
            SRA = 7,
            SLT = 8,
            MUL = 9,
            LUI = 10,

            BEQ = 12,
            BNE = 13,
            BGT = 14,
            BLT = 15
		};
	}

	// Format check functions
    /* Checks if an instruction is NOP formatted.
     */
    bool no_inst(opcode operation);

	/* Checks if an instruction is R formatted.
	 */
	bool r_inst(opcode operation);

    /* Checks if an instruction is I formatted.
	 */
	bool i_inst(opcode operation);

	/* Checks if an instruction is J formatted.
	 */
	bool j_inst(opcode operation);

    /* Checks if an instruction is B formatted
     */
    bool b_inst(opcode operation);

	/* Checks if an instruction performs
	 * memory access
	 */
	bool mem_inst(opcode operation);

	/* Checks if an instruction performs
	 * memory write
	 */
	bool mem_write_inst(opcode operation);

	/* Checks if an instruction performs
	 * memory read
	 */
	bool mem_read_inst(opcode operation);

	/* Checks if an instruction performs
	 * a register write
	 */
	bool reg_write_inst(opcode operation);

	/* Check if a special R-format
	 * shift instruction
	 */
	bool shift_inst(opcode operation);

	/* Check if a Jump or
	 * Branch Instruction
	 */
	bool jorb_inst(opcode operation);

    /* Checks if an instruction is C-Formatted
	 */
	bool c_inst(opcode operation);

    /* Checks if an instruction is ML-Formatted
	 */
	bool ml_inst(opcode operation);

    /* Checks if an instruction is MR-formatted.
	 */
	bool mr_inst(opcode operation);

	/* Macro Crew ISA
	 * encoding function asm -> binary
	 */
	BW_32 generic_mips32_encode(int rs1, int rs2, int rd, int imm, int row, int col, opcode op);

	/* For calculating a label offset in branches
	 */
	BW_32 offset_to_address_br(BW_32 current, BW_32 target);

	/* MIPS_32 ISA
	 *
	 */
	class MIPS_32 : public ISA
	{
		
		public:
			virtual std::string get_reg_name(int id);
			virtual int get_reg_id(std::string& fr) { return friendly_to_numerical(fr.c_str()); }
			virtual ISA_Attrib::endian get_endian() { return ISA_Attrib::CPU_LITTLE_ENDIAN; } // Note: Changed to Little Endian
			virtual mBW assemble(const Arg_Vec& args, const BW& baseAddress, syms_table& jump_syms) const;
		private:
			static const unsigned REG_COUNT = 33; // updated to 33
			static const unsigned PC_BIT_WIDTH = 32;
			static const unsigned UNIVERSAL_REG_BW = 32;
	};
}

#endif
