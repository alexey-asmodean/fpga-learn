`timescale 1ns/1ns
`include "display.v"

module display_tb();
reg clk = 1'b0;
always #10 clk = ~clk;

reg [15:0]data = 16'h1945;

wire [3:0] en;
wire [6:0] dg;

display display(clk, data, en, dg);

initial begin 
    $dumpfile("display.vcd");
    $dumpvars();
    #420 $finish;
end

endmodule