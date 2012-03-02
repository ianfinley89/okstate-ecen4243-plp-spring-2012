`include "constant_defs.vh" // mostly sizes and widths in this file

//123456789012345678901234567890123456789012345678901234567890123456789012345678
// limit lines to 79-80 characters wide
//
// MODULE
//
module submodule(
  input  clk, // two spaces for indentation, no tabs (EVER.)
  // data
  input                one_bit_data_input,   // note alignment of columns
  input  [23:0]        fixed_width_signal24, // 24 bits in name
  input  [`W_DATA-1:0] input1,               // `W_DATA is in constant_defs.vh
  input  [`W_DATA-1:0] input2,
  input  [5:0]         opcode,
  // control
  input  c_foo,
  input  c_bar,
  input  c_baz,
  input  some_other_control_like_signal,
  // output
  output [`W_DATA-1:0] output1,
  output [`W_DATA-1:0] output2,
  output               is_load_type,
  output               output3,

  input  rst  // typically the last signal but not all submodules have rst
  );
`include "constant_params.vh" // opcodes, mux definitions, etc

//
// REGISTERS
//
reg  [`W_DATA-1:0] some_value;


//
// WIRES
//
wire in1 = input1; // perfectly valid to do assignment here
                   // usually reserved for giving input signal
                   // a different name
wire [4:0] wire_with_5bits; // some internal net

//
// ASSIGNMENTS
//
// assign values to outputs here. most outputs are not registers
// so use blocking assignments '=', not '<='

// concatenate bits 30:0 of input1 with bits 15:14 of input2 to
// 32 bit output output1
assign output1 = {input1[30:0], input2[15:14]};

/// can do simple logic
assign is_load_type = ( opcode == LBU || opcode == LW );

// or more complicated stuff
assign output2 =
  (c_foo && c_bar && !c_baz) ? input1 : input2;

// How to work with a mux:
assign output3 =
  (c_foo == MUX_VALUE1) ? input1;
  (c_foo == MUX_VALUE2) ? input2 :
                          input1 ; // our default value if we somehow
                                   // get a mux select value we did not expect


// clock/reset logic with registers is done within an 'always' block.
// make sure you have every possible case covered,
// or more preferrably, a default value outside the 'if' block
// In general, only nonblocking '<=' assignments
// should be used within an 'always' block so you
// get proper synthesis and no race conditions.
always @(posedge clk or posedge rst)
begin
  if (rst)
  begin
    some_value <= 0;
  end else begin
    some_value <= input2;
  end
end

endmodule