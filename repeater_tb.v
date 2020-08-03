`timescale 1ns/100ps
`include "repeater.v"

module repeater_tb();

reg clk = 1'b0;
always begin
    #1 clk = ~clk;
end

wire clk1;

repeater repeater1(
    .clk(clk),
    .clk1(clk1)
);

initial begin
    $dumpfile("repeater.vcd");
    $dumpvars();
    $display("testing...");
    #10 $finish;
end

endmodule
