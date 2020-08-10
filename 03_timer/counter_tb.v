`timescale 1ns/100ps
`include "counter.v"

module counter_tb();

reg clk = 1'b0;
always begin
    #10 clk = ~clk;
end

reg [3:0]hi = 4'd0;
reg [3:0]lo = 4'd0;
reg seconds = 1'b1;
reg enabled = 1'b0;
reg paused = 1'b0;

wire [3:0] min_hi;
wire [3:0] min_lo;
wire [2:0] sec_hi;
wire [3:0] sec_lo;

counter #(1) counter(clk, enabled, paused, hi, lo, seconds, min_hi, min_lo, sec_hi, sec_lo);

initial begin
    $dumpfile("counter.vcd");
    $dumpvars();
    #20 enabled = 1'b1;
    #100 paused = 1'b1;
    #60 paused = 1'b0;
    #2000 $finish;
end

endmodule