`timescale 1ns / 1ps

module top_alu_system (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    wire rst_clean;
    wire [31:0] switch_data;
    reg [31:0] led_write_data;

    // Button Debouncer (Hardware Interface)
    debouncer rst_db (
        .clk(clk), .pbin(pbin), .pbout(rst_clean)
    );

    // Read switches
    leds switch_reader (
        .clk(clk), .rst(rst_clean), .btns(16'd0), .writeData(32'd0),
        .writeEnable(1'b0), .readEnable(1'b1), .memAddress(30'd0),
        .switches(physical_sw), .readData(switch_data)
    );

    // Write to LEDs
    switches led_writer (
        .clk(clk), .rst(rst_clean), .writeData(led_write_data),
        .writeEnable(1'b1), .readEnable(1'b0), .memAddress(30'd0),
        .readData(), .leds(physical_leds)
    );

    // Map First 4 switches (SW3 to SW0) to Operand A
    wire [31:0] operand_a = {28'd0, switch_data[3:0]};
    
    // Map Next 4 switches (SW7 to SW4) to Operand B
    wire [31:0] operand_b = {28'd0, switch_data[7:4]};
    
    wire [31:0] alu_result;
    wire alu_zero;

    // Map Last 4 switches (SW15 to SW12) to ALUControl
    ALU alu_inst (
        .A(operand_a), 
        .B(operand_b),
        .ALUControl(switch_data[15:12]),  
        .ALUResult(alu_result), 
        .Zero(alu_zero)
    );

    // Zero LED Logic & Result Display
    always @(*) begin
        // Padded with 16 zeros to match the 32-bit register width expected by the led_writer
        led_write_data = {16'd0, alu_zero, alu_result[14:0]};
    end

endmodule
