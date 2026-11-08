//program counter, thanh ghi R15
module PC #(
	parameter WIDTH = 32,
	parameter RESET_ADDR = 32'h0000_0000
)(
	input logic 				clk,
	input logic 				rst_n,// reset muc thap
	input logic [WIDTH-1:0] pc_next, //dia chi lenh tiep theo
	
	output logic [WIDTH-1:0] pc
);

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		pc <= RESET_ADDR;
	end
	else begin
		pc <= pc_next;
	end
end
endmodule