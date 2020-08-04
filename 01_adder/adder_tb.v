`timescale 1ns/100ps
`include "adder.v"

module adder_tv();

reg [7:0] x;
reg [7:0] y;
wire [7:0] sum;

adder a01(x, y, sum);

initial begin 
    $dumpfile("adder.vcd");
    $dumpvars();
    x = 21; y = 12; #1 $display("%d + %d = %d", x, y, sum);
    x = 85; y = 5; #1 $display("%d + %d = %d", x, y, sum);
    x = 77; y = 1; #1 $display("%d + %d = %d", x, y, sum);
end

endmodule