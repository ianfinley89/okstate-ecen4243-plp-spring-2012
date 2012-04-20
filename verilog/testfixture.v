`timescale 1ns / 1ns
`define CPU_T test.uut.cpu_t
`define ROM test.uut.arbiter_t.rom_t.rom.RAM

`include "constant_defs.vh"
module test;
`include "constant_params.vh"
reg        clk;
wire [7:0] leds;
reg        rst;
wire       txd;
reg        rxd;
reg  [7:0] switches;

top uut(clk,leds,rst,txd,rxd,switches);

always #1 clk = ~clk;

initial begin
  $readmemh("../programs/bootload.hex",`ROM); // line delimited 32 bit wide hex, 512w max
  clk = 0;
  rst = 1;
  #10
  rst = 0;
  #490
  $display("500 time units done");
end


// XXX: autogenerate?
//
// ASCII decoding
//
reg  [39:0] _ascii_instruction; // 40 bits, 5 bytes/chars
reg  [23:0] _ascii_alu_op;
wire [5:0] opcode = `CPU_T.opcode;
wire [4:0] shamt  = `CPU_T.shamt;
wire [5:0] func   = `CPU_T.func;
wire [4:0] rs     = `CPU_T.rs;
wire [4:0] rt     = `CPU_T.rt;
always @(opcode or func or shamt or rs or rt) begin
  // ascii alu operation decoding
  case({func})
    F_LSHIFT:
      _ascii_alu_op = "<< ";
    F_LSHIFTV:
      _ascii_alu_op = "<< ";
    F_RSHIFT:
      _ascii_alu_op = ">> ";
    F_RSHIFTV:
      _ascii_alu_op = ">> ";
    F_MULLO:
      _ascii_alu_op = "*LO";
    F_MULHI:
      _ascii_alu_op = "*HI";
    F_ADD:
      _ascii_alu_op = " + ";
    F_SUB:
      _ascii_alu_op = " - ";
    F_AND:
      _ascii_alu_op = " & ";
    F_OR:
      _ascii_alu_op = " | ";
    F_XOR:
      _ascii_alu_op = " ^ ";
    F_NOR:
      _ascii_alu_op = "~| ";
    F_CMP_S:
      _ascii_alu_op = "<+-";
    F_CMP_U:
      _ascii_alu_op = "<++";
    F_NEQ:
      _ascii_alu_op = "== ";
    F_EQ:
      _ascii_alu_op = "!= ";
    default:
      _ascii_alu_op = "%Er";
  endcase

  // ascii instruction decoding
  case({opcode})
    R_TYPE:
    case({func})
    ADDU :
      if(rt == SPR_Z)
      begin
             _ascii_instruction = "move "; // pseudo-op
      end else begin
             _ascii_instruction = "addu ";
      end
    AND  :   _ascii_instruction = "and  ";
    JR   :   _ascii_instruction = "jr   ";
    JALR :   _ascii_instruction = "jalr ";
    MOVZ :   _ascii_instruction = "movz ";
    MULHI:   _ascii_instruction = "mulhi";
    MULLO:   _ascii_instruction = "mullo";
    NOR  :   _ascii_instruction = "nor  ";
    OR   :   _ascii_instruction = "or   ";
    SLL  :
      case({shamt})
        0:   _ascii_instruction = "nop  "; // pseudo-op
        default:
             _ascii_instruction = "sll  ";
      endcase
    SLLV :   _ascii_instruction = "sllv ";
    SLT  :   _ascii_instruction = "slt  ";
    SLTU :   _ascii_instruction = "sltu ";
    SRL  :   _ascii_instruction = "srl  ";
    SRLV :   _ascii_instruction = "srlv ";
    SUBU :   _ascii_instruction = "subu ";
    XOR  :   _ascii_instruction = "xor  ";
    default:
      begin
             _ascii_instruction = "%Err ";
      end
    endcase // end func/R_TYPE case
    ADDIU:   _ascii_instruction = "addiu";
    ANDI :   _ascii_instruction = "andi ";
    BEQ  :
      if(rs == SPR_Z && rt == SPR_Z)
      begin
             _ascii_instruction = "b    "; // pseudo-op
      end else begin
             _ascii_instruction = "beq  ";
      end
    BNE  :   _ascii_instruction = "bne  ";
    J    :   _ascii_instruction = "j    ";
    JAL  :   _ascii_instruction = "jal  ";
    LBU  :   _ascii_instruction = "lbu  ";
    LUI  :   _ascii_instruction = "lui  ";
    LW   :   _ascii_instruction = "lw   ";
    ORI  :   _ascii_instruction = "ori  ";
    SLTI :   _ascii_instruction = "slti ";
    SLTIU:   _ascii_instruction = "sltiu";
    SW   :   _ascii_instruction = "sw   ";
    default:
      begin
             _ascii_instruction = "%Err ";
      end
  endcase
end

endmodule

// because defines are global until undefined
`undef CPU_T
`undef ROM