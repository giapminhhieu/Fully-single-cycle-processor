module conditional_logic(
	input logic 		clk,
	input logic 		rst_n,
	input logic 		pc_s,
	input logic 		reg_w,
	input logic 		mem_w,
	input logic [1:0]	flagW,
	
	input logic [3:0] cond, //[31:28] instruction
	input logic [3:0]	alu_flags,
	
	output logic pc_src,
	output logic reg_write,
	output logic mem_write
);
logic cond_ex;
	//khai bao conditional check
	conditional_check u_conditional_check(
		.clk (clk),
		.rst_n (rst_n),
		.cond (cond),
		.alu_flags (alu_flags),
		.flagW (flagW),
		.cond_ex (cond_ex)
	);

	assign pc_src = cond_ex & pc_s;
	assign reg_write = cond_ex & reg_w;
	assign mem_write = cond_ex & mem_w;
endmodule