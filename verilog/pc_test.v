`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:36:54 04/16/2012
// Design Name:   pc
// Module Name:   C:/okstate-ecen4243-plp-spring-2012/verilog/pc_test.v
// Project Name:  foo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pc
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pc_test;

	// Inputs
	reg clk;
	reg stall;
	reg [29:0] imm30;
	reg [31:0] jra;
	reg [25:0] jaddr26;
	reg c_jjr;
	reg c_b;
	reg c_j;
	reg alu_r_z;
	reg rst;

	// Outputs
	wire [31:0] imem_addr;
	wire [31:0] jalra;

	// Instantiate the Unit Under Test (UUT)
	pc uut (
		.clk(clk), 
		.stall(stall), 
		.imm30(imm30), 
		.jra(jra), 
		.jaddr26(jaddr26), 
		.c_jjr(c_jjr), 
		.c_b(c_b), 
		.c_j(c_j), 
		.alu_r_z(alu_r_z), 
		.imem_addr(imem_addr), 
		.jalra(jalra), 
		.rst(rst)
	);
	
	always #1 clk = ~clk;
	

	initial begin
		// Initialize Inputs
		clk = 0;
		stall = 0;
		imm30 = 0;
		jra = 0;
		jaddr26 = 0;
		c_jjr = 0;
		c_b = 0;
		c_j = 0;
		alu_r_z = 0;
		rst = 1;
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst = 0;
		#10; //wait 10ns
		status("10ns after reset clear");
		
		stall = 1;	
		#2
		status("stall");
		
		stall = 0;
		c_b = 1;
		alu_r_z = 1;
		imm30 = 30'hff00;
		#2
		status("branching with imm30 = 0xFF00 with alu_r_z=1");
		
		alu_r_z = 0;
		#2
		status("branching with imm30 = 0xFF00 with alu_r_z=0");
		
		c_b = 0;
		c_j = 1;
		c_jjr = 0;
		jaddr26 = 26'h003;
		#2;
		status("jumping with jaddr26");
		
		c_jjr = 1;
		jra = 32'hade3ff00;
		#2;
		status("jumping to ade3ff00");
		
		$stop;
	end
	
	
	task status;
		input [400:1] str;
		begin
			$display("== %s ==", str);
			$display("INPUTS stall: %h imm30: %h jra: %h jaddr: %h", stall, imm30, jra, jaddr26);
			$display(" alu_r_z: %h c_jjr: %h c_b: %h c_j: %h", alu_r_z, c_jjr, c_b, c_j);
			$display("OUTPUTS imem_addr: %h jalra: %h", imem_addr, jalra);
		end
	endtask
	
      
endmodule

