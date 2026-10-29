`timescale 1ns / 1ps 
 
module Control_tb; 
 
    reg [6:0] opcode; 
    reg [2:0] funct3; 
    reg funct7_5; 
 
    wire RegWrite; 
    wire [1:0] ALUOp_out; 
    wire MemRead; 
    wire MemWrite; 
    wire ALUSrc; 
    wire MemtoReg; 
    wire Branch; 
    wire [3:0] ALUControl_out; 
 
    // Instantiate Main Control Unit 
    MainControl uut_main ( 
        .opcode(opcode), 
        .RegWrite(RegWrite), 
        .ALUOp(ALUOp_out), 
        .MemRead(MemRead), 
        .MemWrite(MemWrite), 
        .ALUSrc(ALUSrc), 
        .MemtoReg(MemtoReg), 
        .Branch(Branch) 
    ); 
 
    // Instantiate ALU Control Unit 
    ALUControl uut_alu ( 
        .ALUOp(ALUOp_out), 
        .funct3(funct3), 
        .funct7_5(funct7_5), 
        .ALUControl(ALUControl_out) 
    ); 
 
    initial begin 
        // Initialize inputs 
        opcode   = 7'b0; 
        funct3   = 3'b0; 
        funct7_5 = 1'b0; 
 
        #15; 
        // 1. ADD 
        opcode = 7'b0110011; funct3 = 3'b000; funct7_5 = 1'b0; 
        #10; 
        // 2. ADDI 
        opcode = 7'b0010011; funct3 = 3'b000; funct7_5 = 1'b0; 
        #10; 
        // 3. SUB 
        opcode = 7'b0110011; funct3 = 3'b000; funct7_5 = 1'b1; 
        #10; 
        // 4. SLL 
        opcode = 7'b0110011; funct3 = 3'b001; funct7_5 = 1'b0; 
        #10; 
        // 5. SRL 
        opcode = 7'b0110011; funct3 = 3'b101; funct7_5 = 1'b0; 
        #10; 
        // 6. AND 
        opcode = 7'b0110011; funct3 = 3'b111; funct7_5 = 1'b0; 
        #10; 
        // 7. OR 
        opcode = 7'b0110011; funct3 = 3'b110; funct7_5 = 1'b0; 
        #10; 
        // 8. XOR 
        opcode = 7'b0110011; funct3 = 3'b100; funct7_5 = 1'b0; 
        #10; 
        // 9. LW 
        opcode = 7'b0000011; funct3 = 3'b010; funct7_5 = 1'b0; 
        #10; 
        // 10. LH 
        opcode = 7'b0000011; funct3 = 3'b001; funct7_5 = 1'b0; 
        #10; 
        // 11. LB 
        opcode = 7'b0000011; funct3 = 3'b000; funct7_5 = 1'b0; 
        #10; 
        // 12. SW 
        opcode = 7'b0100011; funct3 = 3'b010; funct7_5 = 1'b0; 
        #10; 
        // 13. SH 
        opcode = 7'b0100011; funct3 = 3'b001; funct7_5 = 1'b0; 
        #10; 
        // 14. SB 
        opcode = 7'b0100011; funct3 = 3'b000; funct7_5 = 1'b0; 
        #10; 
        // 15. BEQ 
        opcode = 7'b1100011; funct3 = 3'b000; funct7_5 = 1'b0; 
 
        #20; 
        $finish; 
    end 
endmodule