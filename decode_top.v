`timescale 1ns / 1ps

// deduce the scratchpad level the memory access read/write is targetting
module decode_scratchpad_level(
	input       src_eq_dst_i,
	input [1:0] mod_mem_i,
	input [3:1] mod_cond_i,
	input       store_v_i,// store instruction, writes to memory
	
	output [2:0] sp_lvl_o // scratchpad level { L3, L2, L1 }
	);
	wire cond_ge14;  // mem.cond >= 14
	wire mem_neq0;   // mod.mem != 0
	wire l3_v;       // special case override, not storing to L1/L2
	
	assign cond_ge14 = mod_cond_i[3] & mod_cond_i[2] & mod_cond_i[1];// 111X
	assign mem_neq0  = |mod_mem_i; // or reduction 
	
	assign l3_v = ( store_v_i & cond_ge14 ) // write
				| (~store_v_i & src_eq_dst_i);
	// output, level selection				
	assign sp_lvl_o[2] =  l3_v;             // L3
	assign sp_lvl_o[1] = ~l3_v &  mem_neq0; // L2
	assign sp_lvl_o[0] = ~l3_v & ~mem_neq0; // L1
endmodule

// verified 
module decode_op_type(
	input [7:0] op_i,
	
	output is_int_o,
	output is_float_o,
	output is_ctl_o
	);
	wire is_ctl;
	// decode by groupe : int , float or other
	// [ 0 -> 0111_1011 ] : 0XXX_XXXX & ~0111_11XX	
	assign is_int_o = ~op_i[7] & ~( &(op_i[6:3]) );
	// [ 0111_1100 -> 1101_0101 ] 
	assign is_float_o = ( op_i[7] | ( ~op_i[7] & &(op_i[6:3])) ) // lower bound
					  & ~is_ctl;
	// [ 1101_0110 -> 1111_1111 ]
	assign is_ctl = op_i[7] & op_i[6]
					& ( op_i[5] // over 224 111X_XXXX
					   | ( ~op_i[5] & op_i[4] 
						 & ( ( ~op_i[3] & op_i[2] & op_i[1] ) // 1101_011X
						   | (op_i[3]) // 1101_1XXX
			               )));
	assign is_ctl_o = is_ctl;
endmodule

// calculate value of mem address
// [mem] = src + imm32, for int,float
// [mem] = dst + imm32, for store
// src register selection 
module decode_src_register(
	input        is_float_i,
	input [2:0]  src_i,
	input        float_m_v_i,

	output [2:0] src_o,
	output       src_reg_o // 0 : R, 1: A
	);
	assign src_reg_o = is_float_i & ~float_m_v_i;
	assign src_o = { float_m_v_i & src_i[2] , src_i[1:0]};
endmodule

// dst register selection 
module decode_dst_register(
	input [2:0]  dst_i,
	input        is_float_i,
	input        fswap_r_i,
	input        fmul_r_i,
	input        fdiv_m_i,
	input        fsqrt_r_i,

	output [1:0] dst_reg_o, // 0 : R, 1: A, 2: E, 3: F
	output [2:0] dst_o
	);
	// dst can be R, F, E
	// is F or E when float else R
	// float E when mul, div, sqrt
	assign dst_reg_o[0] = is_float_i & (fmul_r_i | fdiv_m_i | fsqrt_r_i);
	assign dst_reg_o[1] = is_float_i;
	
	assign dst_o = {(is_float_i & fswap_r_i & dst_i[2]), dst_i[1:0]};
endmodule


// src register override, used in int reg instructions when src == dst
module decode_src_override(
	input  is_int_v_i,
	input  is_int_r_v_i,
	input  src_eq_dst_v_i,
	input  iadd_rs_i,
	input  imulh_r_i,
	input  ismulh_r_i,
	input  iswap_r_i,
	
	output isrc_override_v_o,    // src register override, cancel register read
	output isrc_override_o // 0: imm32 , 1 : same as dst value
	);
	assign isrc_override_v_o = is_int_v_i & src_eq_dst_v_i & is_int_r_v_i;
	assign isrc_override_o   = iadd_rs_i | imulh_r_i | ismulh_r_i | iswap_r_i;
endmodule 



// ---------- 
// DECODE TOP 
// ---------- 
// verified
module dec(
	input [63:0]   instr_i,

	// int
	output         iadd_v_o,
	output         iadd_sub_o,
	output         iadd_neg_o,
	output         iadd_rs_v_o,
	output         imul_v_o,
	output         imul_shift_o,
	output         imul_signed_o,
	output         imul_rcp_v_o,
	output         irol_v_o,
	output         irol_left_o,
	output         ixor_v_o,
	output         iswap_v_o,  
	// float
	output        fswap_v_o,
	output        fadd_v_o,
	output        fadd_sub_o,
	output        fscal_v_o,
	output        fmul_v_o,
	output        fdiv_v_o,
	output        fsqrt_v_o,
	// ctrl
	output        cfround_v_o,
	output        cbranch_v_o,
	output        istore_v_o, 
	
	// dst
	output        dst_v_o, // dst valid used, only false for select ctrl instructions
	output        dst_f_v_o,
	output [1:0]  dst_reg_o,
	output [2:0]  dst_o,
	
	// mem
	output        mem_v_o,
	output        mem_f_v_o,
	output [2:0]  sp_lvl_o,
	
	// src
	output        src_v_o,
	output        src_f_v_o,
	output        src_reg_o, // 0: R, 1: A
	output [2:0]  src_o,
	// src (int)
	output        isrc_override_v_o, // src register override, cancel register read
	output        isrc_override_o,   // 0: imm32 , 1: same as dst value
	
	// mod 
	output [1:0]  mod_shift_o,// used in int add rs
	output [2:0]  mod_cond_o, // used in branch
	output [31:0] imm32_o
	
	);
	wire is_int;
	wire is_float;
	wire is_ctrl;
	
	wire [31:0] imm32;
	wire [2:0]  src_pq;
	wire [2:0]  src;
	wire [2:0]  dst;
	wire [2:0]  dst_pq;
	wire [7:0]  op;
	
	wire [1:0] mod_mem;
	wire [1:0] mod_shift;
	wire [3:0] mod_cond;
	// decoded intruction
	// int
	wire iadd_rs;
	wire iadd_m;
	wire isub_r;
	wire isub_m;
	wire imul_m;
	wire imul_r;
	wire imulh_r;
	wire imulh_m;
	wire ismulh_r;
	wire ismulh_m;
	wire imul_rcp;
	wire ineg_r;
	wire ixor_r;
	wire ixor_m;
	wire irolr;
	wire iroll;
	wire iswap_r;
	// float
	wire fswap_r;
	wire fadd_r;
	wire fadd_m;
	wire fsub_r;
	wire fsub_m;
	wire fscal_r;
	wire fmul_r;
	wire fdiv_m;
	wire fsqrt_r;
	// control 
	wire cfround;
	wire cbranch;
	wire cstore;
	// valid, read src from mem or reg, or not at all , eg : ineg, no src needed
	wire isrc_mem_v;
	wire isrc_reg_v;
	wire fsrc_mem_v;
	wire fsrc_reg_v;
	
	wire src_eq_dst;
	wire is_ctrl_store_v;
	
	// register brank for src and dst
	// // 0 : R, 1: A, 2: E, 3: F
	wire [1:0] dst_reg; // 4 possibilities
	wire       src_reg; // 2 possibilities
	
	// memory address
	wire [2:0]  sp_lvl; // cache level
	
	// int src reg override 
	wire isrc_override_v; // validation
	wire isrc_override;	 // value 0 : imm32, 1 : dst
	
	// instruction regrouping according to selected pipe
	wire iadd_sub;
	wire imul_signed;
	wire imul_shift;
	wire fadd_sub;

	// unpack instruction
	assign imm32     = instr_i[63:32];
	assign mod_mem   = instr_i[25:24];
	assign mod_shift = instr_i[27:26];
	assign mod_cond  = instr_i[31:28];
	assign src_pq    = instr_i[23:16];
	assign dst_pq    = instr_i[15:8];
	assign op        = instr_i[7:0];
	
	// identify type of operations
	decode_op_type op_type(
		.op_i(op),
	
		.is_int_o(is_int),
		.is_float_o(is_float),
		.is_ctl_o(is_ctrl)
	);
	// decode int, float, control
	decode_int d_int(
		.op_i(op[6:0]), // for int, op is encoded on lower 6 bits

		.add_rs_o(iadd_rs),
		.add_m_o(iadd_m),
		.sub_r_o(isub_r),
		.sub_m_o(isub_m),
		.mul_m_o(imul_m),
		.mul_r_o(imul_r),
		.mulh_r_o(imulh_r),
		.mulh_m_o(imulh_m),
		.smulh_r_o(ismulh_r),
		.smulh_m_o(ismulh_m),
		.mul_rcp_o(imul_rcp),
		.neg_r_o(ineg_r),
		.xor_r_o(ixor_r),
		.xor_m_o(ixor_m),
		.rolr_o(irolr),
		.roll_o(iroll),
		.swap_r_o(iswap_r)
	);
	assign isrc_mem_v = iadd_m | isub_m | imul_m | imulh_m | ismulh_m | ixor_m;
	assign isrc_reg_v = ~isrc_mem_v & ~( ineg_r | imul_rcp);
	// check src == dst
	assign src_eq_dst = (src_pq == dst_pq) & is_int;
	
	
	// float
	decode_float d_float(
		.op_i(op),
		.swap_r_o(fswap_r),
		.add_r_o(fadd_r),
		.add_m_o(fadd_m),
		.sub_r_o(fsub_r),
		.sub_m_o(fsub_m),
		.scal_r_o(fscal_r),
		.mul_r_o(fmul_r),
		.div_m_o(fdiv_m),
		.sqrt_r_o(fsqrt_r)
	);
	assign fsrc_mem_v = fadd_m | fsub_m | fsub_m | fdiv_m;
	assign fsrc_reg_v = fadd_r | fsub_r | fmul_r; // swap, scal and sqrt don't use a src reg
	
	// control
	// 
	// precise op : 
	// unlike the int and float sub decode modules, the ctrl sub decode module is precise,
	// as in we do not need to check against the `is_ctrl` signal to know if the op is valid 
	decode_control d_ctrl(
		.op_i(op),
		.fround_o(cfround),
		.branch_o(cbranch),
		.store_o(cstore)
	);
	assign is_ctrl_store_v = cstore;
	
	
	// mem address
	// scratchpad level
	decode_scratchpad_level m_sp_lvl(
		.src_eq_dst_i(src_eq_dst),
		.mod_mem_i(mod_mem),
		.mod_cond_i(mod_cond[3:1]),
		.store_v_i(is_ctrl_store_v),// store instruction, writes to memory
		.sp_lvl_o(sp_lvl) // scratchpad level { L3, L2, L1 }
	);
	
	// src & dst address
	// src reg
	decode_src_register m_src_reg(
		.is_float_i(is_float),
		.src_i(src_pq),
		.float_m_v_i(fsrc_mem_v),
		.src_reg_o(src_reg), // 0 : R, 1: A
		.src_o(src)
	);
	decode_src_override m_src_override(
		.is_int_v_i(is_int),
		.is_int_r_v_i(isrc_reg_v),
		.src_eq_dst_v_i(src_eq_dst),
		.iadd_rs_i(iadd_rs),
		.imulh_r_i(imulh_r),
		.ismulh_r_i(ismulh_r),
		.iswap_r_i(iswap_r),
		
		.isrc_override_v_o(isrc_override_v),    // src register override, cancel register read
		.isrc_override_o(isrc_override) // 0: imm32 , 1 : same as dst value
	);
	
	// dst reg
	decode_dst_register m_dst_reg(
		.is_float_i(is_float),
		.dst_i(dst_pq),
		.fswap_r_i(fswap_r),
		.fmul_r_i(fmul_r),
		.fdiv_m_i(fdiv_m),
		.fsqrt_r_i(fsqrt_r),
		.dst_reg_o(dst_reg),
		.dst_o(dst)
	);

	// output 

	// instructions 
	//
	// int
	//
	// iadd
	assign iadd_sub      = isub_m | isub_r;
	assign iadd_v_o      = is_int & ( iadd_m | iadd_sub | ineg_r );
	assign iadd_sub_o    = iadd_sub;
	assign iadd_neg_o    = ineg_r;
	// iadd_rs
	assign iadd_rs_v_o   = is_int & iadd_rs;
	// imul
	assign imul_signed   = ismulh_r | ismulh_m;
	assign imul_shift    = imulh_r  | imulh_m | imul_signed;
	assign imul_v_o      = is_int & ( imul_r | imul_m | imul_shift );
	assign imul_shift_o  = imul_shift;
	assign imul_signed_o = imul_signed;
	// mul rcp 
	assign imul_rcp_v_o  = is_int & imul_rcp;
	// roll
	assign irol_v_o	     = is_int & ( iroll | irolr );
	assign irol_left_o   = iroll;
	// ixor
	assign ixor_v_o 	 = is_int & ( ixor_r | ixor_m );
	// swap 
	assign iswap_v_o 	 = is_int & iswap_r;
	
	// float
	//
	// fswap
	assign fswap_v_o  = is_float & fswap_r;
	// fadd
	assign fadd_sub   = fsub_r | fsub_m;
	assign fadd_v_o   = is_float & ( fadd_r | fadd_m | fadd_sub );
	assign fadd_sub_o = fadd_sub;
	// fscal
	assign fscal_v_o  = is_float & fscal_r;
	// fmul
	assign fmul_v_o   = is_float & fmul_r;
	// fdiv
	assign fdiv_v_o   = is_float & fdiv_m;
	// fsqrt
	assign fsqrt_v_o  = is_float & fsqrt_r;
	
	// ctrl
	assign cfround_v_o  = cfround;
	assign cbranch_v_o  = cbranch;
	assign istore_v_o   = cstore;
	
	// dst
	// ctrl ops are precise op, no need to mask with `is_ctrl`
	// this is not true for int and float ops
	assign dst_v_o   = ~( cfround | cstore );
	assign dst_f_v_o = is_float;
	assign dst_reg_o = dst_reg;
	assign dst_o     = dst;

	// mem
	assign mem_v_o   = ( is_int & isrc_mem_v  ) // int
				     | cbranch;                 // ctrl TODO : can't recall why I did this, contradicts the tb assertion 
	assign mem_f_v_o = is_float & fsrc_mem_v; // float					
	assign sp_lvl_o  = sp_lvl; // scratchpad lvl
	
	// src
	assign src_v_o   = ( is_int & isrc_reg_v & ~isrc_override_v ) // int
					 | ( cfround | cstore ); 			          // ctr
	assign src_f_v_o = is_float & fsrc_reg_v; // float
	assign src_reg_o = src_reg;
	assign src_o     = src;
	// src (int)
	assign isrc_override_v_o = isrc_override_v;
	assign isrc_override_o   = isrc_override;
	
	// mod 
	assign mod_shift_o = mod_shift;
	assign mod_cond_o  = mod_cond;
	assign imm32_o     = imm32;
	
endmodule
