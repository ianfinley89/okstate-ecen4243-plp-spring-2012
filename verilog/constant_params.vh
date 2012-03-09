`include "constant_defs.vh"

// Miscellaneous
parameter SPR_JRA   = `W_RFADDR'd31; // Special purpose register
parameter SPR_Z     = `W_RFADDR'd0;
parameter ZERO_DATA =   `W_DATA'd0;

// c_dmem_rw control signal constants, 0 or 1 hot
// Don't even think about adding 2'b11
parameter DMEM_READ  = 2'b10;
parameter DMEM_WRITE = 2'b01;
parameter DMEM_NOP   = 2'b00;


//
// MUX CONSTANTS
//
// JJR Mux
parameter MUX_JADDR = 1'd0;
parameter MUX_JRA   = 1'd1;
// WB_DEST Mux
parameter MUX_RD = 2'd0;
parameter MUX_RT = 2'd1;
parameter MUX_RA = 2'd2;
// WB_SRC Mux
parameter MUX_DBYTE = 2'd3;
parameter MUX_JALRA = 2'd2;
parameter MUX_DWORD = 2'd1;
parameter MUX_ALU_R = 2'd0;
// ALUY_SRC Mux
parameter MUX_IMM = 1'd1;
parameter MUX_RFB = 1'd0;
// Immediate zero/sign extend mux
parameter MUX_ZE = 1'd0;
parameter MUX_SE = 1'd1;


//
// OPCODES - keep sorted in hex order
//
parameter R_TYPE = 6'h00;

parameter J      = 6'h02;
parameter JAL    = 6'h03;
parameter BEQ    = 6'h04;
parameter BNE    = 6'h05;

parameter ADDIU  = 6'h09;
parameter SLTI   = 6'h0a;
parameter SLTIU  = 6'h0b;
parameter ANDI   = 6'h0c;
parameter ORI    = 6'h0d;

parameter LUI    = 6'h0f;

parameter LW     = 6'h23;
parameter LBU    = 6'h24;

parameter SW     = 6'h2b;


//
// FUNCTIONS - keep sorted in hex order
//
parameter SLL    = 6'h00;

parameter SRL    = 6'h02;

parameter SLLV   = 6'h04;

parameter SRLV   = 6'h06;

parameter JR     = 6'h08;
parameter JALR   = 6'h09;
parameter MOVZ   = 6'h0a;

parameter MULLO  = 6'h10;
parameter MULHI  = 6'h11;

parameter ADDU   = 6'h21;

parameter SUBU   = 6'h23;
parameter AND    = 6'h24;
parameter OR     = 6'h25;
parameter XOR    = 6'h26;
parameter NOR    = 6'h27;

parameter SLT    = 6'h2a;
parameter SLTU   = 6'h2b;


//
// ALU FUNCTIONS - keep sorted in hex order
//
parameter F_LSHIFT = 6'h00;

parameter F_RSHIFT = 6'h02;

parameter F_MULLO  = 6'h10; // 32x32 signed mult, return low 32
parameter F_MULHI  = 6'h11; // 32x32 signed mult, return high 32

parameter F_ADD    = 6'h21;

parameter F_SUB    = 6'h23;
parameter F_AND    = 6'h24;
parameter F_OR     = 6'h25;
parameter F_XOR    = 6'h26;
parameter F_NOR    = 6'h27;

parameter F_CMP_S  = 6'h2a; // x < y signed
parameter F_CMP_U  = 6'h2b; // x < y unsigned

parameter F_NEQ    = 6'h3a; // XXX: make sure these fx codes are ok
parameter F_EQ     = 6'h3b; // XXX: make sure these fx codes are ok