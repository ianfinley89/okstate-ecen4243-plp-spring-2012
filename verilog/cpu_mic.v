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
wire [4:0]         shamtv    = rfa[4:0];    // shift amount variable
wire [29:0]        imm30     = imm32[29:0]; // immediate of 30 bits
wire [`W_DATA-1:0] jra       = rfa;         // jump return address
wire [`W_DATA-1:0] data_word = dmem_in;     // data read from the data memory


// output assignments
assign o_data_addr = alu_r ;  
assign o_data = rfb ;         
assign o_data_rw = c_dmem_rw ;
assign o_inst_addr = imem_addr;

// SUBMODULES
imm imm(
  // data
  .imm16(imm16),
  // control
  .c_imm_zse(c_imm_zse),
  // output
  .imm32(imm32),
  .lbu_byte(lbu_byte)
  );

control control(
  // control
  .stall(stall),
  // input
  .opcode(opcode),
  .shamt(shamt),
  .func(func),
  .shamtv(shamtv),
  // output
  .alu_func(alu_func),
  .alu_shamt(alu_shamt),
  .func_movz(func_movz),
  .c_rf_we(c_rf_we),
  .c_wb_dest(c_wb_dest),
  .c_imm_zse(c_imm_zse),
  .c_aluy_src(c_aluy_src),
  .c_dmem_rw(c_dmem_rw),
  .c_jjr(c_jjr),
  .c_b(c_b),
  .c_j(c_j),
  .c_wb_src(c_wb_src)
  );

alu alu(
  // data
  .rfa(rfa),
  .rfb(rfb),
  .imm32(imm32),
  // control
  .c_aluy_src(c_aluy_src),
  .alu_func(alu_func),
  .alu_shamt(alu_shamt),
  // output
  .alu_r_z(alu_r_z),
  .alu_r(alu_r)
  );

rf rf(
  .clk(clk),
  // data
  .rs(rs),
  .rt(rt),
  .rd(rd),
  .wb_data(wb_data),
  // control
  .func_movz(func_movz),
  .c_wb_dest(c_wb_dest),
  .c_rf_we(c_rf_we),
  // output
  .rfa(rfa),
  .rfb(rfb)
  );

pc pc(
  .clk(clk),
  // data
  .imm30(imm30),
  .jra(jra),
  .jaddr(jaddr),
  // control
  .stall(stall),
  .c_jjr(c_jjr),
  .c_b(c_b),
  .c_j(c_j),
  .alu_r_z(alu_r_z),
  // output
  .imem_addr(imem_addr),
  .jalra(jalra),

  .rst(rst)
  );

wb wb(
  // data
  .data_word(data_word),
  .jalra(jalra),
  .alu_r(alu_r),
  // control
  .lbu_byte(lbu_byte),
  .c_wb_src(c_wb_src),
  // output
  .wb_data(wb_data)
  );


endmodule
