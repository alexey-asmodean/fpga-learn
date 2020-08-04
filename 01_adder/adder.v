module single_adder (
    input x,
    input y,
    input cin,
    output wire s,
    output wire cout
);

assign s = (x ^ y) ^ cin;
assign cout = (x & y) | ((x | y) & cin);

endmodule

module adder(
    input [7:0]x,
    input [7:0]y,
    output [7:0]s
);

wire [6:0]carry;
single_adder a0(x[0], y[0], 1'b0, s[0], carry[0]);

genvar i;
generate
for (i = 1; i < 7; i = i + 1) begin
    single_adder a1(x[i], y[i], carry[i - 1], s[i], carry[i]);
end
endgenerate

single_adder a7(
    .x(x[7]),
    .y(y[7]),
    .cin(carry[6]),
    .s(s[7])
);

endmodule