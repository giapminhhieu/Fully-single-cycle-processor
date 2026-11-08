// khoi mo rong bit
module extend(
	input logic [23:0] instr_imm, //hang so tu instruction, so bit lon nhat la 24
	input logic [1:0]	 imm_src, // tin hieu dieu khien
	
	output logic [31:0] ext_imm
);
always_comb begin
	// khoi extend trong single cycle cpu khong thuc hien phep xoay bit
	// do lam tang chu ki xung nhip
	case(imm_src)
		// Data processing: mo rong khong dau (Zero Extend) 8 bit len 32 bit
		2'b00: ext_imm = {24'b0, instr_imm[7:0]};
		
		// LDR, STR: mo rong khong dau (Zero Extend) 12 bit len 32 bit
		2'b01: ext_imm = {20'b0, instr_imm[11:0]};
		
		// Branch: mo rong co dau (sign-extend) 24 bit len 32 bit vaf dich trai 2 bit
		2'b10: ext_imm = {{6{instr_imm[23]}}, instr_imm[23:0], 2'b00};
		
		default: ext_imm = 32'bx;
	endcase	
end
endmodule