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
`include "constant_params.vh"

// from instruction field
wire [ 5:0] opcode  = i_inst[31:26];
wire [ 4:0] rs      = i_inst[25:21];
wire [ 4:0] rt      = i_inst[20:16];
wire [ 4:0] rd      = i_inst[15:11];
wire [ 4:0] shamt   = i_inst[15: 0];
wire [ 5:0] func    = i_inst[ 5: 0];
wire [15:0] imm16   = i_inst[15: 0];
wire [25:0] jaddr26 = i_inst[25: 0];

// from inputs
wire               stall = i_cpu_stall;
wire [`W_DATA-1:0] dmem_in = i_data;

// submodule inputs/outputs
wire               func_movz;
wire               alu_r_z;
wire [ 5:0]        alu_func;
wire [ 4:0]        alu_shamt;
wire [31:0]        imm32;
wire [ 1:0]        lbu_byte;
wire [`W_DATA-1:0] rfa;
wire [`W_DATA-1:0] rfb;
wire [`W_DATA-1:0] alu_r;
wire [`W_ADDR-1:0] imem_addr;
wire [`W_DATA-1:0] jalra;
wire [`W_DATA-1:0] wb_data;

// Control Signals
wire       c_imm_zse;  // immediate field zero or sign extend
wire       c_jjr;      // use jaddr or use $ra for jump destination
wire       c_b;        // true if this is a branch instruction
wire       c_j;        // true if this is a jump   instruction
wire       c_rf_we;    // register file write enable 
wire       c_aluy_src; // choose source of Y input of ALU (rfb or imm32)
wire [1:0] c_wb_dest;   // which register to write data to (rd, rt or #31)
wire [1:0] c_wb_src;    // which data source to use for writeback data
wire [1:0] c_dmem_rw;   // zero/one-hot encoding for read/write enable of data

// assignments
wire [4:0]         shamtv    = rfa[4:0];
wire [29:0]        imm30     = imm32[29:0];
wire [`W_DATA-1:0] jra       = rfa;
wire [`W_DATA-1:0] data_word = dmem_in;


endmodule