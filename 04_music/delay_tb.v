`timescale 1ns/100ps
`include "delay.v"

module delay_tb();

reg clk = 1'b0;
always begin
    #10 clk = ~clk;
end

reg [10:0] duration = 11'b0;
reg enabled = 1'b0;
wire active;

delay #(2) delay(clk, duration, enabled, active);

initial begin
    $dumpfile("delay.vcd");
    $dumpvars();
    #20 enabled = 1'b1;
    #80 enabled = 1'b0;
    #40 enabled = 1'b1;
    duration = 12'd5;
    #240 $finish;
end

endmodule