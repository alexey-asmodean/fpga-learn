`timescale 1ns/100ps
`include "selector.v"

module selector_tb();

reg [3:0] keys = 4'd0;
always #20 keys += 1'b1;
wire [4:0] tone;

selector #(10000) selector(keys[0], keys[1], keys[2], keys[3], tone);

initial begin
    $dumpfile("selector.vcd");
    $dumpvars;
    wait(keys == 4'b1111);
    #20 $finish;
end 

endmodule