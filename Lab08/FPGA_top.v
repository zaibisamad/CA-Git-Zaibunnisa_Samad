`timescale 1ns / 1ps 

module FPGA_top( 
    input clk,          // 100 MHz 
    input btnC,         // write button 
    input [15:0] sw, 
    output [15:0] led 
); 
    // Power-on reset (high for the first 15 clock cycles)
    reg [3:0] por = 4'd0; 
    wire rst = ~&por;           
    always @(posedge clk) 
        if (~&por) por <= por + 4'd1; 
  
    // Button handling 
    wire step;                  
    debouncer db_step ( 
        .clk(clk), 
        .pbin(btnC), 
        .pbout(step) 
    ); 
  
    // Signals mapped from physical switches 
    wire [31:0] address = {22'd0, sw[9:8], sw[7:0]}; 
    wire [31:0] writeData = {27'd0, sw[14:10]}; 
    wire writeEnable = sw[15] & step;    // write only when button is pressed 
    wire readEnable  = 1'b1;             // always reading 
  
    wire [31:0] readData; 
    wire [15:0] leds_reg;    
    
    // Memory system instantiation
    addressDecoderTop mem_sys ( 
        .clk(clk), .rst(rst), 
        .address(address), 
        .readEnable(readEnable), .writeEnable(writeEnable), 
        .writeData(writeData), 
        .switches(sw), 
        .readData(readData), 
        .leds(leds_reg) 
    ); 

    // LED display multiplexer
    assign led = (sw[9:8] == 2'b01) ? leds_reg : readData[15:0]; 
endmodule 
  
module debouncer( 
    input clk, 
    input pbin, 
    output pbout 
); 
    assign pbout = pbin; 
endmodule