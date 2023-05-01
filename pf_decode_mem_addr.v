`timescale 1ns / 1ps

module pf_decode_mem_addr(
	input       valid_i,
	input [7:0] mod_i,
	input [7:0] instr_i,
	input [7:0] src_i,
	input [7:0] dst_i,
	
	output      mem_req_v_o, // make a memory request for the l2 or l3
	output      mem_l2_v_o,
	output      mem_l3_v_o
    );
	 
	wire srq_eq_dst;
	wire l1_v;
	wire l2_v;
	wire l3_v;
	wire store_v; // instruction is a store
	wire [1:0] mod_mem;
	wire       mem_gt0;
	wire [2:0] mod_cond;
	wire       cond_ge14;
	
	// check if request is l2 or l3
	// ---
	// src == dst (read) 	  L3
	// mod.cond >= 14 (write) L3
	// mod.mem == 0           L2
	// mod.mem != 0           L1
	// ---
	// mod bits 	description    range of values
	//    0-1 	    mod.mem flag         0-3
	//    2-3    	mod.shift flag       0-3
	//    4-7   	mod.cond flag   	 0-15
	assign mod_mem    = mod_i[1:0];
	assign mod_cond   = mod_i[7:4];
	assign cond_ge14  = mod_cond[3] & mod_cond[2] & mod_cond[1];// 111X
	assign mem_gt0    = |mod_mem; // or reduction 
	assign store_v    =  instr_i[7] & instr_i[6] & instr_i[5] & instr_i[4];// 1111_XXXX
	assign srq_eq_dst = src_i == dst_i;
	// L3
	assign l3_v = ~store_v ? srq_eq_dst : cond_ge14;
	// L2
	assign l2_v = ~mem_gt0;

	// output
	assign mem_l2_v_o = l2_v & ~l3_v;
	assign mem_l3_v_o = l3_v;
endmodule
