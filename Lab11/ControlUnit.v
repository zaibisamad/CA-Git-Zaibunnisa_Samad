`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2026 10:15:10 AM
// Design Name: 
// Module Name: ControlUnit
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


`timescale 1ns / 1ps

module ControlUnit (
    input wire [31:0] inst,
    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write,
    output reg [3:0] alu_control
);

    wire [6:0] opcode = inst[6:0];
    wire [2:0] funct3 = inst[14:12];
    wire funct7_b5    = inst[30];

    reg [1:0] alu_op;

    // Main Control Logic (Lab 9 Truth Table)
    always @(*) begin
        branch     = 1'b0;
        mem_read   = 1'b0;
        mem_to_reg = 1'b0;
        mem_write  = 1'b0;
        alu_src    = 1'b0;
        reg_write  = 1'b0;
        alu_op     = 2'b00;

        case (opcode)
            7'b0110011: begin // R-Type (add, sub, and, or, xor, sll, srl)
                reg_write = 1'b1;
                alu_src   = 1'b0;
                alu_op    = 2'b10;
            end
            7'b0010011: begin // I-Type ALU (addi, andi, ori, xori, slli, srli)
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b10;
            end
            7'b0000011: begin // Load (lw)
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                mem_read   = 1'b1;
                mem_to_reg = 1'b1;
                alu_op     = 2'b00;
            end
            7'b0100011: begin // Store (sw)
                alu_src   = 1'b1;
                mem_write = 1'b1;
                alu_op    = 2'b00;
            end
            7'b1100011: begin // Branch (beq, bne)
                branch = 1'b1;
                alu_op = 2'b01;
            end
            default: begin
                branch     = 1'b0;
                mem_read   = 1'b0;
                mem_to_reg = 1'b0;
                mem_write  = 1'b0;
                alu_src    = 1'b0;
                reg_write  = 1'b0;
                alu_op     = 2'b00;
            end
        endcase
    end

    // ALU Control Logic (Lab 9 Truth Table)
    always @(*) begin
        case (alu_op)
            2'b00: alu_control = 4'b0010; // lw/sw -> ADD
            2'b01: alu_control = 4'b0110; // beq   -> SUB
            2'b10: begin                  // R-Type / I-Type
                case (funct3)
                    3'b000: begin
                        // Subtract only if R-type (opcode[5] == 1) and funct7[5] == 1
                        if (opcode[5] && funct7_b5)
                            alu_control = 4'b0110; // SUB
                        else
                            alu_control = 4'b0010; // ADD / ADDI
                    end
                    3'b111: alu_control = 4'b0000; // AND / ANDI
                    3'b110: alu_control = 4'b0001; // OR  / ORI
                    3'b100: alu_control = 4'b0011; // XOR / XORI
                    3'b001: alu_control = 4'b0100; // SLL / SLLI
                    3'b101: alu_control = 4'b0101; // SRL / SRLI
                    3'b010: alu_control = 4'b0111; // SLT / SLTI
                    default: alu_control = 4'b0010;
                endcase
            end
            default: alu_control = 4'b0010;
        endcase
    end

endmodule
