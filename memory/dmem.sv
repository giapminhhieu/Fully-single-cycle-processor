//data memory: RAM
module dmem #(parameter WIDTH = 32)
(
	input logic 				clk,
	input logic 				we, //write enable, 0-> read, 1->write
	input logic [WIDTH-1:0] addr, //address, 
	input logic [WIDTH-1:0] wd, //write data, neu we = 1 thi du lieu dc nghi vao bo nho
	
	output logic [WIDTH-1:0] rd // loi ra: read data
);
	logic [WIDTH-1:0] mem [0:255]; // mang 256 o nho, moi o co kich thuoc WIDTH bit
	//chi lay 8 bit do co 225 o nho
	assign rd = mem[addr[9:2]]; // dia chi co gia tri 0 4 8... -> bo 2 bit LSB (chia cho 4)
	
	
	always_ff @(posedge clk) begin
	// neu we = 1-> ghi data tu wd vao mem voi dia chi addr
		if(we) 
			mem[addr[WIDTH-1:2]] <= wd;
	end		
endmodule