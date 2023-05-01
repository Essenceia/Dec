`timescale 1ns / 1ps

module decode_control(
		input [7:0] op_i,
		output      fround_o,
		output      branch_o,
		output      store_o
    );
	 wire lt_16;
	 wire ge_192;
	 wire lsb_ge_4;
	 assign lsb_ge_4 = ~op_i[3] & op_i[2]; //    01XX
	 assign lt_16    = ~op_i[5] & op_i[4]; // 01_XXXX
	 assign ge_192   = op_i[7] & op_i[6];
	 // float round mode
	 assign fround_o = ge_192 & lt_16& lsb_ge_4 & op_i[1] & ~op_i[0];// 01_0110
	// conditional jump
	assign branch_o = ge_192
					& ( ( lt_16 & ( op_i[3] | (lsb_ge_4 & op_i[1] & op_i[0])))
					  | ( op_i[5] & ~op_i[4] ));//( 01_XXXX & ( 1XXX | 0111 )) | 10_XXXX
	// store
	assign store_o = ge_192 & op_i[5] & op_i[4];// 11_XXXX

endmodule
