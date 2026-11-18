`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2026 10:10:00 AM
// Design Name: 
// Module Name: branchAdder
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


module branchAdder (
    input wire [31:0] pc,
    input wire [31:0] imm,
    output wire [31:0] branch_target
);
    assign branch_target = pc + (imm << 1);
endmodule
