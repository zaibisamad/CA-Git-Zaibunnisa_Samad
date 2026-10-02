`timescale 1ns / 1ps 
 
module tb_top_fsm; 
 
    reg clk = 0; 
    reg pbin = 0; 
    reg [15:0] physical_sw = 16'd0; 
    wire [15:0] physical_leds; 
 
    top_fsm_system dut ( 
        .clk(clk), 
        .pbin(pbin), 
        .physical_sw(physical_sw), 
        .physical_leds(physical_leds) 
    ); 
 
    // 100MHz-ish fast clock 
    always #5 clk = ~clk; 
 
    integer i; 
    initial begin 
        $display("time=%0t leds=%0d", $time, physical_leds); 
 
        // hold reset briefly 
        pbin = 1; 
        #20; 
        pbin = 0; 
        #20; 
 
        // idle: switches at 0, leds should stay 0 
        #40; 
        if (physical_leds !== 16'd0) $display("FAIL: leds not 0 while idle, got %0d", physical_leds); 
 
        // drive switches to 5, should capture and start counting 
        physical_sw = 16'd5; 
        #20; // let it register 
        physical_sw = 16'd0; // switches should now be ignored 
 
        // watch the countdown for a while (MAX_COUNT=2 in clock_divider sim mode -> fast slow_clk) 
        for (i = 0; i < 40; i = i + 1) begin 
            #10; 
            $display("time=%0t leds=%0d", $time, physical_leds); 
        end 
 
        // mid-count reset test 
        physical_sw = 16'd7; 
        #20; 
        physical_sw = 16'd0; 
        #30; // let it count down partway 
        $display("mid-count leds=%0d", physical_leds); 
        pbin = 1; 
        #20; 
        pbin = 0; 
        #20; 
        $display("after reset leds=%0d (expect 0)", physical_leds); 
        if (physical_leds !== 16'd0) $display("FAIL: reset did not clear leds"); 
 
        $display("TEST DONE"); 
        $finish; 
    end 
 
endmodule