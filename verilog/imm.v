// Immediate field Submodule for PLP Single-Cycle Processor Implementation
`include "constant_defs.vh"

//
// MODULE
//
module imm(
  // data
  input  [15:0] imm16,
  // control
  input  c_imm_zse,
  // output
  output [31:0] imm32,
  output [1:0]  lbu_byte
  );
`include "constant_params.vh"

//
// WIRES
//
wire [15:0] extension;

//
// ASSIGNMENTS
//

// immediate field 16=>32 extension
// NOTE: I had weird results in synthesis when using the reference method
//       I think this is better anyway since the data width for the mux
//       inputs is explicitly 16 bits instead of 32
// not using MUX_ZE here
assign extension = (c_imm_zse == MUX_SE) ? {16{imm16[15]}} : 16'b0;
assign imm32 = { extension, imm16 };

assign lbu_byte = imm16[1:0]; // byte offset for LBU instruction

endmodule