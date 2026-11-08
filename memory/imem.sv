module imem (
    input  logic [31:0] addr,   //dia chi lay tu pc
    output logic [31:0] instr   // ma may 32 bit
);

    logic [31:0] rom [0:63];

    initial begin
        $readmemh("memfile.hex", rom);
    end
    assign instr = rom[addr[7:2]]; 

endmodule