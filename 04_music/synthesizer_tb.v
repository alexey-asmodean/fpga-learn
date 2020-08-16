`timescale 1ns/100ps
`include "synthesizer.v"

module beeper_tb();

reg clk = 1'b0;
always begin
    #10 clk = ~clk;
end

reg on = 1'b0;
reg off = 1'b0;
reg [6:0] note = 7'h7f;
wire q;

synthesizer synthesizer(clk, on, off, note, q);

initial begin
    $dumpfile("synthesizer.vcd");
    $dumpvars();
    #80 on = 1'b1;
    #20 on = 1'b0;
    #4000 off = 1'b1;
    #20 off = 1'b0;
    #100 $finish;
end

endmodule