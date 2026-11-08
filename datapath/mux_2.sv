module mux_2 
#(parameter WIDTH = 32)(
	input logic [WIDTH-1:0] mux_input_A,
	input logic [WIDTH-1:0] mux_input_B,
	input logic 				mux_ctrl,
	
	output logic [WIDTH-1:0] mux_output
);
// neu ctrl = 1 thi chon B, 0 thi chon A
	assign mux_output = mux_ctrl ? mux_input_B : mux_input_A;
endmodule