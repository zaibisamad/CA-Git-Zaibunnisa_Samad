`timescale 1ns / 1ps

module debouncer(
    input clk,
    input pbin,
    output reg pbout
);
    reg [15:0] shift_reg = 16'd0;
    always @(posedge clk) begin
        shift_reg <= {shift_reg[14:0], pbin};
        if (shift_reg == 16'hFFFF)
            pbout <= 1'b1;
        else if (shift_reg == 16'h0000)
            pbout <= 1'b0;
    end
endmodule