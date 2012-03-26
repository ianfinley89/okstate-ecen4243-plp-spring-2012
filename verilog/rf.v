`include "constant_defs.vh"

module rf(
  input  clk,
  
  // Control
  input  func_movz,
  input  [1:0] c_wb_dest,
  input  c_rf_we,
  // Data
  input  [`W_RFADDR-1:0]  rs,
  input  [`W_RFADDR-1:0]  rt,
  input  [`W_RFADDR-1:0]  rd,
  input  [`W_DATA-1:0]  wb_data,
  // Output
  output [`W_DATA-1:0]  rfa,
  output [`W_DATA-1:0]  rfb
  );

`include "constant_params.vh"

reg  [`W_DATA-1:0] rf [`W_DATA-1:1];
wire we;
wire [`W_RFADDR-1:0] wr;

assign we = (func_movz ? (~|rf[rt]) : 1) && c_rf_we;
assign wr = 
  (c_wb_dest == MUX_RD) ? rd :
  (c_wb_dest == MUX_RT) ? rt :
  (c_wb_dest == MUX_RA) ? 5'd31 ;

always @(negedge clk)
begin
  if (we && wr != SPR_Z)
  begin
    rf[wr] <= wb_data;
  end
end
endmodule

