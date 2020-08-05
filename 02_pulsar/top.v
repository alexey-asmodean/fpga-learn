`include "pulsar.v"
`include "pwm.v"
module top(
    input CLK,
    output DS_G
);

reg q;
wire update;
wire [11:0] cmp;

pulsar pulsar(CLK, update, cmp);
pwm pwm(CLK, cmp, update, DS_G);

endmodule