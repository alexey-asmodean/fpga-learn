module pwm #(
    parameter WIDTH = 8
) (
    input clk,
    input [WIDTH-1:0] cmp,
    output q
);

reg [WIDTH-1:0] cnt = 1'h0;
reg [WIDTH-1:0] latch = 1'h0;

assign q = cnt < latch;

always @(posedge clk) begin
    if (cnt == {WIDTH{1'b1}}) begin
        latch <= cmp;
        cnt <= {WIDTH{1'b0}};
    end else begin
        cnt <= cnt + 1'b1;
    end
end

endmodule