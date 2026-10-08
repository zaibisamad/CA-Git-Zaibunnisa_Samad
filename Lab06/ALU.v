`timescale 1ns / 1ps

module ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUControl,
    output reg [31:0] ALUResult,
    output Zero
);

    always @(*) begin
        case (ALUControl)
            4'b0000: ALUResult = A + B;       // ADD
            4'b0001: ALUResult = A - B;       // SUB
            4'b0010: ALUResult = A & B;       // AND
            4'b0011: ALUResult = A | B;       // OR
            4'b0100: ALUResult = A ^ B;       // XOR
            4'b0101: ALUResult = A << B;      // SLL
            4'b0110: ALUResult = A >> B;      // SRL
            default: ALUResult = 32'b0;
        endcase
    end
    
    // Zero flag is true (1) when ALUResult is exactly 0
    assign Zero = (ALUResult == 32'b0);

endmodule
