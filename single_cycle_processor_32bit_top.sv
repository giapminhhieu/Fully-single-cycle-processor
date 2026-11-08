module single_cycle_processor_32bit_top(
	input logic clk,
	input logic rst_n
);
	logic [31:0] pc, instruction, result;
	logic [3:0]  alu_flags;
	logic        pc_src, reg_write, mem_write, mem_to_reg, alu_src;
	logic [1:0]  imm_src, reg_src, alu_ctrl;
	
// khai bao rom
	imem u_imem(
	.addr (pc),
	.instr (instruction));
	
// khai bao control unit
	control_unit u_control_unit(
		.clk        (clk),
		.rst_n      (rst_n),
		.cond       (instruction[31:28]),
		.alu_flags  (alu_flags),
		.op         (instruction[27:26]),
		.funct      (instruction[25:20]),
		.rd         (instruction[15:12]),
		.pc_src     (pc_src),
		.reg_write  (reg_write),
		.mem_write  (mem_write),
		.mem_to_reg (mem_to_reg),
		.alu_src    (alu_src),
		.imm_src    (imm_src),
		.reg_src    (reg_src),
		.alu_ctrl   (alu_ctrl)
	);

//khai bao datapath
	datapath u_datapath(
		.clk        (clk),
		.rst_n      (rst_n),
		.instruction(instruction),
		.mem_to_reg (mem_to_reg),
		.mem_write  (mem_write),
		.alu_ctrl   (alu_ctrl),
		.alu_src    (alu_src),
		.imm_src    (imm_src),
		.reg_write  (reg_write),
		.reg_src    (reg_src),
		.pc_src     (pc_src),
		.alu_flags  (alu_flags),
		.result     (result),
		.pc         (pc)
	);
endmodule