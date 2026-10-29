`timescale 1ns / 1ps 
 
module ALUControl ( 
    input [1:0] ALUOp, 
    input [2:0] funct3, 
    input funct7_5,         // Bit 5 of funct7 
    output reg [3:0] ALUControl 
); 
 
    always @(*) begin 
        // Default ALU Control code (ADD) 
        ALUControl = 4'b0000; 
 
        case (ALUOp) 
            2'b00: ALUControl = 4'b0000; // ADD (for address calculation in loads/stores) 
            2'b01: ALUControl = 4'b0001; // SUB (for branch comparison in BEQ) 
            2'b10: begin                 // R-type or I-type ALU operations 
                case (funct3) 
                    3'b000: begin 
                        if (funct7_5) 
                            ALUControl = 4'b0001; // SUB (for R-type SUB) 
                        else 
                            ALUControl = 4'b0000; // ADD (for ADD, ADDI) 
                    end 
                    3'b001: ALUControl = 4'b0101; // SLL 
                    3'b101: ALUControl = 4'b0110; // SRL 
                    3'b111: ALUControl = 4'b0010; // AND 
                    3'b110: ALUControl = 4'b0011; // OR 
                    3'b100: ALUControl = 4'b0100; // XOR 
                    default: ALUControl = 4'b0000; 
                endcase 
            end 
            default: ALUControl = 4'b0000; 
        endcase 
    end 
endmodule