`timescale 1ns / 1ps

module DataMemory (
    input wire clk,
    input wire mem_write,
    input wire mem_read,
    input wire [31:0] address,
    input wire [31:0] write_data,
    output wire [31:0] read_data
);

    reg [31:0] memory [0:63];
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1)
            memory[i] = 32'b0;
    end

    // Synchronous write
    always @(posedge clk) begin
        if (mem_write) begin
            memory[address[7:2]] <= write_data;
        end
    end

    // Asynchronous read
    assign read_data = mem_read ? memory[address[7:2]] : 32'b0;

endmodule