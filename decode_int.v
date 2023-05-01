`timescale 1ns / 1ps

module decode_int_lt_64(
	input [5:0] op_i, // for int lt 64, op is encoded on lower 5 bits
   
	output      add_rs_o,
	output      add_m_o,
	output      sub_r_o,
	output      sub_m_o,
	output      mul_r_o,
	output      mul_m_o
	);
	wire mid_ge_7;
	wire lsb_ge_8;  
	wire lsb_le_16;  
	wire lsb_ge_14;
	wire le_32; 
	wire lt_32;
	wire ge_48;
	
	assign mid_ge_7  = op_i[2] & op_i[1];   // XX_X11X
	assign lsb_ge_8  = mid_ge_7 &  op_i[0]; // XX_X111
	assign lsb_ge_14 = op_i[3] & mid_ge_7;  // XX_111X
	assign lsb_le_16 = op_i[4] & ~op_i[3];  // X1_0XXX
	assign le_32     = op_i[5] & ~op_i[4];  // 10_XXXX
	assign lt_32     = ~op_i[5];            // 0X_XXXX
	assign ge_48     =  op_i[5] & op_i[4];  // 11_XXXX
	// add
	assign add_rs_o = lt_32 & ~op_i[4]; // 00_XXXX
	assign add_m_o  = lt_32 & lsb_le_16 & ~lsb_ge_8;// 0001_0XXX & ~XXXX_X111
	
	// sub
	assign sub_r_o = ( lt_32 & op_i[4] & (( ~op_i[3] &  lsb_ge_8 ) | op_i[3] ))// 0001_0111 | 0001_1XXX | ( XX10_0XXX & ~ XXXX_X111 )
	               | ( le_32 & ~op_i[3]  & ~lsb_ge_8 );
	
	assign sub_m_o = le_32  // 0010_XXXX & ( XXXX_0111 | ( XXXX_1XXX & ~XXXX_X11X ) ) 
				   & ( ~op_i[3] ? lsb_ge_8 : ~mid_ge_7 );// 10_XXXX & (  XXXX_X111 | ( XX_1XXX & ~XX_X110 ) )
	// mul
	assign mul_r_o = (le_32 & op_i[3] & mid_ge_7)
				   | (ge_48 & ~lsb_ge_14);// 10_111X | (11_XXXX & ~XX_111X )
						
	assign mul_m_o = ge_48 & lsb_ge_14; // 11_111X
endmodule


module decode_int_ge_64(
	input [5:0] op_i, // for int lt 64, op is encoded on lower 5 bits
   
	output      mul_m_o,
	output      mulh_r_o,
	output      mulh_m_o,
	output      smulh_r_o,
	output      smulh_m_o,
	output      mul_rcp_o,
	output      neg_r_o,
	output      xor_r_o,
	output      xor_m_o,
	output      rolr_o,
	output      roll_o,
	output      swap_r_o
	);
	wire le_48;
	wire le_32;
	wire le_16;
	wire le_15; 
	wire le_7;     
	wire le_3;
	wire lsb_ge_3; 
	wire lsb_ge_4;
	wire lsb_ge_6; 
	wire lsb_ge_10;
	wire zeros_3_2;
	
	
	assign le_48 =  op_i[5] &  op_i[4];     // 11_XXXX
	assign le_32 =  op_i[5] & ~op_i[4];     // 10_XXXX
	assign le_16 = ~op_i[5] &  op_i[4];     // 01_XXXX
	assign le_15 = ~op_i[5] & ~op_i[4];     // 00_XXXX
	assign le_7  = le_15 & ~op_i[3];        // 00_0XXX
	assign le_3  = le_7 & ~op_i[2];         // 00_00XX
	assign lsb_ge_6  = op_i[2] & op_i[1];   // XX_X11X
	assign lsb_ge_4  = op_i[2] & ~op_i[1];  // XX_X10X
	assign lsb_ge_3  = op_i[1] & op_i[0];   // XX_XX11
	assign lsb_ge_10 = op_i[3] & ~op_i[2];  // XX_10XX 
	assign zeros_3_2 = ~op_i[3] & ~op_i[2]; // XX_00XX
	
	// mul
	assign mul_m_o = le_3 & ~op_i[1]; // 00_000X
	// mulh
	assign mulh_r_o = le_7 & ( (~op_i[2] & op_i[1]) | ( op_i[2] & ~lsb_ge_6));// 00_0XXX & ( 01X | ( 1XX & ~11X ) ) 
	assign mulh_m_o = le_7 & lsb_ge_6 & ~op_i[0]; // 00_0110
	// smulh
	assign smulh_r_o = le_15 & (( ~op_i[3] & op_i[2] & lsb_ge_3 ) | ( op_i[3] & ~op_i[2] & ~lsb_ge_3));// 00_XXXX & ( 0111 | ( 10XX & ~11 ) )
	assign smulh_m_o = le_15 & lsb_ge_10 & lsb_ge_3;// 001011
	// mul_rcp
	assign mul_rcp_o = ~op_i[5] & ((~op_i[4] & op_i[3] & op_i[2])|(op_i[4] & ~op_i[3] & ~op_i[2])) ;// 0X_XXXX & ( X0_11XX | X1_00XX )
	// neg
	assign neg_r_o = ~op_i[5] & op_i[4] & ~op_i[3] & lsb_ge_4;// 01_010X
	// xor
	assign xor_r_o = (le_16 & ((~op_i[3] & lsb_ge_6) | op_i[3])) // ( 01_XXXX & ( 011X | 1XXX )) | ( 10_0XXX & ( 0XX | 100 ))
			       | (le_32 & ~op_i[3] & ( ~op_i[2] | (lsb_ge_4 & ~op_i[0])));
	assign xor_m_o = le_32 
				   & ( ((~op_i[3] & op_i[2]) & ~(~op_i[1] & ~op_i[0]))
				   | (lsb_ge_10 & ~op_i[1]) ); // 10_XXXX & ( ( 01XX & ~01 ) | 100X )
	// rol right / left
	assign rolr_o = ( (le_32 & op_i[3]) & ~( ~op_i[2] & ~op_i[1] )) // ( 10_1XXX & ~00X ) | 11_000X
				  | ( le_48 & zeros_3_2 & ~op_i[1] );
	assign roll_o = le_48 & zeros_3_2 & op_i[1];// 11_001X 
	// swap 
	assign swap_r_o = le_48 & ~op_i[3] & op_i[2];// 11_01XX
endmodule

module decode_int(
	input [6:0] op_i, // for int, op is encoded on lower 6 bits
   
	// addition
	output      add_rs_o,
	output      add_m_o,
	// substract
	output      sub_r_o,
	output      sub_m_o,
	// multiply
	output      mul_m_o,
	output      mul_r_o,
	// multiply higher bit
	output      mulh_r_o,
	output      mulh_m_o,
	// multiply higher bit signed
	output      smulh_r_o,
	output      smulh_m_o,
	// multiply rcp
	output      mul_rcp_o,
	// negative
	output      neg_r_o,
	// xor
	output      xor_r_o,
	output      xor_m_o,
	// rotate left, right
	output      rolr_o,
	output      roll_o,
	// swap src and dst
	output      swap_r_o	 
	 );
	
	wire [5:0] op_sub_lt64;
	wire [5:0] op_sub_ge64;
	wire lt_64; // less than 64
	// lt 64 decode override
	wire add_rs_or; // mask op to 0 if op gt 64, mask out wrong value on add_rs if need be
	// ge 64 decode override and common
	wire mul_m_lt64; // mul_m covers value range lt 64 and ge 64
	wire mul_m_ge64;
	
	assign lt_64 = ~op_i[6]; // 0XX_XXXX
	assign op_sub_lt64 = {6{lt_64}} & op_i[6:0];// mask 
	assign op_sub_ge64 = {6{lt_64}} | op_i[6:0];// mask
	
	// lt 64
	decode_int_lt_64 sub_int_decode_lt64(
		.op_i(op_sub_lt64),
   
		.add_rs_o(add_rs_or),
		.add_m_o(add_m_o),
		.sub_r_o(sub_r_o),
		.sub_m_o(sub_m_o),
		.mul_r_o(mul_r_o),
		.mul_m_o(mul_m_lt64)
	);
	assign add_rs_o = add_rs_or & lt_64;
	
	// ge 64
	decode_int_ge_64 sub_int_decode_ge64(
		.op_i(op_sub_ge64),
  
		.mul_m_o(mul_m_ge64),
		.mulh_r_o(mulh_r_o),
		.mulh_m_o(mulh_m_o),
		.smulh_r_o(smulh_r_o),
		.smulh_m_o(smulh_m_o),
		.mul_rcp_o(mul_rcp_o),
		.neg_r_o(neg_r_o),
		.xor_r_o(xor_r_o),
		.xor_m_o(xor_m_o),
		.rolr_o(rolr_o),
		.roll_o(roll_o),
		.swap_r_o(swap_r_o)
	);
	assign mul_m_o = mul_m_ge64 | mul_m_lt64;
endmodule
