// Program Counter Submodule for PLP Single-Cycle Processor Implementation
`include "constant_defs.vh"

//
// MODULE
//
module pc(
  input  clk,
  // data
  input                 stall,
  input  [29:0]         imm30,
  input  [`W_DATA-1:0]  jra,
  input  [`W_JADDR-1:0] jaddr26,
  // control
  input  c_jjr,
  input  c_b,
  input  c_j,
  input  alu_r_z,
  // output
  output [`W_DATA-1:0] imem_addr,
  output [`W_DATA-1:0] jalra,

  input  rst
  );
`include "constant_params.vh"


//
// REGISTERS
//
reg  [`W_DATA-1:0] pc;

//
// WIRES
//
// next_pc mux wires
wire [`W_DATA-1:0] next_pc;
wire [`W_DATA-1:0] pc_4;
wire [`W_DATA-1:0] baddr;
wire [`W_DATA-1:0] jaddr;

// jjr mux
wire [`W_DATA-1:0] jaddr_concat;


//
// ASSIGNMENTS
//
assign pc_4  = pc + 4;
assign jalra = pc + 8;

assign baddr = {imm30, 2'b00} + pc_4;
assign jaddr_concat = {pc_4[31:28], jaddr26, 2'b00};

// jjr mux
assign jaddr =
  (c_jjr == MUX_JADDR) ? jaddr_concat:
  (c_jjr == MUX_JRA  ) ? jra :
                         jaddr_concat;

// next_pc mux
assign next_pc =
  (c_b && !alu_r_z) ? baddr :
  (c_j) ? jaddr :
          pc_4  ;

// our program counter will point to the instruction to fetch/decode
assign imem_addr = pc;


//
// SYNC (async reset)
//
always @(posedge clk or posedge rst)
begin
  if (rst) begin
    pc <= 0;
	 end else if (!stall) begin
    pc <= next_pc;
  end
end

endmodule