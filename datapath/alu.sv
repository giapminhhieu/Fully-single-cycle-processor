module alu
#(parameter WIDTH = 32)
(
	//
	input logic  [3:0] alu_ctrl, 
	
	input logic  [WIDTH-1:0] alu_input_A,
	input logic  [WIDTH-1:0] alu_input_B,
	
	output logic [3:0]		 flags, //[N,Z,C,V]
	output logic [WIDTH-1:0] alu_result
);

/*
0000	ADD	A + B
0001	SUB	A - B
0010	AND	A AND B
0011	OR	A OR B
0100	XOR	A XOR B
0101	NOR	NOT (A OR B)
0110	SLL	Dịch trái logic (Shift Left Logic)
0111	SRL	Dịch phải logic
1000	SRA	Dịch phải số học
1001	SLT	So sánh A < B
*/
	logic n, z, c, v; //flags
	logic [WIDTH:0] add_extended;
	logic [WIDTH-1:0] B_mux;

always_comb begin
	alu_result = '0;
	c = 1'b0;
	v = 1'b0;
	
	// neu bit cuoi cung cua alu_ctrl la 1 thi B_mux dao bit
	B_mux = alu_ctrl[0] ? ~alu_input_B : alu_input_B;
	
	//gop phep cong va phep tru vao 1
	add_extended = {1'b0, alu_input_A} + {1'b0, B_mux} + alu_ctrl[0];
	
	
	case (alu_ctrl)
	
		//Cong hoac tru
		4'b0000, 4'b0001: begin
		
			alu_result = add_extended[WIDTH-1:0];
			c = add_extended[WIDTH];
			v = ~(alu_input_A[WIDTH-1] ^ alu_input_B_mux[WIDTH-1]) & 
			(alu_result[WIDTH-1] ^ alu_input_A[WIDTH-1]);
			
		end
		
		// AND
		4'b0010: begin
			alu_result = alu_input_A & alu_input_B;
		end
		
		//OR
		4'b0011: begin
			alu_result = alu_input_A | alu_input_B;
		end
		
		//XOR
		4'b0100: begin
			alu_result = alu_input A ^ alu_input_B;
		end
		
		//NOR
		4'b0101: begin
			alu_result = ~(alu_input A | alu_input_B)
		end
		
		//SLL
		4'b0110: begin
		
		end
		
		//SRL
		4'b0111: begin
		
		end
		
		//SRA
		4'b1000: begin
		
		end
		
		//STL
		4'b1001: begin
			alu_result = {{(WIDTH-1){1'b0}}, add_extended[WIDTH-1] ^ v};
		end
		
		flags = {n, z, c, v};
	end
endmodule