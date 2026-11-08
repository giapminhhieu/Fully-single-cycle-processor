module conditional_check(
	input logic			clk,
	input logic 		rst_n, //reset muc thap, phuc vu mo phong
	input logic [3:0] cond,
	input logic [3:0] alu_flags,
	input logic [1:0]	flagW,
	
	output logic		cond_ex
);
	logic [1:0] flag_write;
	logic [3:0] flags;
	logic       n, z, c, v;
	
	assign {n, z, c, v} = flags;
	assign flag_write = flagW & {2{cond_ex}}; // chi cap nhat co khi cond_ex=1

	always_ff @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			flags <= 4'b0000;
		end
		else begin
			if (flag_write[0]) flags[1:0] <= alu_flags[1:0]; // cap nhat co C, V
			if (flag_write[1]) flags[3:2] <= alu_flags[3:2]; // cap nhat co N, Z
		end
	end

	always_comb begin
		case (cond)
			4'b0000: cond_ex = z;               // EQ: Equal
			4'b0001: cond_ex = ~z;              // NE: Not equal
			4'b0010: cond_ex = c;               // CS/HS: Carry set / Unsigned higher or same
			4'b0011: cond_ex = ~c;              // CC/LO: Carry clear / Unsigned lower
			4'b0100: cond_ex = n;               // MI: Minus / Negative
			4'b0101: cond_ex = ~n;              // PL: Plus / Positive or zero
			4'b0110: cond_ex = v;               // VS: Overflow set
			4'b0111: cond_ex = ~v;              // VC: Overflow clear
			4'b1000: cond_ex = c & ~z;          // HI: Unsigned higher
			4'b1001: cond_ex = ~c | z;          // LS: Unsigned lower or same (Đã sửa lỗi)
			4'b1010: cond_ex = ~(n ^ v);        // GE: Signed greater than or equal
			4'b1011: cond_ex = n ^ v;           // LT: Signed less than
			4'b1100: cond_ex = ~z & ~(n ^ v);   // GT: Signed greater than
			4'b1101: cond_ex = z | (n ^ v);     // LE: Signed less than or equal
			4'b1110: cond_ex = 1'b1;            // AL: Always (Unconditional)
			default: cond_ex = 1'bx;            // Unpredictable (4'b1111)
		endcase
	end

endmodule