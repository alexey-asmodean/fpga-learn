`timescale 1ns/100ps
`include "sequencer.v"

module sequencer_tb();

reg clk = 1'b0;
always begin
    #10 clk <= ~clk;
end

reg [11:0] command = 12'h43f;
wire busy;
wire q;

sequencer #(1, 512) sequencer(clk, 1'b0, command, busy, q);

initial begin
    $dumpfile("sequencer.vcd");
    $dumpvars();
    #20 command = 12'h840;
    #20 wait (busy == 1'b0);
    command = 12'h000;
    #30 command = 12'h820;
    #20 wait (busy == 1'b0);
    #100 $finish;
end

endmodule