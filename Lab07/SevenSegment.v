`timescale 1ns / 1ps

module SevenSegment(
    input clk,
    input rst,
    input [15:0] data_in, // Lower 16 bits of ALU result
    output reg [6:0] seg, // Cathodes (a-g)
    output reg [3:0] an   // Anodes to select the active digit
);

    reg [19:0] refresh_counter;
    wire [1:0] digit_select;
    reg [3:0] current_digit;

    // Refresh counter for multiplexing
    always @(posedge clk or posedge rst) begin
        if (rst)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end

    // Use top 2 bits of the counter to select 1 of the 4 digits (approx 95Hz refresh)
    assign digit_select = refresh_counter[19:18];

    // Anode activation and digit routing
    always @(*) begin
        case(digit_select)
            2'b00: begin
                an = 4'b1110; 
                current_digit = data_in[3:0]; // Digit 0 (Rightmost)
            end
            2'b01: begin
                an = 4'b1101; 
                current_digit = data_in[7:4]; // Digit 1
            end
            2'b10: begin
                an = 4'b1011; 
                current_digit = data_in[11:8]; // Digit 2
            end
            2'b11: begin
                an = 4'b0111; 
                current_digit = data_in[15:12]; // Digit 3 (Leftmost)
            end
            default: begin
                an = 4'b1111;
                current_digit = 4'b0000;
            end
        endcase
    end

    // Hex to 7-Segment Decoder (Active Low for Basys 3)
    always @(*) begin
        case(current_digit)
            4'h0: seg = 7'b1000000; // 0
            4'h1: seg = 7'b1111001; // 1
            4'h2: seg = 7'b0100100; // 2
            4'h3: seg = 7'b0110000; // 3
            4'h4: seg = 7'b0011001; // 4
            4'h5: seg = 7'b0010010; // 5
            4'h6: seg = 7'b0000010; // 6
            4'h7: seg = 7'b1111000; // 7
            4'h8: seg = 7'b0000000; // 8
            4'h9: seg = 7'b0010000; // 9
            4'hA: seg = 7'b0001000; // A
            4'hB: seg = 7'b0000011; // b
            4'hC: seg = 7'b1000110; // C
            4'hD: seg = 7'b0100001; // d
            4'hE: seg = 7'b0000110; // E
            4'hF: seg = 7'b0001110; // F
            default: seg = 7'b1111111; // Off
        endcase
    end

endmodule