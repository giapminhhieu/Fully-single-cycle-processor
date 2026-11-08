module alu_decoder(
	input logic 		alu_op, 
	// bit [24:21] cua instruction, ma thuc hien ADD, SUB, AND, ORR [4:1]
	// va bit thu 20 (bit S) xac dinh co cap nhat co trang thai hay khong [0]
	input logic [4:0]	funct
	
	output logic [1:0] alu_ctrl,
	output logic [1:0] flagW // tin hieu cho phep ghi co - flag write
);
always_comb begin
	// lenh LDR, STR, B
	if(alu_op == 1'b0) begin
		alu_ctrl = 2'b00;
		flagW = 2'b00;
	end
	else begin
		case (funct[4:1] 
			4'b0100: begin //ADD
				alu_ctrl = 2'b00;
				//cap nhat co NZ va CV neu bit S = 1
				flagW = funct[0] ? 2'b11 : 2'b00;
			end
			
			4'b0010: begin //SUB
				alu_ctrl = 2'b01;
				//cap nhat co NZ va CV neu bit S = 1
				flagW = funct[0] ? 2'b11 : 2'b00;
			end
			
			4'b0000: begin //AND
				alu_ctrl = 2'b10;
				//cap nhat co NZ neu bit S = 1
				flagW = funct[0] ? 2'b10 : 2'b00;
			end
			
			4'b1100: begin //ORR
				alu_ctrl = 2'b11;
				//cap nhat co NZ neu bit S = 1
				flagW = funct[0] ? 2'b10 : 2'b00;
			end
			
			default: begin
				alu_ctrl = 2'b00;
				flagW = 2'b00;
			end
		endcase	
	end
end
	
endmodule