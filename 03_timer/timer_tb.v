`timescale 1ns/100ps
`include "timer.v"

module timer_tb();

reg clk = 1'b0;
always begin
    #10 clk <= ~clk;
end

reg plus =  1'b0;
reg minus = 1'b0;
reg start = 1'b0;
reg reset = 1'b0;

wire finish;
wire [15:0] data;

timer #(1) timer(
    .clk(clk),
    .plus(plus),
    .minus(minus),
    .start(start),
    .reset(reset),
    .finish(finish),
    .display(data)
);

initial begin
    $dumpfile("timer.vcd");
    $dumpvars();
    #20 minus = 1'b1;
    #40 minus = 1'b0; plus = 1'b1;
    #20 plus = 1'b0; start = 1'b1;
    #20 start = 1'b0;
    #1500 $finish;
end

endmodule