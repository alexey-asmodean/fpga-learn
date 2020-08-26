`timescale 1ns/100ps
`include "beeper.v"

module beeper_tb();

reg clk = 1'b0;
always #10 clk = ~clk;

reg enable = 1'b0;
reg [1:0] tone = 7'h3;
wire q;

beeper #(2) beeper(clk, enable, tone, q);

initial begin
   $dumpfile("beeper.vcd");
   $dumpvars;
   #30  @(posedge clk) enable = 1'b1;
   #200 @(posedge q) tone = 2'd2;
   #200 @(posedge q) $finish;
end

endmodule