`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2026 10:07:41 AM
// Design Name: 
// Module Name: ProgramCounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ProgramCounter(
   
    input wire clk,
    input wire reset,
    input wire [31:0] next_pc,
    output reg [31:0] pc
);
    always @(posedge clk) begin
        if (reset)
            pc <= 32'b0;
        else
            pc <= next_pc;
    end

endmodule
