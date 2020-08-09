`timescale 1ns/100ps
`include "beeper.v"

module beeper_tb();

reg clk = 1'b0;
always begin
    #10 clk = ~clk;
end

reg signal = 1'b0;
wire q;

beeper #(3) beeper(clk, signal, q);

initial begin
    $dumpfile("beeper.vcd");
    $dumpvars();
    #40 signal = 1'b1;
    #20 signal = 1'b0;
    #700 $finish;
end

endmodule