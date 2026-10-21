`timescale 1ns / 1ps

module RF_ALU_FSM_tb;
    reg clk, rst;
    
    // Internal signals controlled by FSM
    reg WriteEnable;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] WriteDataRF;
    wire [31:0] ReadData1, ReadData2;
    reg [3:0] ALUOp;
    wire [31:0] ALUResult;
    wire ZeroFlag;

    // Explicit states to fix the initialization loop
    parameter IDLE = 3'd0, INIT_X1 = 3'd1, INIT_X2 = 3'd2, INIT_X3 = 3'd3, 
              READ_REGISTERS = 3'd4, ALU_OPERATION = 3'd5, WRITE_BACK = 3'd6;
    reg [2:0] state, next_state;
    reg [3:0] op_step;

    RegisterFile rf (
        .clk(clk), .rst(rst), .WriteEnable(WriteEnable),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .WriteData(WriteDataRF),
        .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    // Integrated Lab 6 ALU
    ALU alu_inst (
        .A(ReadData1), .B(ReadData2), .ALUControl(ALUOp),
        .ALUResult(ALUResult), .Zero(ZeroFlag)
    );

    always #5 clk = ~clk;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            op_step <= 0;
        end else begin
            state <= next_state;
            if (state == WRITE_BACK) op_step <= op_step + 1;
        end
    end

    always @(*) begin
        // Default values to prevent latches and 'X' undefined states
        next_state = state;
        WriteEnable = 0;
        rd = 5'd0;
        WriteDataRF = 32'd0;
        rs1 = 5'd1;
        rs2 = 5'd2;
        ALUOp = op_step;

        case (state)
            IDLE: next_state = INIT_X1;
            INIT_X1: begin
                WriteEnable = 1;
                rd = 1; WriteDataRF = 32'h10101010; 
                next_state = INIT_X2;
            end
            INIT_X2: begin
                WriteEnable = 1;
                rd = 2; WriteDataRF = 32'h01010101; 
                next_state = INIT_X3;
            end
            INIT_X3: begin
                WriteEnable = 1;
                rd = 3; WriteDataRF = 32'h00000005; 
                next_state = READ_REGISTERS;
            end
            READ_REGISTERS: begin
                rs1 = 1; rs2 = 2; // Read x1 and x2
                next_state = ALU_OPERATION;
            end
            ALU_OPERATION: begin
                ALUOp = op_step; 
                next_state = WRITE_BACK;
            end
            WRITE_BACK: begin
                WriteEnable = 1;
                rd = 4 + op_step; // Write ALU results to dest registers
                WriteDataRF = ALUResult;
                if (op_step < 7) next_state = READ_REGISTERS; 
                else next_state = IDLE;
            end
        endcase
    end

    initial begin
        clk = 0; rst = 1;
        #15 rst = 0;
        #300 $finish;
    end
endmodule