module control_unit(
	input logic clk,
	input logic rst_n,
	
	input logic [3:0] cond, //[31:28] instruction
	input logic [3:0]	alu_flags,
	
	input logic [1:0]	op, 	//	[27:26] instruction
	input logic [5:0]	funct,// [25:20] instruction
	input logic [3:0] rd,
	
	output logic pc_src,
	output logic reg_write,
	output logic mem_write,
	
	output logic 			mem_to_reg,	
	output logic 			alu_src,		
	output logic [1:0]	imm_src,		
	output logic [1:0]	reg_src,
	output logic [1:0]	alu_ctrl	
);

	logic 		pc_s;
	logic 		reg_w;
	logic 		mem_w;
	logic [1:0]	flagW;
	
	// khai bao decoder
	decoder u_decoder(
		.op (op), 	//	[27:26] instruction
		.funct (funct),// [25:20] instruction
		.rd (rd),		// [15:12] instruction
		.pc_s (pc_s),
		.flagW (flagW),
		.reg_w (reg_w),	
		.mem_w (mem_w),	
		.mem_to_reg (mem_to_reg),	
		.alu_src (alu_src),		
		.imm_src (imm_src),		
		.reg_src (reg_src),
		.alu_ctrl (alu_ctrl)
	);
	
	//khai bao conditional_logic
	conditional_logic u_conditional_logic(
		.clk (clk),
		.rst_n (rst_n),
		.pc_s (pc_s),
		.reg_w (reg_w),
		.mem_w (mem_w),
		.flagW (flagW),
	
		.cond (cond), //[31:28] instruction
		.alu_flags (alu_flags),
		
		.pc_src (pc_src),
		.reg_write (reg_write),
		.mem_write (mem_write)
	);
endmodule