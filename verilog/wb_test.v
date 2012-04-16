`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:19:24 04/16/2012
// Design Name:   wb
// Module Name:   C:/okstate-ecen4243-plp-spring-2012/verilog/wb_test.v
// Project Name:  foo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: wb
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module wb_test;

	// Inputs
	reg [31:0] data_word;
	reg [31:0] jalra;
	reg [31:0] alu_r;
	reg [1:0] lbu_byte;
	reg [1:0] c_wb_src;

	// Outputs
	wire [31:0] wb_data;

	// Instantiate the Unit Under Test (UUT)
	wb uut (
		.data_word(data_word), 
		.jalra(jalra), 
		.alu_r(alu_r), 
		.lbu_byte(lbu_byte), 
		.c_wb_src(c_wb_src), 
		.wb_data(wb_data)
	);

	initial begin
		// Initialize Inputs
		data_word = 0;
		jalra = 0;
		alu_r = 0;
		lbu_byte = 0;
		c_wb_src = 0;
		status("init");
        
		// Add stimulus here
	data_word = 32'hbac4353f;	
	c_wb_src = 2'h1;
	status("data word");
	
	alu_r = 32'hfff43322;
	c_wb_src = 2'h0;
	status("alu result");
	
	jalra = 32'h234fff11;
	c_wb_src = 2'h2;
	status("jump and link return address");
	
	lbu_byte = 0;
	c_wb_src = 2'h3;
	status("lbu byte is zero");
	
	lbu_byte = 1;
	status("lbu byte is one");
	
	lbu_byte = 2;
	status("lbu byte is two");
	
	lbu_byte = 3;
	status("lbu byte is three");

	end
	
	task status;
	input [400:1] str;
	begin
			#1
			$display("== %s ==", str);
			$display("data_word: %h\tjalra: %h\talu_r: %h\tlbu_byte: %bb\tc_wb_src: %h",data_word,jalra,alu_r,lbu_byte,c_wb_src);
			$display("wb_data: %h", wb_data);
	end
	endtask
	
endmodule

