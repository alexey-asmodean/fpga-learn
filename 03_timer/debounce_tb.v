`timescale 1ns/100ps
`include "debounce.v"

module debounce_tb();

reg clk = 1'b0;
always begin
    #10 clk = ~clk;
end

reg key = 1'b0;
wire result;

debounce debounce(clk, key, result);

initial begin
    $dumpfile("debounce.vcd");
    $dumpvars();
    #20 key = 1'b1;
    #20 key = 1'b0;
    #20 key = 1'b1;
    #100 key = 1'b0;
    #60 $finish();
end

endmodule