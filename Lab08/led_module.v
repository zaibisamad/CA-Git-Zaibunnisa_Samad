`timescale 1ns / 1ps 

module led_module( 
    input clk, rst, 
    input [31:0] writeData, 
    input writeEnable, 
    output reg [15:0] leds 
); 
    always @(posedge clk) begin 
        if (rst) leds <= 16'b0; 
        else if (writeEnable) leds <= writeData[15:0]; 
    end 
endmodule