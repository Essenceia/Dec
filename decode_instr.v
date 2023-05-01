`timescale 1ns / 1ps
//The mod flag is encoded as:
//
//Table 5.1.3: mod flag encoding
//mod bits 	description 	range of values
//	0-1 		mod.mem flag 		0-3
//	2-3 		mod.shift flag   	0-3
//	4-7 		mod.cond flag 		0-15
module decode_instr(
	input [63:0] instr_i,
	// op
	output [7:0]  op_o,
	// dst
	output [7:0]  dst_o,
	// src
	output [7:0]  src_o,
	// mod flag
	output [1:0]  mod_mem_o,
	output [1:0]  mod_shift_o,
	output [3:0]  mod_cond_o,
	// imm32
	output [31:0] imm32_o
	);
	
	assign op_o  = instr_i[7:0];
	assign dst_o = instr_i[15:8];
	assign src_o = instr_i[23:16];
	
	// mod
	assign imm32_o = instr_i[63:32];

endmodule
