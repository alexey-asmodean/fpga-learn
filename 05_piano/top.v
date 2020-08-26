`include "beeper.v"
`include "selector.v"

module top(
	input clk,
	input s1,
	input s2,
	input s3,
	input s4,
	output q
);

localparam INPUT = 48000000;
localparam WIDTH = $clog2(INPUT / 262 / 2 - 1);

wire [WIDTH-1:0] tone;

selector #(INPUT, WIDTH) selector(!s1, !s2, !s3, !s4, tone);
beeper #(WIDTH) beeper(clk, !s1 | !s2 | !s3 | !s4, tone, q);

endmodule
