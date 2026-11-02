module alu
#(parameter WIDTH = 32)
(
	//
	input logic  [1:0] alu_ctrl, 	
	input logic  [WIDTH-1:0] alu_input_A,
	input logic  [WIDTH-1:0] alu_input_B,
	
	output logic [3:0]		 flags, //[N,Z,C,V]
	output logic [WIDTH-1:0] alu_result
);

/*
0000	ADD	A + B
0001	SUB	A - B
0010	AND	A AND B
0011	ORR		A OR B
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
		2'b00, 2'b01: begin
			alu_result = add_extended[WIDTH-1:0];
			c = add_extended[WIDTH];
			v = ~(alu_input_A[WIDTH-1] ^ B_mux[WIDTH-1]) & 
			(alu_result[WIDTH-1] ^ alu_input_A[WIDTH-1]);
		end
		
		// AND
		2'b10: alu_result = alu_input_A & alu_input_B;
		
		//ORR
		2'b11: alu_result = alu_input_A | alu_input_B;
		
		default: begin
			alu_result = '0;
			c = 1'b0;
			v = 1'b0;
		end
	endcase
		
		n = alu_result[WIDTH -1];
		z = (alu_result == '0);
		flags = {n, z, c, v};
	end
endmodule