`include "repeater.v"
module top(
    input KEY1,
    output DS_G
);

repeater repeater(
    .clk(KEY1),
    .clk1(DS_G)
);

endmodule
