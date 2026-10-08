`timescale 1ns / 1ps

module leds (
    input clk,
    input rst,
    input [15:0] btns,
    input [31:0] writeData,
    input writeEnable,
    input readEnable,
    input [29:0] memAddress,
    input [15:0] switches,
    output reg [31:0] readData
);

    always @(posedge clk) begin
        if (rst) begin
            readData <= 32'b0;
        end else if (readEnable) begin
            // Cast physical switches to 32-bit internal data
            readData <= {16'b0, switches};
        end
    end

endmodule
