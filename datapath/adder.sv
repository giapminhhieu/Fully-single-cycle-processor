module adder
#(parameter WIDTH = 32)
(
	input logic  [WIDTH-1:0] adder_input_A,
	input logic  [WIDTH-1:0] adder_input_B,
	
	output logic [WIDTH-1:0] adder_output
);
	assign adder_output = adder_input_A + adder_input_B;
endmodule