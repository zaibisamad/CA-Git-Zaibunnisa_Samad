`timescale 1ns / 1ps

module top_rf_alu(
    input clk,
    input rst_btn,         // Mapped to central button (btnC)
    input [15:0] sw,       // Mapped to all 16 physical switches
    output [15:0] leds,    // Mapped to all 16 physical LEDs
    output [6:0] seg,      // Mapped to 7-segment display segments
    output [3:0] an        // Mapped to 7-segment display anodes
);
    
    // --- 1. Reset Debouncer ---
    wire rst_clean;
    debouncer db_rst (
        .clk(clk),
        .pbin(rst_btn),
        .pbout(rst_clean)
    );

    // --- 2. Switch Assignments ---
    wire manual_mode = sw[15];       // Switch 15: 0 = Auto FSM, 1 = Manual Mode
    wire manual_we   = sw[14];       // Switch 14: Manual Write Enable
    wire [4:0] manual_rd = sw[13:9]; // Switches 13-9: Manual Destination Register
    wire [3:0] manual_alu = sw[3:0]; // Switches 3-0: Manual ALU Operation

    // --- 3. 1-Second Clock Divider ---
    reg [26:0] tick_cnt = 0;
    wire tick = (tick_cnt == 27'd99_999_999); // 1-second pulse at 100MHz

    always @(posedge clk or posedge rst_clean) begin
        if (rst_clean)
            tick_cnt <= 0;
        else if (tick)
            tick_cnt <= 0;
        else
            tick_cnt <= tick_cnt + 1;
    end

    // --- 4. Auto-Mode FSM Variables ---
    parameter IDLE = 3'd0, INIT_X1 = 3'd1, INIT_X2 = 3'd2, 
              READ_REGS = 3'd3, ALU_OP = 3'd4, WRITE_BACK = 3'd5;
    
    reg [2:0] auto_state;
    reg [2:0] op_idx; // Cycles through ALU operations 0 to 7
    reg auto_we;
    reg [4:0] auto_rd;
    reg [31:0] auto_write_data;
    reg [3:0] auto_alu_ctrl;

    wire [4:0] rs1 = 5'd1; // Auto mode always reads from x1
    wire [4:0] rs2 = 5'd2; // Auto mode always reads from x2

    // --- 5. FSM Logic (Advances once per second) ---
    always @(posedge clk or posedge rst_clean) begin
        if (rst_clean) begin
            auto_state <= IDLE;
            op_idx <= 0;
            auto_we <= 0;
        end else if (tick) begin
            case (auto_state)
                IDLE: begin
                    auto_we <= 0;
                    auto_state <= INIT_X1;
                end
                INIT_X1: begin
                    auto_we <= 1;
                    auto_rd <= 5'd1;
                    auto_write_data <= 32'h10101010; // Load Constant A[cite: 4]
                    auto_state <= INIT_X2;
                end
                INIT_X2: begin
                    auto_we <= 1;
                    auto_rd <= 5'd2;
                    auto_write_data <= 32'h01010101; // Load Constant B[cite: 4]
                    auto_state <= READ_REGS;
                end
                READ_REGS: begin
                    auto_we <= 0;
                    auto_state <= ALU_OP;
                end
                ALU_OP: begin
                    auto_alu_ctrl <= {1'b0, op_idx}; // Map 0-7 to ALU operations
                    auto_state <= WRITE_BACK;
                end
                WRITE_BACK: begin
                    auto_we <= 1;
                    auto_rd <= 5'd4 + {2'b00, op_idx}; // Write to x4, x5, etc.[cite: 2]
                    auto_write_data <= (op_idx == 3'd7) ? {31'd0, Zero} : ALUResult;
                    
                    if (op_idx == 3'd7) begin // If all ops done, loop back
                        op_idx <= 0;
                        auto_state <= IDLE;
                    end else begin
                        op_idx <= op_idx + 1;
                        auto_state <= READ_REGS;
                    end
                end
                default: auto_state <= IDLE;
            endcase
        end
    end

    // --- 6. Hardware Multiplexers (Auto vs Manual) ---
    wire [3:0]  final_alu_ctrl = manual_mode ? manual_alu : auto_alu_ctrl;
    wire [4:0]  final_rd       = manual_mode ? manual_rd  : auto_rd;
    wire        final_we       = manual_mode ? manual_we  : auto_we;
    wire [31:0] final_write    = manual_mode ? ALUResult  : auto_write_data;

    wire [31:0] ReadData1, ReadData2, ALUResult;
    wire Zero;

    // --- 7. Instantiate Register File and ALU ---
    RegisterFile rf (
        .clk(clk), .rst(rst_clean), .WriteEnable(final_we),
        .rs1(rs1), .rs2(rs2), .rd(final_rd),
        .WriteData(final_write),
        .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    ALU alu_inst (
        .A(ReadData1), .B(ReadData2), .ALUControl(final_alu_ctrl),
        .ALUResult(ALUResult), .Zero(Zero)
    );

    // --- 8. Outputs (LEDs and 7-Segment) ---
    // LED 15 shows mode. LEDs 14-12 show FSM State. LEDs 7-0 show lower ALU Result.[cite: 4]
    assign leds = {manual_mode, auto_state, 4'b0000, ALUResult[7:0]};

    SevenSegment disp (
        .clk(clk),
        .rst(rst_clean),
        .data_in(ALUResult[15:0]), // Visually displays calculated result
        .seg(seg),
        .an(an)
    );

endmodule