`timescale 1ns / 1ps

module instructionMemory_tb;

    reg [31:0] instAddress;
    wire [31:0] instruction;

    // Instantiate the Instruction Memory module
    instructionMemory #(
        .OPERAND_LENGTH(31)
    ) uut (
        .instAddress(instAddress),
        .instruction(instruction)
    );

    integer i;

    initial begin
        instAddress = 0;
        #10;

        // Step through all 52 instructions (PC increments by 4 bytes each step)
        for (i = 0; i < 52; i = i + 1) begin
            instAddress = i * 4;
            #10;
            $display("PC = 0x%08h | Instruction = 0x%08h", instAddress, instruction);
        end

        $finish;
    end

endmodule