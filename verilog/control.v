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

endmodule