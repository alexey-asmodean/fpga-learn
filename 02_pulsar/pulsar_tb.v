`timescale 1ns/100ps
`include "pulsar.v"
`include "pwm.v"

module pulsar_tb();

reg clk = 1'b0;
always begin
    #10 clk = !clk;
end
reg q;
wire update;
wire [2:0] cmp;

pulsar #(3) pulsar(clk, update, cmp);
pwm #(3) pwm(clk, cmp, update, q);

initial begin 
    $dumpfile("pulsar.vcd");
    $dumpvars();
    #2500 $finish;
end

endmodule