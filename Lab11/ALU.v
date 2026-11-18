`timescale 1ns / 1ps

module ALU (
    input wire [31:0] in1,
    input wire [31:0] in2,
    input wire [3:0] alu_control,
    output reg [31:0] result,
    output wire zero
);

    always @(*) begin
        case (alu_control)
            4'b0000: result = in1 & in2;                         // AND
            4'b0001: result = in1 | in2;                         // OR
            4'b0010: result = in1 + in2;                         // ADD
            4'b0011: result = in1 ^ in2;                         // XOR
            4'b0100: result = in1 << in2[4:0];                   // SLL
            4'b0101: result = in1 >> in2[4:0];                   // SRL
            4'b0110: result = in1 - in2;                         // SUB
            4'b0111: result = ($signed(in1) < $signed(in2)) ? 32'd1 : 32'd0; // SLT
            default: result = 32'b0;
        endcase
    end

    assign zero = (result == 32'b0);

endmodule