`timescale 1ns / 1ps 
////////////////////////////////////////////////////////////////////////////////// 
// Company:  
// Engineer:  
// Module Name: top_fsm_system 
// Project Name: Counter 
// Target Devices: Basys 3 
////////////////////////////////////////////////////////////////////////////////// 

module top_fsm_system ( 
    input wire clk, 
    input wire pbin, 
    input wire [15:0] physical_sw, 
    output wire [15:0] physical_leds 
); 

    // DEBOUNCER (Cleans up the physical reset/mode button signal) 
    wire rst_clean; 
    wire [31:0] switch_data;         // holds the value read from the switches 
    reg  [31:0] led_write_data = 32'd0; // counter value goes here, shown on LEDs 
    wire slow_clk; 

    debouncer rst_db ( 
        .clk(clk), 
        .pbin(pbin), 
        .pbout(rst_clean)            // clean "button pressed" signal 
    ); 

    leds switch_reader ( 
        .clk(clk), .rst(rst_clean), 
        .btns(16'd0),                // Not used for this FSM 
        .writeData(32'd0),          
        .writeEnable(1'b0),          // Disabled 
        .readEnable(1'b1),           // Always ON so we can monitor switches 
        .memAddress(30'd0), 
        .switches(physical_sw),      // Plug in the physical switches 
        .readData(switch_data)       // output data 
    ); 

    switches led_writer ( 
        .clk(clk), .rst(rst_clean), 
        .writeData(led_write_data), 
        .writeEnable(1'b1),          // Always ON so LEDs update instantly 
        .readEnable(1'b0), .memAddress(30'd0), 
        .readData(),                 // Ignored 
        .leds(physical_leds) 
    ); 

    clock_divider ticker ( 
        .clk_in(clk),                // Feed it the 100MHz fast clock 
        .rst(1'b0),                  // Tied to 0 so the divider never stops ticking
        .clk_out(slow_clk)           // It spits out the 1Hz slow clock! 
    ); 

    //  FSM AND COUNTER LOGIC 
    localparam S_RESET = 2'b00;   // Reset state
    localparam S_IDLE  = 2'b01;   // Input-waiting state (IDLE)
    localparam S_COUNT = 2'b10;   // Counter (counting down) 

    reg [1:0]  state       = S_RESET;  // Start in Reset state
    reg [15:0] counter_reg = 16'd0;    // the number currently being counted down 

    // slow_clk only changes twice a second, it is NOT a clean 1-tick-per-second 
    // pulse. We edge-detect it in the 100MHz clk domain to build a single-cycle 
    // "tick" pulse that fires exactly once every time slow_clk rises. 
    reg slow_clk_d = 1'b0; 
    wire tick = slow_clk & ~slow_clk_d; 

    always @(posedge clk) begin 
        slow_clk_d <= slow_clk; 
    end 

    // FSM Logic matching the hand-drawn 3-state diagram
    always @(posedge clk) begin 
        case (state) 

            S_RESET: begin 
                counter_reg <= 16'd0;
                if (rst_clean == 1'b1) 
                    state <= S_RESET; // Loop if reset=1
                else 
                    state <= S_IDLE;  // Transition to IDLE if reset=0
            end 

            S_IDLE: begin 
                if (rst_clean == 1'b1) begin 
                    state <= S_RESET; // Return to Reset if reset=1
                end else if (switch_data[15:0] != 16'd0) begin 
                    // idle != 0 -> load the value and start counting 
                    counter_reg <= switch_data[15:0]; 
                    state <= S_COUNT; 
                end else begin 
                    // idle == 0 -> implicitly stays in S_IDLE 
                    state <= S_IDLE; 
                end 
            end 

            S_COUNT: begin 
                if (rst_clean == 1'b1) begin 
                    state <= S_RESET; // Return to Reset if reset=1
                end else if (counter_reg == 16'd0) begin 
                    // counter == 0 -> back to IDLE 
                    state <= S_IDLE; 
                end else if (tick) begin 
                    // counter != 0 -> count down on the slow clock tick
                    counter_reg <= counter_reg - 16'd1; 
                    state <= S_COUNT; 
                end 
            end 

            default: state <= S_RESET; 
        endcase 
    end 

    // Drive the LEDs with whatever the counter currently holds 
    always @(*) begin 
        led_write_data = {16'd0, counter_reg}; 
    end 

endmodule