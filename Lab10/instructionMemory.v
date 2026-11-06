`timescale 1ns / 1ps

module instructionMemory #(
    parameter OPERAND_LENGTH = 31
)(
    input [OPERAND_LENGTH:0] instAddress,
    output reg [31:0] instruction
);

    // FIXED: Now holds full 32-bit instructions to prevent truncation
    reg [31:0] memory [0:255];

    initial begin
        $readmemh("lab10.mem", memory);
    end

    always @(*) begin
        // FIXED: Shift byte address right by 2 (divide by 4) to fetch the correct 32-bit word
        instruction = memory[instAddress >> 2];
    end

endmodule