`timescale 1ns / 1ps 

module switch_module( 
    input readEnable, 
    input [15:0] switches, 
    output reg [31:0] readData 
); 
    always @(*) begin 
        if (readEnable) readData = {16'b0, switches}; 
        else readData = 32'b0; 
    end 
endmodule