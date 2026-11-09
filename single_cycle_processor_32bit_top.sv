module single_cycle_processor_32bit_top(
	input logic clk,
	input logic rst_n,
	
   output logic [31:0] instruction,
   output logic [31:0] result,
	
	output logic [31:0] alu_result,
	output logic [3:0]  alu_flags,
	output logic [31:0] write_data,
	output logic [31:0] pc,
		// tin hieu dieu khien
	output logic        pc_src, mem_to_reg, mem_write,			
	output logic [1:0]  imm_src, reg_src, alu_ctrl,
   output logic        alu_src,
	output logic		  	 reg_write,
	
	//du lieu doc tu ram
	output logic [31:0] read_data
);
	// khai bao rom
	imem #(
		.WIDTH(32),
		.DEPTH(64)
	) u_imem(
		.addr (pc),
		.instr (instruction));
	
	// khai bao ram
	dmem #(.WIDTH(32)) u_dmem(
		.clk (clk),
		.we (mem_write),
		.addr (alu_result),
		.wd (write_data),
		.rd (read_data)
	);
	
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
		.alu_ctrl   (alu_ctrl),
		.alu_src    (alu_src),
		.imm_src    (imm_src),
		.reg_write  (reg_write),
		.reg_src    (reg_src),
		.pc_src     (pc_src),
		.mem_to_reg (mem_to_reg),
		.read_data (read_data),
		
		.result     (result),
		.pc         (pc),
		.alu_flags  (alu_flags),
		.alu_result (alu_result),
		.write_data (write_data)
	);
endmodule