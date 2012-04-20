`timescale 1ns / 1ps
`include "constant_defs.vh"

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:44:40 04/20/2012
// Design Name:   rf
// Module Name:   C:/okstate-ecen4243-plp-spring-2012/verilog/rf_test.v
// Project Name:  foo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: rf
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module rf_test;
  `include "constant_params.vh"
	// Inputs
	reg clk;
	reg func_movz;
	reg [1:0] c_wb_dest;
	reg c_rf_we;
	reg [4:0] rs;
	reg [4:0] rt;
	reg [4:0] rd;
	reg [31:0] wb_data;

	// Outputs
	wire [31:0] rfa;
	wire [31:0] rfb;

	// Instantiate the Unit Under Test (UUT)
	rf uut (
		.clk(clk), 
		.func_movz(func_movz), 
		.c_wb_dest(c_wb_dest), 
		.c_rf_we(c_rf_we), 
		.rs(rs), 
		.rt(rt), 
		.rd(rd), 
		.wb_data(wb_data), 
		.rfa(rfa), 
		.rfb(rfb)
	);

	always #1 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		func_movz = 0;
		c_wb_dest = 0;
		c_rf_we = 0;
		rs = 0;
		rt = 0;
		rd = 0;
		wb_data = 0;
        
		// Add stimulus here
    wb_data = 32'hdeadbeef;
    c_wb_dest = MUX_RD;
    rd = 5'h1;
    #2
    status("attempt write 0xdeadbeef to register 1 (we=0)");

    c_rf_we = 1'b1;
    #2
    status("write 0xdeadbeef to register 1 (we=0)");


    wb_data = 32'h02020202;
    rd = 5'h2;
    #2
    status("write 0x02020202 to register 2");

    wb_data = 32'h30303030;
    rd = 5'h3;
    #2
    status("write 0x30303030 to register 3");

    rs = 5'h1;
    rt = 5'h2;
    c_rf_we = 1'b0;
    #2
    status("we disabled");

    func_movz = 1'b1;
    rt = 5'h0;
    c_rf_we = 1'b1;
    #2
    status("func_movz with rf[rt] == 0, expected we==1");
    $display("we: %h", rf_test.uut.we);

    rt = 5'h1;
    #2
    status("func_movz with rf[rt] != 0, expected we==0");
    $display("we: %h", rf_test.uut.we);

    func_movz = 1'b0;
    rs = 5'd31;
    rt = 5'h1;
    rd = 5'h2;
    wb_data = 32'h7c7c7c7c;
    c_wb_dest = MUX_RT;
    #2
    status("write to rt");

    c_wb_dest = MUX_RA;
    #2
    status("write to $ra (31)");

    c_wb_dest = MUX_RD;
    rd = 5'h0;
    wb_data = 32'h5d5d5d5d;
    #2
    status("test write to 0 (should be no effect)");

	end

	task status;
		input [640:1] str;
		begin
			$display("== %s ==", str);
			$display("INPUTS c_wb_dest: %b_b\tc_rf_we: %b_b\trs: %h\trt: %h\trd: %h", c_wb_dest, c_rf_we, rs, rt, rd);
      $display(" func_movz: %b_b\twb_data: %h", func_movz, wb_data);
      $display("RF rf[rs]: %h\t rf[rt]: %h\t rf[rd]: %h", rf_test.uut.rf[rs], rf_test.uut.rf[rt], rf_test.uut.rf[rd]);
      $display("Ou rfa   : %h\t rfb   : %h", rfa, rfb);
		end
	endtask
      
endmodule

