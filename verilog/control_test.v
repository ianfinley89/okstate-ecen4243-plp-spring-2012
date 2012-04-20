`timescale 1ns / 1ps
`include "constant_defs.vh"

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:48:50 04/20/2012
// Design Name:   control
// Module Name:   C:/okstate-ecen4243-plp-spring-2012/verilog/control_test.v
// Project Name:  foo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: control
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module control_test;
  `include "constant_params.vh"
	// Inputs
	reg stall;
	reg [5:0] opcode;
	reg [4:0] shamt;
	reg [5:0] func;
	reg [4:0] shamtv;

	// Outputs
	wire func_movz;
	wire [5:0] alu_func;
	wire [4:0] alu_shamt;
	wire c_imm_zse;
	wire c_jjr;
	wire c_b;
	wire c_j;
	wire c_rf_we;
	wire c_aluy_src;
	wire [1:0] c_wb_dest;
	wire [1:0] c_wb_src;
	wire [1:0] c_dmem_rw;

  wire [16:1] func_str;

	// Instantiate the Unit Under Test (UUT)
	control uut (
		.stall(stall), 
		.opcode(opcode), 
		.shamt(shamt), 
		.func(func), 
		.shamtv(shamtv), 
		.func_movz(func_movz), 
		.alu_func(alu_func), 
		.alu_shamt(alu_shamt), 
		.c_imm_zse(c_imm_zse), 
		.c_jjr(c_jjr), 
		.c_b(c_b), 
		.c_j(c_j), 
		.c_rf_we(c_rf_we), 
		.c_aluy_src(c_aluy_src), 
		.c_wb_dest(c_wb_dest), 
		.c_wb_src(c_wb_src), 
		.c_dmem_rw(c_dmem_rw)
	);

	initial begin
		// Initialize Inputs
		stall = 0;
		opcode = 0;
		shamt = 0;
		func = 0;
		shamtv = 0;
        
		status("initial");

    opcode = R_TYPE;
    func = MOVZ;
    status("movz");

    func = SRLV;
    shamtv = 4'h5;
    status("variable shift, alu_shamt should be 5");

    opcode = LUI;
    status("LUI, alu_shamt should be 0x10");

    $stop;

	end
      
  task status;
  input [640:1] str;
  begin
    #1;
    $display("== %s ==", str);
    $display("INPUT stall: %b_b\t opcode: %h\t shamt: %h\t func: %h\t shamtv: %h", stall, opcode, shamt, func, shamtv);
    $display("OUTPUT func_movz: %b_b\t alu_func: %h\t alu_shamt: %h\t", func_movz, alu_func, alu_shamt);
    $display("Control Outputs: imm_zse: %b\t jjr: %b\t b: %b\t j: %b\t rf_we: %b\t aluy_src: %b\t wb_dest: %b\t wb_src: %b\t dmem_rw: %b", c_imm_zse, c_jjr, c_b, c_j, c_rf_we, c_aluy_src, c_wb_dest, c_wb_src, c_dmem_rw);
  end
  endtask

endmodule

