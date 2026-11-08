module main_decoder(
	input logic [1:0]	op; // bit [27:26] cua instruction
	// bit [25:20] cua instruction, 
	// trong main_decoder chi su dung bit so 25 va 20
	input logic funct_5,
	input logic funct_0,
											//[9:0] ctrl
	output logic 			reg_write,	//9
	output logic 			mem_write,	//8
	output logic 			mem_to_reg,	//7
	output logic 			alu_src,		//6
	output logic [1:0]	imm_src,		//[5:4]
	output logic [1:0]	reg_src,		//[3:2]
	output logic 			alu_op,		//1
	output logic 			branch		//0
);


logic [9:0] ctrl;
always_comb begin
	case(op)
		2'b00: begin //data processing
			if(funct_5) begin
//reg_write=1, mem_write=0, mem_to_reg=0, alu_src=1, imm_src=00, reg_src=x0, alu_op=1, branch=0
				ctrl = 10'b1_0_0_1_00_00_1_0;
			end
			else begin
//reg_write=1, mem_write=0, mem_to_reg=0, alu_src=0, imm_src=00, reg_src=x0, alu_op=1, branch=0
				ctrl = 10'b1_0_0_0_00_00_1_0;
			end
		end
		
		2'b01: begin//memory (LDR,STR)
			if(funct_0) begin //LDR
//reg_write=1, mem_write=0, mem_to_reg=1, alu_src=1, imm_src=01, reg_src=x0, alu_op=0, branch=0
				ctrl = 10'b1_0_1_1_01_00_0_0;
			end
			else begin //STR
//reg_write=1, mem_write=1, mem_to_reg=x, alu_src=1, imm_src=01, reg_src=10, alu_op=0, branch=0
				ctrl = 10'b1_1_0_1_01_10_1_0;
			end
		end
		
		2'b10: begin //branch
//reg_write=0, mem_write=0, mem_to_reg=0, alu_src=1, imm_src=10, reg_src=x1, alu_op=0, branch=1
			ctrl = 10'b0_0_0_1_10_01_0_1;
		end
		
		default: begin
			ctrl = 10'b0_0_0_0_00_00_0_0;
		end
	endcase
end

assign {reg_write, mem_write, mem_to_reg, alu_src, imm_src, reg_src, alu_op, branch} = ctrl;
		
endmodule