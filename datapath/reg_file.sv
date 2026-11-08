module reg_file #(parameter WIDTH = 32) 
(
	input logic clk,
	input logic we3, //write enable, 0 -> doc, 1-> ghi
	
	//co 16 thanh ghi nen chi can 4 bit la bieu dien duoc
	input logic [3:0]  		ra1, ra2, //read address: dia chi thanh ghi de doc 1 va 2
	input logic [3:0]  		wa3, //write address: dia chi thanh ghi can ghi
	input logic [WIDTH-1:0] wd3, // write data: gia tri can ghi
	input logic [WIDTH-1:0] r15, // gia tri thanh ghi 15 (Program counter)
	
	//du lieu ra: read data, rd1 lay du lieu tu dia chi ra1, tuong tu voi ra2
	output logic [WIDTH-1:0] rd1, rd2
);
	logic [WIDTH-1:0] rf [0:14]; //thanh ghi tu 0 den 14 (15 thanh ghi)
	
	always_ff @(posedge clk) begin
		// neu we =1 (ghi) va dia chi thanh ghi khong phai thanh ghi 15 (PC) thi ghi du lieu
		if (we3 && (wa3 != 4'd15))
			rf[wa3] <= wd3;
	end
	
	assign rd1 = (ra1 == 4'd15) ? r15 : rf[ra1];
	assign rd2 = (ra2 == 4'd15) ? r15 : rf[ra2];
endmodule