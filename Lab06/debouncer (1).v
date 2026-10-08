`timescale 1ns / 1ps

module debouncer(
    input clk,
    input pbin,
    output reg pbout
);
    reg [15:0] count;
    reg pb_sync_0, pb_sync_1;

    always @(posedge clk) begin
        pb_sync_0 <= pbin;
        pb_sync_1 <= pb_sync_0;
    end

    always @(posedge clk) begin
        if (pb_sync_1 == pbout) begin
            count <= 0;
        end else begin
            count <= count + 1;
            if (count == 16'hFFFF) begin
                pbout <= ~pbout;
            end
        end
    end
endmodule
