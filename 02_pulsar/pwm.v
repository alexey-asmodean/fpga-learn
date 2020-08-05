module pwm #(
    parameter WIDTH = 12
) (
    input clk,
    input [WIDTH-1:0] cmp,
    output we,
    output q
);

reg [WIDTH-1:0] cnt = 1'h0;

assign we = cnt == {WIDTH{1'b1}};
assign q = cnt < cmp;

always @(posedge clk) begin
    cnt <= we ? 0 : cnt + 1'b1;
end

endmodule