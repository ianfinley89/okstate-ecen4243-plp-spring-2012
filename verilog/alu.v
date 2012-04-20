`include "constant_defs.vh"

module alu(
  input  [`W_DATA-1:0] rfa,
  input  [`W_DATA-1:0] rfb,
  input  [31:0]        imm32,
  input                c_aluy_src,
  input  [5:0]         alu_func,
  input  [4:0]         alu_shamt,
 
  output               alu_r_z,
  output [`W_DATA-1:0] alu_r
  );

`include "constant_params.vh"

//WIRES INPUTS
wire  [`W_DATA-1:0] y;
wire  [`W_DATA-1:0] x;
wire  signed [63:0] mul64;
 

//ASSIGNMENTS INPUTS
assign y = (c_aluy_src==MUX_RFB) ? rfb : imm32;
assign x = rfa;
assign mul64 = $signed(x) * $signed(y);

//ASSIGNMENT OUTPUTS

assign alu_r =
(alu_func==F_LSHIFT ||
 alu_func==F_LSHIFTV) ? y << alu_shamt:
(alu_func==F_RSHIFT ||
 alu_func==F_RSHIFTV) ? y >> alu_shamt:
(alu_func==F_MULLO  ) ? mul64[`W_DATA-1:0]:
(alu_func==F_MULHI  ) ? mul64[`W_DATA*2-1:`W_DATA]:
(alu_func==F_ADD    ) ? x + y:
(alu_func==F_SUB    ) ? x - y:
(alu_func==F_AND    ) ? x & y: 
(alu_func==F_OR     ) ? x | y:
(alu_func==F_XOR    ) ? x ^ y:
(alu_func==F_NOR    ) ? ~( x | y ):
(alu_func==F_CMP_S  ) ? $signed(x) < $signed(y):
(alu_func==F_CMP_U  ) ? x < y:
(alu_func==F_NEQ    ) ? x != y:
(alu_func==F_EQ     ) ? x == y:
                        ZERO_DATA; // default value
assign alu_r_z = ~|alu_r;

endmodule
