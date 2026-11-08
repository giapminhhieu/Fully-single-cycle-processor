module imem #(
	parameter WIDTH   = 32,
	parameter DEPTH   = 64               // so lenh toi da
)(
    input  logic [WIDTH-1:0] addr,   //dia chi lay tu pc
    output logic [WIDTH-1:0] instr   // ma may 32 bit
);

    logic [31:0] rom [0:DEPTH-1];

    initial begin
		for (int i = 0; i < DEPTH; i++) rom[i] = '0; // o chua dung = 0, tranh gia tri x
      $readmemh("memfile.dat", rom);
    end
    assign instr = rom[addr[$clog2(DEPTH)+1:2]]; 

endmodule