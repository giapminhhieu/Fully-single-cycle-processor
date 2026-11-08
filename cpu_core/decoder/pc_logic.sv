module pc_logic (
	input logic [3:0]	rd,
	input logic 		branch,
	input logic 		regW,
	output logic 		pc_s
);
	// pc_src = 1 khi thanh ghi R15 duoc ghi boi instruction hoac re nhanh
	assign pc_s = ((rd == 4'b1111) & regW | branch);
endmodule