`include "sync.v"
`include "debounce.v"
`include "display.v"
`include "timer.v"
`include "beeper.v"

module top(
    input CLK,
    input S1,
    input S2,
    input S3,
    input S4,
    output DS_EN1,
    output DS_EN2,
    output DS_EN3,
    output DS_EN4,
    output DS_A,
    output DS_B,
    output DS_C,
    output DS_D,
    output DS_E,
    output DS_F,
    output DS_G,
    output BP1
);

wire clk;
wire plus;
wire minus;
wire start;
wire finish;
wire reset;
wire [3:0] en;
wire [15:0] data;
wire beep;

sync sync(CLK, clk);
debounce ds1(clk, ~S1, plus);
debounce ds2(clk, ~S2, minus);
debounce ds3(clk, ~S3, start);
debounce ds4(clk, ~S4, reset);
display display(
    .clk(clk),
    .data(data),
    .en(en),
    .seg({DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G})
);

assign {DS_EN1, DS_EN2, DS_EN3, DS_EN4} = ~en;

timer timer(
    .clk(clk),
    .plus(plus),
    .minus(minus),
    .start(start),
    .reset(reset),
    .finish(finish),
    .display(data)
);

beeper beeper(CLK, finish, beep);
assign BP1 = ~beep;

endmodule