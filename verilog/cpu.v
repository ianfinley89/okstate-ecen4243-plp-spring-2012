`include "constant_defs.vh"

//
// MODULE
//
module cpu(
  input                clk,
  input                i_cpu_stall,  // from memory module
  output [`W_ADDR-1:0] o_data_addr,  // memory address to write data
  output [`W_DATA-1:0] o_data,       // data to write
  input  [`W_DATA-1:0] i_data,       // data read from memory
  output [1:0]         o_data_rw,    // data memory read/write enable
  output [`W_ADDR-1:0] o_inst_addr,  // output from PC
  input  [`W_INST-1:0] i_inst,       // instruction
  input                i_int_nc,     // NYI
  output               o_int_ack_nc, // NYI
  input                rst           // active high asynchronous
  );
`include "constant_params.vh"


//
// WIRES
//
// internal nets
// cpu i/o (outputs assigned in assignment section)
wire               stall = i_cpu_stall;
wire [`W_DATA-1:0] dmem_in = i_data;
wire [`W_DATA-1:0] imem_addr;
// imm->alu,pc
wire [31:0]        imm32;
// imm->wb
wire [1:0]         lbu_byte;
// rf->pc,alu,cpu,wb,control
wire [`W_DATA-1:0] rfa;
wire [`W_DATA-1:0] rfb;
wire [`W_DATA-1:0] alu_r;
wire [4:0]         shamtv;
// control->alu
wire [5:0]         alu_func;
wire [4:0]         alu_shamt;
// wb->rf
wire [`W_DATA-1:0] wb_data;
// control->rf
wire               func_movz;
// alu->pc
wire               alu_r_z;
// pc->wb
wire [`W_DATA-1:0] jalra;

// Instruction Fields, assignments done here
// R-Type: opcode, rs, rt, rd, shamt, func
wire [5:0]  opcode = i_inst[31:26];
wire [4:0]  rs     = i_inst[25:21];
wire [4:0]  rt     = i_inst[20:16];
wire [4:0]  rd     = i_inst[15:11];
wire [4:0]  shamt  = i_inst[10: 6];
wire [5:0]  func   = i_inst[ 5: 0];
// I-Type: opcode, rs, rt, imm
wire [15:0] imm16  = i_inst[15: 0];
// J-Type: opcode, jaddr
wire [25:0] jaddr  = i_inst[25: 0];

// Control signals
wire       c_rf_we;      // register file write-enable
wire [1:0] c_wb_dest;    // writeback destination register address mux
wire       c_imm_zse;    // zero or sign extend immediate
wire       c_aluy_src;   // source of data for ALU Y-input
wire [1:0] c_dmem_rw;    // 0/1-hot encoding
wire       c_jjr;        // assert to use jump register for jump instruction
wire       c_b;          // assert on branch instruction
wire       c_j;          // assert on jump instruction
wire [1:0] c_wb_src;     // writeback data source mux


//
// ASSIGNMENTS
//
// sub-bus renames
assign shamtv = rfa[4:0];
// cpu outputs
assign o_inst_addr = imem_addr;
assign o_data_addr = {alu_r[31:2],2'b00}; // enforce word alignment here
                                          // XXX: design alteration
assign o_data      = rfb;
assign o_data_rw   = c_dmem_rw;


//
// SUBMODULES
//

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
  .imm30(imm32[29:0]),
  .jra(rfa),
  .jaddr26(jaddr),
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
  .data_word(dmem_in),
  .jalra(jalra),
  .alu_r(alu_r),
  // control
  .lbu_byte(lbu_byte),
  .c_wb_src(c_wb_src),
  // output
  .wb_data(wb_data)
  );

endmodule