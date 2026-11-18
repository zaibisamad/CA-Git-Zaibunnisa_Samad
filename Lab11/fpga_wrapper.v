`timescale 1ns / 1ps

module fpga_wrapper (
    input wire clk,          // 100 MHz Basys-3 clock
    input wire reset,        // Center push button (btnC)
    output wire [15:0] led   // 16 Basys-3 LEDs displaying current_pc[15:0]
);

    // 26-bit counter divides 100 MHz clock down to ~1.5 Hz for visible LED updates
    reg [25:0] clk_div = 26'b0;
    wire slow_clk;

    always @(posedge clk or posedge reset) begin
        if (reset)
            clk_div <= 26'b0;
        else
            clk_div <= clk_div + 26'd1;
    end

    assign slow_clk = clk_div[25];

    // Instantiate TopLevelProcessor as 'cpu' to match Utilization Report hierarchy
    TopLevelProcessor cpu (
        .clk(slow_clk),
        .reset(reset),
        .current_pc(led)
    );

endmodule