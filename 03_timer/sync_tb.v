`timescale 1ns/100ps
`include "sync.v"

module sync_tb();

reg clk = 1'b0;
always begin
    #10 clk = !clk;
end
wire clk1;

sync #(3, 6) sync(clk, clk1);

initial begin 
    $dumpfile("sync.vcd");
    $dumpvars();
    #2500 $finish;
end

endmodule