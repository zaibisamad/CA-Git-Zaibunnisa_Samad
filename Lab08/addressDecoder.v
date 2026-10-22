`timescale 1ns / 1ps 

module AddressDecoder ( 
    input [1:0] sel,               
    input MemRead, 
    input MemWrite, 
    output DataMemWrite, 
    output DataMemRead, 
    output LEDWrite, 
    output SwitchReadEnable 
); 
    wire DataMemSelect = (sel == 2'b00); 
    wire LEDSelect = (sel == 2'b01); 
    wire SwitchSelect = (sel == 2'b10); 
  
    assign DataMemWrite = DataMemSelect & MemWrite; 
    assign DataMemRead = DataMemSelect & MemRead; 
    assign LEDWrite = LEDSelect & MemWrite;    
    assign SwitchReadEnable = SwitchSelect & MemRead;     
endmodule