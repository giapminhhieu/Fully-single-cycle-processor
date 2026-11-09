`timescale 1ns/1ps

module tb_single_cycle_processor();

    // 1. Khai bao day tin hieu ket noi voi 17 cong cua Top-level
    logic        clk;
    logic        rst_n;
    
    logic [31:0] instruction;
    logic [31:0] result;
    logic [31:0] alu_result;
    logic [3:0]  alu_flags;
    logic [31:0] write_data;
    logic [31:0] pc;
    
    // Tin hieu dieu khien
    logic        pc_src, mem_to_reg, mem_write;
    logic [1:0]  imm_src, reg_src, alu_ctrl;
    logic        alu_src;
    logic        reg_write;
    
    // Du lieu doc tu RAM
    logic [31:0] read_data;

    // 2. Khoi tao DUT (Ket noi day du 100% cac cong de khong bi Warning TFMPC)
    single_cycle_processor_32bit_top dut (
        .clk         (clk),
        .rst_n       (rst_n),
        .instruction (instruction),
        .result      (result),
        .alu_result  (alu_result),
        .alu_flags   (alu_flags),
        .write_data  (write_data),
        .pc          (pc),
        .pc_src      (pc_src),
        .mem_to_reg  (mem_to_reg),
        .mem_write   (mem_write),
        .imm_src     (imm_src),
        .reg_src     (reg_src),
        .alu_ctrl    (alu_ctrl),
        .alu_src     (alu_src),
        .reg_write   (reg_write),
        .read_data   (read_data)
    );

    // 3. Tao xung clock chu ky 40ns (25MHz - Chay tot cho ca RTL va Gate-Level)
    always begin
        clk = 1'b0; #20;
        clk = 1'b1; #20;
    end

    // 4. Kich ban Reset va Gioi han thoi gian mo phong
    initial begin
        rst_n = 1'b0;          // Giu Reset tich cuc muc thap
        #85;                   // Doi qua 2 suon len cua clock (80ns + 5ns)
        rst_n = 1'b1;          // Nha Reset de CPU bat dau chay tu PC = 0x00
        
        #1200;
        $display("------------------------------------------------------------");
        $display("[TIMEOUT] Ket thuc mo phong sau 1200ns.");
        $stop;
    end

    // 5. Theo doi (Monitor) va Tu dong kiem tra ket qua (Self-checking)
    // Su dung @(negedge clk) hoac doi truoc suon len tiep theo khi tin hieu da on dinh
    always @(negedge clk) begin
        if (rst_n) begin
            $display("Time=%0t | PC=%h | Instr=%h | ALURes=%0d | WriteData=%0d | ReadData=%0d | Res=%0d | Flags=%b | RegW=%b | MemW=%b",
                     $time, pc, instruction, alu_result, write_data, read_data, result, alu_flags, reg_write, mem_write);

            // Kiem tra khi co lenh STR ghi xuong Data Memory
            if (mem_write) begin
                $display("   >>> [STR - MEMORY WRITE] Ghi gia tri %0d vao dia chi Byte %0d (0x%h)",
                         write_data, alu_result, alu_result);

                // Neu ghi vao dia chi 100 (0x64) -> Lenh STR cuoi cung cua chuong trinh
                if (alu_result == 32'd100) begin
                    if (write_data == 32'd16) begin
                        $display("============================================================");
                        $display("   [PASS] MO PHONG THANH CONG! Gia tri 16 da duoc ghi vao dia chi 100.");
                        $display("============================================================");
                    end else begin
                        $display("============================================================");
                        $display("   [FAIL] Sai gia tri! Ghi %0d thay vi 16 vao dia chi 100.", write_data);
                        $display("============================================================");
                    end
                    #40;
                    $stop;
                end
            end

            // Hien thi them khi co lenh LDR doc tu Data Memory (mem_to_reg = 1 va reg_write = 1)
            if (mem_to_reg && reg_write) begin
                $display("   <<< [LDR - MEMORY READ]  Doc gia tri %0d tu dia chi Byte %0d (0x%h) nap vao R%0d",
                         read_data, alu_result, alu_result, instruction[15:12]);
            end
        end
    end

endmodule