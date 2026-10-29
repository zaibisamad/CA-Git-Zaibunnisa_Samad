`timescale 1ns / 1ps 
 
module MainControl ( 
    input [6:0] opcode, 
    output reg RegWrite, 
    output reg [1:0] ALUOp, 
    output reg MemRead, 
    output reg MemWrite, 
    output reg ALUSrc, 
    output reg MemtoReg, 
    output reg Branch 
); 
 
    always @(*) begin 
        // Default safe values (prevents latches and handles don't-cares) 
        RegWrite = 1'b0; 
        ALUOp    = 2'b00; 
        MemRead  = 1'b0; 
        MemWrite = 1'b0; 
        ALUSrc   = 1'b0; 
        MemtoReg = 1'b0; 
        Branch   = 1'b0; 
 
        case (opcode) 
            7'b0110011: begin // R-type (ADD, SUB, SLL, SRL, AND, OR, XOR) 
                RegWrite = 1'b1; 
                ALUOp    = 2'b10; 
            end 
            7'b0010011: begin // I-type ALU (ADDI) 
                RegWrite = 1'b1; 
                ALUSrc   = 1'b1; 
                ALUOp    = 2'b10; 
            end 
            7'b0000011: begin // I-type Load (LW, LH, LB) 
                RegWrite = 1'b1; 
                ALUSrc   = 1'b1; 
                MemRead  = 1'b1; 
                MemtoReg = 1'b1; 
                ALUOp    = 2'b00; 
            end 
            7'b0100011: begin // S-type Store (SW, SH, SB) 
                ALUSrc   = 1'b1; 
                MemWrite = 1'b1; 
                ALUOp    = 2'b00; 
            end 
            7'b1100011: begin // B-type Branch (BEQ) 
                Branch   = 1'b1; 
                ALUOp    = 2'b01; 
            end 
            default: begin 
                // Retains default safe values 
            end 
        endcase 
    end 
endmodule