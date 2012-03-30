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

//  when can you

//- data memory read/write control
//
//    two bits
//    zero/one hot encoding c_drw[1] is read bit, c_drw[0] is write bit
//    only the read OR the write signal is asserted at any one time, otherwise neither for a nop
//    read for SW
//    write for LW, LBU
//    don't let both bits be set 

assign c_wb_src =

//- writeback register source MUX
//
//    2 bits
//    3 sources at this time, will have a 4th if we add LBU
//    sources: alu_r (alu result, most instructions), dmem_in (data memory read (lw, lbu)), jalra (jump and link register address (jal, jalr)) 

assign c_b & c_j =

//    boolean signals that are asserted for branch and jump instructions, respectively
//    branch: beq, bne
//    jump: j, jr, jal, jalr 

assign c_jjr =

//- jaddr source mux
//
//    1 bit
//    asserted to use jra (rfa, rf[$ra], rf[31]) for JR, JALR instructions
//    deasserted to use pc_4+(jaddr<<2) for J, JAL instructions 




endmodule