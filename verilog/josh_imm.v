`include "constant_defs.vh" // ` dummy backquote for syntax highlighting

// MODULE
module imm(
� // data
� input �[15:0] imm16,
� // control
� input �c_imm_zse,
� // output
� output [31:0] imm32,
� output [ 1:0] lbu_byte
� );
`include "constant_params.vh" // ` dummy

// WIRES
wire [15:0] extension;

// ASSIGNMENTS
// XXX: Fix me.
// hint: {M{N}} is N repeated M times
// � � � {5{foo[3:2]}} repeats bits 3 and 2 of foo 5 times
// � � � equivalent to {foo[3:2],foo[3:2],foo[3:2],foo[3:2],foo[3:2]}
// hint: X'bY is a signal X bits wide representing the binary number Y
// � � � 5'b10 represents 00010 in base 2.
// so, replace sign_extend with something in the format of {M{N}}
// and replace zero_extend with something in the format of X'bY
assign extension = (c_imm_zse == MUX_SE) ? {16{imm16[15]}} : 16'b00;//{16{1}}=>16 bits of one's , 16'b00=>16 bits of Zeros
�
assign imm32 = { extension, imm16 };
assign lbu_byte = imm16[1:0]; // our byte offset for LBU instruction

endmodule
