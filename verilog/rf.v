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

// Wires
reg  [`W_DATA-1:0] rf [`RF_SIZE-1:1];
wire we;                                             // Write Enable Control bit
wire [`W_RFADDR-1:0] wr;                             // It is the result from the Mux
wire rfb_z; 

// Assignments
assign rfb_z = (rt == SPR_Z) ? 1'b1 : ~|rf[rt];                             // NORS the bits in rfb
assign we = (func_movz ? (rfb_z) : 1) && c_rf_we;    // Checks the condition func_movz, assigns rfb_z to we
                                                     // if true and 1 if false
assign wr =                                          // Choses the write to register based
  (c_wb_dest == MUX_RD) ? rd :                       // on the 3 conditions, and defaults to
  (c_wb_dest == MUX_RT) ? rt :                       // the zero register
  (c_wb_dest == MUX_RA) ? SPR_JRA :
                          SPR_Z;

assign rfa = (rs == SPR_Z) ? ZERO_DATA : rf[rs];     // Checks if rs or rt specifies the zero register  
assign rfb = (rt == SPR_Z) ? ZERO_DATA : rf[rt];     // and sends zero data to rfa or rfb, if not zero,
                                                     // it stores rf[rs] and rf[rt] into rfa and rfb, respectively
always @(negedge clk)
begin
  if (we && wr != SPR_Z)  // Checks if write is enabled, and the write to register is not specified as
  begin                   // the zero register, then it actually writes the data to the write register (rd)
    rf[wr] <= wb_data;
  end
end

endmodule
