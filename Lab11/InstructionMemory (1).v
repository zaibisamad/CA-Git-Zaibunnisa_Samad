`timescale 1ns / 1ps

module InstructionMemory (
    input wire [31:0] read_addr,
    output reg [31:0] inst
);

    reg [31:0] memory [0:63];
    integer i;

    initial begin
        // Default initialization so synthesis retains logic even without a .mem file
        for (i = 0; i < 64; i = i + 1)
            memory[i] = 32'h00000013; // NOP (addi x0, x0, 0)

        // Sample test instructions (addi, sw, lw, add, beq)
        memory[0] = 32'h00500093; // addi x1, x0, 5
        memory[1] = 32'h00A00113; // addi x2, x0, 10
        memory[2] = 32'h002081B3; // add  x3, x1, x2
        memory[3] = 32'h00302023; // sw   x3, 0(x0)
        memory[4] = 32'h00002203; // lw   x4, 0(x0)
        memory[5] = 32'hFE0006E3; // beq  x0, x0, -4

        // Uncomment the line below if loading your Lab 10 hex file:
        // $readmemh("lab10.mem", memory);
    end

    always @(*) begin
        inst = memory[read_addr[7:2]]; // Divide byte address by 4
    end

endmodule