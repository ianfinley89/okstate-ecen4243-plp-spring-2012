`include "constant_defs.vh"

//MODULE
module wb(
 //data
 input        [`W_DATA-1:0]     data_word,
 input        [`W_DATA-1:0]     jalra,
 input        [`W_DATA-1:0]     alu_r,
 //control
 input        [1:0]             lbu_byte,
 input        [1:0]             c_wb_src,
 //output
 output        [`W_DATA-1:0]    wb_data
);

`include "constant_params.vh"

//WIRES

wire [7:0] data_byte;
wire [`W_DATA-1:0] data_byte_ze;

// ASSIGNMENTS

// MUX_DATA_BYTE_1
assign data_byte =
  (lbu_byte== 2'd0) ? data_word[7:0]:
  (lbu_byte== 2'd1) ? data_word[15:8]:
  (lbu_byte== 2'd2) ? data_word[23:16]:
  (lbu_byte== 2'd3) ? data_word[31:24]:
                      data_word[7:0];
  

// MUX_DATA_BYTE_

assign data_byte_ze = {24'b0, data_byte}; // NOTE: no dependence on W_DATA
assign wb_data =
 (c_wb_src== MUX_DBYTE) ? data_byte_ze:
 (c_wb_src== MUX_JALRA) ? jalra:
 (c_wb_src== MUX_DWORD) ? data_word:
 (c_wb_src== MUX_ALU_R) ? alu_r:
                          ZERO_DATA;


endmodule

