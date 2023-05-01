`timescale 1ns / 1ps

module decode_op(
	input       op_v_i,
	input [7:0] op_i,
	
	output      op_v_o,
	output      int_v_o,
	output      float_v_o

    );

	wire is_int;
	wire is_float;
	wire is_ctl;
	
	decode_op_type m_op_type(
		.op_i(op_i),
		
		.is_int_o(is_int),
		.is_float_o(is_float),
		.is_ctl_o(is_ctl)
	);
endmodule
