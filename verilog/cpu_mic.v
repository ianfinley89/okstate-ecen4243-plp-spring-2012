`include "constant_defs.vh"

module cpu(
  input                clk,
  input                i_cpu_stall,
  input  [`W_INST-1:0] i_inst,
  input  [`W_DATA-1:0] i_data,
  input                i_int_nc,

  output [`W_ADDR-1:0] o_data_addr,
  output [`W_DATA-1:0] o_data,
  output [1:0]         o_data_rw,
  output [`W_ADDR-1:0] o_inst_addr,
  output               o_int_ack_nc,

  input                rst
  );

wire [5:0] opcode = i_inst[31:26];
wire [4:0] rs = i_inst[25:21];
wire [4:0] rt = i_inst[20:16];
wire [4:0] rd = i_inst[15:11];
wire [4:0] shamt = i_inst[15:0];
wire [5:0] func = i_inst[5:0];
wire [15:0] imm16 = i_inst[15:0];
wire [25:0] jaddr26 = i_inst[25:0];

endmodule