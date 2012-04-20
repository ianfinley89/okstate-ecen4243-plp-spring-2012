`timescale 1ns / 1ns
module imm_test;

reg [15:0] imm16;
reg c_imm_zse;

wire [31:0] imm32;
wire [1:0]  lbu_byte;


imm imm_uut(
  imm16,
  c_imm_zse,
  imm32,
  lbu_byte
);

initial begin


  imm16 = 16'h0;
  c_imm_zse = 1'b0;
  #10
  $display("%b %h %h", c_imm_zse, imm16, imm32);
  
  
  
  
  imm16 = 16'h0;
  c_imm_zse = 1'b1;
    #10
	 $display("%b %h %h", c_imm_zse, imm16, imm32);
	 
  imm16 = 16'hffff;
  c_imm_zse = 1'b0;
    #10
	 $display("%b %h %h", c_imm_zse, imm16, imm32);
	 
  imm16 = 16'hffff;
  c_imm_zse = 1'b1;
  
  #10
  $display("%b %h %h", c_imm_zse, imm16, imm32);
  #490
  $display("done");
end

endmodule