`include "constant_defs.vh"

module control(
  input       stall,
  input [5:0] opcode,
  input [4:0] shamt,
  input [5:0] func,
  input [4:0] shamtv,

  output       func_movz,
  output [5:0] alu_func,
  output [4:0] alu_shamt,

  output       c_imm_zse, 
  output       c_jjr,     
  output       c_b,       
  output       c_j,       
  output       c_rf_we,   
  output       c_aluy_src,
  output [1:0] c_wb_dest, 
  output [1:0] c_wb_src,  
  output [1:0] c_dmem_rw 
  );
`include "constant_params.vh"


assign alu_func =
  (opcode==R_TYPE) ?
    ( (func==MOVZ) ? F_OR : func ) :
  (opcode==BEQ   ) ? F_NEQ :
  (opcode==BNE   ) ? F_EQ  :
  (opcode==ADDIU ) ? F_ADD :
  (opcode==SLTI  ) ? F_CMP_S :
  (opcode==SLTIU ) ? F_CMP_U :
  (opcode==ANDI  ) ? F_ADD :
  (opcode==ORI   ) ? F_OR :
  (opcode==LUI   ) ? F_LSHIFT :
  (opcode==LW    ) ? F_ADD :
  (opcode==LBU   ) ? F_ADD :
  (opcode==SW    ) ? F_ADD : 
                     F_LSHIFT;

assign alu_shamt =
  (opcode==R_TYPE &&
    (func == SRLV || func == SLLV)) ? shamtv :
  (opcode==LUI) ? 5'd16 :
                  shamt;

  
assign func_movz = (opcode == R_TYPE && func == MOVZ);

assign c_rf_we =
  ( opcode==J   ||
    opcode==BEQ || 
    opcode==BNE ||
    opcode==SW  || 
    stall ) ? 1'b0
            : 1'b1;

assign c_wb_dest =
  (opcode==JAL   ) ? MUX_RA :
  (opcode==R_TYPE) ? MUX_RD :
                     MUX_RT ;

assign c_imm_zse =
  (opcode==ANDI || 
   opcode==ORI) ? 0 :
                  1 ;

assign c_aluy_src =
  (opcode==R_TYPE || 
   opcode==BEQ   || 
   opcode==BNE)  ? MUX_RFB :
                   MUX_SE  ;

assign c_dmem_rw = 
  (opcode==SW )               ? DMEM_WRITE:
  (opcode==LW || opcode==LBU) ? DMEM_READ:
                                DMEM_NOP;

assign c_wb_src = 
  (opcode==LW   ) ? MUX_DWORD:
  (opcode==JAL || 
    (opcode==R_TYPE && func==JALR)
                ) ? MUX_JALRA:
  (opcode==LBU  ) ? MUX_DBYTE:
                    MUX_ALU_R;

assign c_b = (opcode==BEQ || opcode==BNE);
assign c_j = 
  (opcode==J    ||
   opcode==JAL  || 
    (opcode== R_TYPE && 
      (func==JR || func==JALR)
    )
  );

assign c_jjr =
 (opcode== R_TYPE && 
      (func==JR || func==JALR) ) ? MUX_JRA:
  (opcode==J || opcode==JAL) ? MUX_JADDR : MUX_JADDR; 




endmodule