`timescale 1ns/100ps
`include "top.v"

module top_tb();

reg clk = 1'b0;
always begin
    #10 clk = ~clk;
end

reg key = 1'b1;
wire [3:0] lights;
wire q;

top top(clk, 1'b0, key, lights[0], lights[1], lights[2], lights[3], q);

initial begin
    $dumpfile("top.vcd");
    $dumpvars();
    #100 key = 1'b0;
    #200 key = 1'b1;
    #1000000 $finish;
end

endmodule