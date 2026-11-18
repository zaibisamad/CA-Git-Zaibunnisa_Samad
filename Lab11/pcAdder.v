`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2026 10:09:03 AM
// Design Name: 
// Module Name: pcAdder
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


module pcAdder (
    input wire [31:0] pc,
    output wire [31:0] next_seq_pc
);
    assign next_seq_pc = pc + 32'd4;
endmodule
