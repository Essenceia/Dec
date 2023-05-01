`timescale 1ns / 1ps

module decode_float_lt_128(
	input [6:2] op_i,
	// swap
	output      swap_r_o,
	// add
	output      add_r_o
	);
	wire lsb_ge_120;
	assign lsb_ge_120 = op_i[6] & op_i[5] & op_i[4] & op_i[3];
	
	assign swap_r_o = lsb_ge_120 & ~op_i[2];// 1_10XX
	assign add_r_o  = lsb_ge_120 &  op_i[2];// 1_11XX
endmodule

module decode_float_lsb_ge_128(
	input [6:0] op_i,
	// add
	output      add_r_o,
	output      add_m_o,
	// sub     
	output      sub_r_o,
	output      sub_m_o,
	// scal
	output      scal_r_o,
	// mul     
	output      mul_r_o,
	// div
	output      div_m_o,
	// squaer root
	output      sqrt_r_o
	);
	wire zeros_2_1;
	wire zeros_2_1_0;
	wire zeros_3_2_1;
	wire zeros_6_5_4;
	wire zeros_6_5;
	wire lsb_ge_6;
	wire lsb_ge_8;
	wire lsb_ge_12;
	wire lsb_ge_32;
	wire ge_96_lite;
	wire ge_96;
	wire ge_32;
	assign zeros_6     = ~op_i[6];             // X0XX_XXXX
	assign zeros_6_5   = ~op_i[6] & ~op_i[5];  // X00X_XXXX
	assign zeros_6_5_4 = zeros_6_5 & ~op_i[4]; // X000_XXXX
	assign zeros_2_1   = ~op_i[2]  & ~op_i[1]; // X00X
	assign zeros_2_1_0 = zeros_2_1 & ~op_i[0]; // X000
	assign zeros_3_2_1 = zeros_2_1 & ~op_i[3]; // 000X
	assign lsb_ge_6  = op_i[2] & op_i[1];      // X11X
	assign lsb_ge_8  = op_i[3] & ~op_i[2];     // 10XX
	assign lsb_ge_12 = op_i[3] & op_i[2];      // 11XX
	assign lsb_ge_32 = op_i[5] & ~op_i[4];     // XX10_XXXX
	assign ge_32     = zeros_6 & lsb_ge_32;    // X010_XXXX
	assign ge_96_lite = op_i[6] & ~op_i[5];    // 10X_XXXX
	assign ge_96      = ge_96_lite & ~op_i[4]; // 100_XXXX
	// add
	assign add_r_o = zeros_6_5_4 & ( ~op_i[3] | lsb_ge_8 ) ;// 000_XXXX & ( 0XXX | 10XX  ) 
	assign add_m_o = zeros_6_5 & ((~op_i[4] & lsb_ge_12) | (op_i[4] & ~op_i[3] & zeros_2_1_0));
	// sub
	assign sub_r_o = zeros_6 
				   &  ( ( ~op_i[5] & op_i[4] & ~(zeros_3_2_1 & ~op_i[0]))
					  | ( lsb_ge_32 & zeros_3_2_1 & ~op_i[0]) );// 10XX_XXXX & ( ( 01_XXXX & ~0001) | 10_0000 )
	assign sub_m_o = ge_32 & ~op_i[3] & ~zeros_2_1_0 & ~lsb_ge_6; // 010_0XXX & ~000 & ~11X
 	// rscal
	assign scal_r_o = ge_32 & ( ( ~op_i[3] & lsb_ge_6 ) | lsb_ge_8); // 010_XXXX &  ( 011X | 10XX )
	// mul
	assign mul_r_o = ( ge_32 & lsb_ge_12 ) 
					| ( ~op_i[6] & op_i[5] & op_i[4] )
					| ( ge_96 & ~lsb_ge_12);  // 010_11XX | 011_XXXX |( 100_XXXX & ~11XX )
	// div
	assign div_m_o = ge_96 & lsb_ge_12;// 100_11XX
	// sqrt
	assign sqrt_r_o = ge_96_lite & op_i[4] & ( ~op_i[3] & ~lsb_ge_6);// 101_XXXX & ( 0XXX & ~X11X )
endmodule

module decode_float(
	input [7:0] op_i,

	output      swap_r_o,
	// add     
	output      add_r_o,
	output      add_m_o,
	// sub     
	output      sub_r_o,
	output      sub_m_o,
	// scal
	output      scal_r_o,
	// mul     
	output      mul_r_o,
	// div     
	output      div_m_o,
	// squaer root
	output      sqrt_r_o
   );
	wire       op_ge128_v;
	wire [6:2] op_lt128; 
	wire [6:0] op_ge128;
	wire add_r_lt128;
	wire add_r_ge128;
	
	assign op_ge128_v = op_i[7];
	assign op_lt128 = {5{~op_ge128_v}} & op_i[6:2]; // if op >= 128 clamp to 0
	assign op_ge128 = op_i[6:0] | {7{~op_ge128_v}}; // if op < 128 clamp to 111_1111

	decode_float_lt_128 decode_float_lt128(
		.op_i(op_lt128),
		.swap_r_o(swap_r_o),
		.add_r_o(add_r_lt128)
	);
	
	decode_float_lsb_ge_128 decode_float_ge128(
		.op_i(op_ge128),
		.add_r_o(add_r_ge128),
		.add_m_o(add_m_o),
		.sub_r_o(sub_r_o),
	   .sub_m_o(sub_m_o),
	   .scal_r_o(scal_r_o),
	   .mul_r_o(mul_r_o),
	   .div_m_o(div_m_o),
	   .sqrt_r_o(sqrt_r_o)
	);
	assign add_r_o = add_r_ge128 | add_r_lt128;
endmodule
