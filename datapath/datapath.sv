// module ket hop cac khoi: reg_file, PC, mux_2, alu, extend,
// nhan tin hieu tu bo giai ma va instrution de thuc hien
module datapath(
	input logic clk,
	input logic [31:0]	instruction,
	input logic 			mem_to_reg,
	input logic 			mem_write,
	input logic [1:0]		alu_ctrl,
	input logic 			alu_src,
	input logic [1:0]		imm_src,
	input logic 			reg_write,
	input logic [1:0]		reg_src,
	input logic 			pc_src,
	input logic				rst_n,//reset
	
	output logic [3:0]	alu_flags,
	output logic [31:0]	result,
	output logic [31:0] 	pc // loi ra pc de dua vao imem
);
	//tin hieu trung gian khac
	logic [3:0] 	RA1, RA2;
	logic [31:0] 	srcA, srcB;
	logic [31:0] 	pc_plus_4, pc_plus_8;
	logic [31:0]	ext_imm;
	logic [31:0]	alu_result;
	
	
	//tin hieu trung gian cho khoi mux
	//loi vao cua mux_aluSrc
	logic [31:0] mux_aluSrc_A; // chinh la RD2
	
	// loi vao cua mux_memToReg
	logic [31:0]	read_data; 
	
	//loi ra cua mux_pcSrc
	logic [31:0] 	pc_next;
	
	// khai bao mux_regSrc1 cho loi vao RA1
	mux_2 #(.WIDTH(4)) mux_reg_src1(
		.mux_input_A (instruction[19:16]),
		.mux_input_B (4'd15),
		.mux_ctrl (reg_src[0]),
		.mux_output (RA1)
	);
	
	// khai bao mux_regSrc2 cho loi vao RA2
	mux_2 #(.WIDTH(4)) mux_reg_src2(
		.mux_input_A (instruction[3:0]),
		.mux_input_B (instruction[15:12]),
		.mux_ctrl (reg_src[1]),
		.mux_output (RA2)
	);
	
	//khai bao mux_aluSrc
	mux_2 #(.WIDTH(32)) mux_alu_src(
		.mux_input_A (mux_aluSrc_A),
		.mux_input_B (ext_imm),
		.mux_ctrl (alu_src),
		.mux_output (srcB)
	);
	
	//khai bao mux memToReg
	mux_2 #(.WIDTH(32)) mux_memToReg(
		.mux_input_A (alu_result),
		.mux_input_B (read_data),
		.mux_ctrl (mem_to_reg),
		.mux_output (result)
	);
	
	//khai bao mux_pcSrc
	mux_2 #(.WIDTH(32)) mux_pcSrc(
		.mux_input_A (pc_plus_4),
		.mux_input_B (result),
		.mux_ctrl (pc_src),
		.mux_output (pc_next)
	);

	//adder pc+4
	adder #(.WIDTH(32)) PCPlus4(
		.adder_input_A (pc),
		.adder_input_B (32'h0000_0004),
		.adder_output (pc_plus_4)
	);
	
	//adder pc+8
	adder #(.WIDTH(32)) PCPlus8(
		.adder_input_A (pc_plus_4),
		.adder_input_B (32'h0000_0004),
		.adder_output (pc_plus_8)
	);
	
	//khai bao PC
	PC #(
		.WIDTH(32),
		.RESET_ADDR(32'h0000_0000)
	) u_PC(
		.clk (clk),
		.rst_n (rst_n),
		.pc_next (pc_next),
		.pc (pc)
	);
	
	//khai bao register file
	reg_file #(.WIDTH(32)) u_reg_file(
	
		.clk (clk),
		.we3 (reg_write),
		//dia chi thanh ghi nguon Rn
		.ra1 (RA1),
		.ra2 (RA2),
		//dia chi thanh ghi dich
		.wa3 (instruction[15:12]),
		//gia tri can ghi lay tu loi ra result
		.wd3 (result),
		.r15 (pc_plus_8),
		.rd1 (srcA),
		//loi ra Rd2 di vao mux_aluSrc
		.rd2 (mux_aluSrc_A)
	);
	
	//khai bao alu
	alu #(.WIDTH(32)) u_alu(
		.alu_ctrl (alu_ctrl),
		.alu_input_A (srcA),
		.alu_input_B (srcB),
		.flags (alu_flags),
		.alu_result (alu_result)
	);

	// khai bao extend imm
	extend u_extend(
		.instr_imm (instruction[23:0]),
		.imm_src (imm_src),
		.ext_imm (ext_imm)
	);
	
	// khai bao data memory
	dmem #(.WIDTH(32)) u_dmem(
		.clk (clk),
		.we (mem_write),
		.addr (alu_result),
		.wd (mux_aluSrc_A),
		.rd (read_data)
	);
	
endmodule