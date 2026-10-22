`timescale 1ns / 1ps 

module MemorySystem_tb; 
    reg clk = 0; 
    reg rst = 1; 
    reg [31:0] address = 0; 
    reg readEnable = 0; 
    reg writeEnable = 0; 
    reg [31:0] writeData = 0; 
    reg [15:0] switches = 0; 
  
    wire [31:0] readData; 
    wire [15:0] leds; 
  
    addressDecoderTop dut ( 
        .clk(clk), .rst(rst), 
        .address(address), 
        .readEnable(readEnable), .writeEnable(writeEnable), 
        .writeData(writeData), 
        .switches(switches), 
        .readData(readData), 
        .leds(leds) 
    ); 

    always #5 clk = ~clk; 
     
    initial begin 
        #20 rst = 0; 
  
        // 1. write 1000 into memory, address 5 
        address = 5;  writeData = 1000;  writeEnable = 1; 
        #10 writeEnable = 0; 
  
        // 2. read memory, address 5 
        address = 5;  readEnable = 1; 
        #10 $display("memory = %d", readData); 
        readEnable = 0; 
  
        // 3. write to LEDs, address 256 (address[9:8] = 01) 
        address = 256;  writeData = 32'hAAAA;  writeEnable = 1; 
        #10 writeEnable = 0; 
        $display("leds = %b", leds); 
  
        // 4. read switches, address 512 (address[9:8] = 10) 
        switches = 16'hF0F0; 
        address = 512;  readEnable = 1; 
        #10 $display("switch  = %b", readData[15:0]); 
        readEnable = 0; 
  
        $finish; 
    end 
endmodule