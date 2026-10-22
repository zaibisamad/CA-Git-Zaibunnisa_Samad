`timescale 1ns / 1ps 

module addressDecoderTop( 
    input clk, rst, 
    input [31:0] address, 
    input readEnable, writeEnable, 
    input [31:0] writeData, 
    input [15:0] switches, 
    output [31:0] readData, 
    output [15:0] leds 
);     
    wire [9:0] addr10 = address[9:0]; 
  
    wire DataMemWrite, DataMemRead, LEDWrite, SwitchReadEnable; 
  
    AddressDecoder dec ( 
        .sel(addr10[9:8]), 
        .MemRead(readEnable), 
        .MemWrite(writeEnable), 
        .DataMemWrite(DataMemWrite), 
        .DataMemRead(DataMemRead), 
        .LEDWrite(LEDWrite), 
        .SwitchReadEnable(SwitchReadEnable) 
    ); 
  
    wire [31:0] mem_rdata, sw_rdata; 
  
    DataMemory dmem ( 
        .clk(clk), 
        .MemWrite(DataMemWrite), 
        .address(addr10[8:0]), 
        .write_data(writeData), 
        .read_data(mem_rdata) 
    ); 
  
    led_module led_if ( 
        .clk(clk), 
        .rst(rst), 
        .writeData(writeData), 
        .writeEnable(LEDWrite), 
        .leds(leds) 
    ); 
  
    switch_module sw_if ( 
        .readEnable(SwitchReadEnable), 
        .switches(switches), 
        .readData(sw_rdata) 
    ); 
  
    assign readData = DataMemRead      ? mem_rdata : 
                      SwitchReadEnable ? sw_rdata  : 
                      32'b0; 
endmodule