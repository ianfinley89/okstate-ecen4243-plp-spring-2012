`timescale 1ns / 1ps
`include "constant_defs.vh"

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:06:50 04/15/2012
// Design Name:   alu
// Module Name:   C:/Users/gaalswy/Documents/Dropbox/ecen4243/okstate-ecen4243-plp-spring-2012/verilog/alu_test.v
// Project Name:  Xilinx
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alu_test;
	`include "constant_params.vh"
	// Inputs
	reg [31:0] rfa;
	reg [31:0] rfb;
	reg [31:0] imm32;
	reg c_aluy_src;
	reg [5:0] alu_func;
	reg [4:0] alu_shamt;

	// Outputs
	wire alu_r_z;
	wire [31:0] alu_r;

	// Instantiate the Unit Under Test (UUT)
	alu uut (
		.rfa(rfa), 
		.rfb(rfb), 
		.imm32(imm32), 
		.c_aluy_src(c_aluy_src), 
		.alu_func(alu_func), 
		.alu_shamt(alu_shamt), 
		.alu_r_z(alu_r_z), 
		.alu_r(alu_r)
	);
	
	reg clk;
	
	always #1 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		rfa = 0;
		rfb = 0;
		imm32 = 0;
		c_aluy_src = 0;
		alu_func = 0;
		alu_shamt = 0;
		status("init");
        
		// Add stimulus here
		rfa = 32'h5;
		rfb = 32'h4;
		c_aluy_src = MUX_RFB;
		alu_func = F_ADD;
		status("add");
		
		
		rfa = 32'h6;
		status("");
		
		alu_func = F_XOR;
		status("xor");
		alu_func = F_MULLO;
		status("mullo");
		alu_func = F_MULHI;
		status("mulhi");
		
		$stop;
	end
      
	// always @(rfa or rfb or c_aluy_src or imm32 or alu_func or alu_shamt) begin
	task status;
	input [80:1] str;
	begin
		#1;
		$display("== %s ==", str);
		$display("RFA: %h\tRFB: %h\tIMM32: %h", rfa, rfb, imm32);
		$display("rfb/imm32: %b\tfunc: %h\talu_shamt: %h", c_aluy_src, alu_func, alu_shamt);
		$display("ALU Result: %h ALU Zero? %b", alu_r, alu_r_z);
	end
	endtask
	
endmodule

