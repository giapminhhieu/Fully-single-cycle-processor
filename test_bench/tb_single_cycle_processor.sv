`timescale 1ns/1ps

module tb_single_cycle_processor();

    logic clk;
    logic rst_n;

    // Goi module Top-level cua ban
    single_cycle_processor_32bit_top dut (
        .clk   (clk),
        .rst_n (rst_n)
    );

    // 1. Tao xung clock chu ky 10ns (Tan so 100MHz)
    always begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end

    // 2. Kich ban khoi dong va Reset
    initial begin
        rst_n = 1'b0;          // Giu Reset tich cuc muc thap
        #22;                   // Doi qua 2 suon len cua clock
        rst_n = 1'b1;          // Nha Reset de CPU bat dau chay tu PC = 0x00
        
        // Gioi han thoi gian chay toi da (300ns) de tranh treo mo phong
        #300;
        $display("------------------------------------------------------------");
        $display("[TIMEOUT] Ket thuc mo phong sau 300ns.");
        $stop;
    end

    // 3. Theo doi (Monitor) va Tu dong kiem tra ket qua (Self-checking)
    always @(negedge clk) begin
        if (rst_n) begin
            $display("Time=%0t | PC=%h | Instr=%h | ALUResult=%0d (0x%h) | Result=%0d | Flags(NZCV)=%b | RegW=%b | MemW=%b",
                     $time,
                     dut.pc,
                     dut.instruction,
                     dut.u_datapath.alu_result,
                     dut.u_datapath.alu_result,
                     dut.result,
                     dut.alu_flags,
                     dut.reg_write,
                     dut.mem_write);

            // Kiem tra khi co lenh STR ghi xuong Data Memory
            if (dut.mem_write) begin
                $display("   >>> [MEMORY WRITE] Ghi gia tri %0d vao dia chi Byte %0d (0x%h)",
                         dut.u_datapath.mux_aluSrc_A,
                         dut.u_datapath.alu_result,
                         dut.u_datapath.alu_result);

                // Neu ghi vao dia chi 100 (0x64) -> Lenh cuoi cung cua chuong trinh test
                if (dut.u_datapath.alu_result == 32'd100) begin
                    if (dut.u_datapath.mux_aluSrc_A == 32'd16) begin
                        $display("============================================================");
                        $display("   [PASS] MO PHONG THANH CONG! Gia tri 16 da duoc ghi vao dia chi 100.");
                        $display("============================================================");
                    end else begin
                        $display("============================================================");
                        $display("   [FAIL] Sai gia tri! Ghi %0d thay vi 16 vao dia chi 100.", dut.u_datapath.mux_aluSrc_A);
                        $display("============================================================");
                    end
                    #20;
                    $stop;
                end
            end
        end
    end

endmodule