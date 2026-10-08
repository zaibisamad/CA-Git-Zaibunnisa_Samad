`timescale 1ns / 1ps

module ALU_tb;

    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] ALUControl;
    wire [31:0] ALUResult;
    wire Zero;

    ALU uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    initial begin
        // Initialize inputs
        A = 32'h00000008; 
        B = 32'h00000002; 
        
        // Test all 7 operations with 10ns intervals 
        ALUControl = 4'b0000; #10; // ADD
        ALUControl = 4'b0001; #10; // SUB
        ALUControl = 4'b0010; #10; // AND
        ALUControl = 4'b0011; #10; // OR
        ALUControl = 4'b0100; #10; // XOR
        ALUControl = 4'b0101; #10; // SLL
        ALUControl = 4'b0110; #10; // SRL
        
        $finish;
    end
endmodule
