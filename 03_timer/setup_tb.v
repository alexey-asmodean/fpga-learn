`timescale 1ns/100ps
`include "setup.v"

module setup_tb();

reg clk = 1'b0;
always begin 
    #10 clk = ~clk;
end

reg plus = 1'b0;
reg minus = 1'b0;
reg reset = 1'b0;

wire [3:0] hi;
wire [3:0] lo;
wire seconds;

setup setup(clk, plus, minus, reset, hi, lo, seconds);

initial begin
    $dumpfile("setup.vcd");
    $dumpvars();
    #30 minus = 1'b1;
    #40 minus = 1'b0;
    #20 plus = 1'b1;
    #4200 plus = 1'b0;
    #20 minus = 1'b1;
    #40 minus = 1'b0;
    #20 reset = 1'b1;
    #20 reset = 1'b0;
    #60 $finish;
end

endmodule