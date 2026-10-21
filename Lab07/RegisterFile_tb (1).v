`timescale 1ns / 1ps

module RegisterFile_tb;
    reg clk, rst, WriteEnable;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] WriteData;
    wire [31:0] ReadData1, ReadData2;

    RegisterFile uut (
        .clk(clk), .rst(rst), .WriteEnable(WriteEnable),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; WriteEnable = 0; 
        rs1 = 0; rs2 = 0; rd = 0; WriteData = 0;
        #10 rst = 0;

        // Test i: Write value and verify[cite: 2]
        #10 WriteEnable = 1; rd = 5'd5; WriteData = 32'hDEADBEEF;
        #10 WriteEnable = 0; rs1 = 5'd5;
        #10 $display("Test i (Write/Read x5): %h", ReadData1);

        // Test ii: Attempt to write to x0[cite: 2]
        #10 WriteEnable = 1; rd = 5'd0; WriteData = 32'hFFFFFFFF;
        #10 WriteEnable = 0; rs1 = 5'd0;
        #10 $display("Test ii (Write x0): %h (Should be 0)", ReadData1);

        // Test iii: Simultaneous two read ports[cite: 2]
        #10 WriteEnable = 1; rd = 5'd6; WriteData = 32'hCAFEBABE;
        #10 WriteEnable = 0; rs1 = 5'd5; rs2 = 5'd6;
        #10 $display("Test iii (Dual Read): Read1=%h, Read2=%h", ReadData1, ReadData2);

        // Test iv: Overwrite a register[cite: 2]
        #10 WriteEnable = 1; rd = 5'd5; WriteData = 32'h12345678;
        #10 WriteEnable = 0; rs1 = 5'd5;
        #10 $display("Test iv (Overwrite x5): %h", ReadData1);

        // Test v: Reset behavior[cite: 2]
        #10 rst = 1;
        #10 rst = 0; rs1 = 5'd5; rs2 = 5'd6;
        #10 $display("Test v (Reset): Read1=%h, Read2=%h", ReadData1, ReadData2);

        $finish;
    end
endmodule