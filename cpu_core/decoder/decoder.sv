// module decoder ket hop pc logic, main decoder va alu decoder
module decoder(
	input logic [1:0]	op, 	//	[27:26] instruction
	input logic [5:0]	funct,// [25:20] instruction
	input logic [3:0] rd,		// [15:12] instruction
	
	output logic 			pc_s,
	output logic [1:0]	flagW,
	output logic 			reg_write,	
	output logic 			mem_write,	
	output logic 			mem_to_reg,	
	output logic 			alu_src,		
	output logic [1:0]	imm_src,		
	output logic [1:0]	reg_src,
	output logic [1:0]	alu_ctrl	
);
logic branch;
logic alu_op;

	//khai bao main decoder
	main_decoder u_main_decoder(
		.op (op),
		.funct_5 (funct[5]),
		.funct_0 (funct[0]),
		
		.reg_write (reg_write) ,
		.mem_write (mem_write),
		.mem_to_reg (mem_to_reg ),
		.alu_src (alu_src),
		.imm_src (imm_src),
		.reg_src (reg_src),
		.alu_op (alu_op),
		.branch (branch)
	);
	
	//khai bao pc_logic
	pc_logic u_pc_logic(
		.rd (rd),
		.branch (branch),
		.regW (reg_write),
		.pc_s (pc_s)
	);
	
	//khai bao alu_decoder
	alu_decoder u_alu_decoder(
		.alu_op (alu_op),
		.funct (funct[4:0]),
		.alu_ctrl (alu_ctrl),
		.flagW (flagW)
	)

endmodule