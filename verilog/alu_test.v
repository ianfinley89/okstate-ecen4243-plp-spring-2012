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
		rfa = 32'hfffffffc;
		rfb = 32'h4;
		c_aluy_src = MUX_RFB;
		alu_func = F_ADD;
		status("add");
		
		
		rfa = 32'h6;
		status("add");

		
		alu_func = F_XOR;
		status("xor");
		alu_func = F_MULLO;
		status("mullo");

		rfa = 32'h0fffffff;
		rfb = 32'h3000;
		alu_func = F_MULHI;
		status("mulhi - 0x2FF expected");

		alu_shamt = 32'h4;
		rfb = 32'hf0;
    alu_func = F_LSHIFT;
    status("left shift");

    alu_func = F_RSHIFT;
    status("right shift");

    rfa = 32'h6;
    rfb = 32'h4;
    alu_func = F_SUB;
    status("subtraction");

    rfb = 32'h7;
    status("subtraction");

    rfb = 32'hf0f0f0f0;
    rfa = 32'h0f0f0f0f;
    alu_func = F_OR;
    status("or");

    alu_func = F_NOR;
    status("nor");

    rfa = 32'h5;
    rfb = 32'hfffffffc;
    alu_func = F_CMP_S;
    status("cmp signed");

    alu_func = F_CMP_U;
    status("cmp unsigned");

    rfb = 32'hfffffffb;
    status("cmp signed");

    alu_func = F_CMP_U;
    status("cmp unsigned");

    alu_func = F_NEQ;
    status("not equal");
    alu_func = F_EQ;
    status("equals");
		
    rfa = 32'h7;
    rfb = 32'h7;
    alu_func = F_NEQ;
    status("not equal");
    alu_func = F_EQ;
    status("equals");
    
    rfa = 32'h0;
    imm32 = 32'h10;
    c_aluy_src = MUX_IMM;
    alu_func = F_OR;
    status("src is im32, func OR");

		$stop;
	end
      
	// always @(rfa or rfb or c_aluy_src or imm32 or alu_func or alu_shamt) begin
	task status;
	input [640:1] str;
	begin
		#1;
		$display("== %s ==", str);
		$display("RFA: %h\tRFB: %h\tIMM32: %h", rfa, rfb, imm32);
		$display("rfb/imm32: %b\tfunc: %h\talu_shamt: %h", c_aluy_src, alu_func, alu_shamt);
		$display("ALU Result: %h ALU Zero? %b", alu_r, alu_r_z);
	end
	endtask
	
endmodule

