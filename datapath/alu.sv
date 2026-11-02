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
0110	SLL	Dịch trái logic
0111	SRL	Dịch phải logic
1000	SRA	Dịch phải số học
1001	SLT	So sánh A < B
*/
	logic n, z, c, v; //flags
	logic [WIDTH:0] add_extended;

always_comb begin
	alu_result = 0;
	c = 1'b0;
	v = 1'b0;
	
	//Cong hoac tru
	case (alu_ctrl == 4'b0000 || alu_ctrl == 4'b0001)

		//neu nhu la phep tru (alu_ctrl[0] == 1) thi dao bit B
		logic [WIDTH:0] alu_input_B_mux = alu_ctrl[0] ? ~{1'b0, alu_input_B} : {1'b0, alu_input_B},
		
		add_extended = {1'b0, alu_input_A} + alu_input_B_mux + alu_ctr[0],
		alu_result = add_extended[WIDTH-1:0], 
		
		c = add_extended[WIDTH],
		v = ~(alu_input_A[WIDTH-1] ^ alu_input_B_mux[WIDTH-1]) & 
		(alu_result[WIDTH-1] ^ alu_input_A[WIDTH-1]),
	case ()
	
	end
endmodule