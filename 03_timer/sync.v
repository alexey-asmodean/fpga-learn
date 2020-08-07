module sync #(
    parameter WIDTH = 16,
    parameter PERIOD = 93750 // 512 hz strobe output on 48 mhz input
) (
    input clk,
    output reg clk1 = 1'b0
);

localparam MAX = (PERIOD / 2) - 1;

reg [WIDTH-1:0] ctr = {WIDTH{1'b0}};

always @(posedge clk) begin
    if (ctr == MAX) begin
        ctr <= 0;
        clk1 <= ~clk1;
    end else begin
        ctr <= ctr + 1'b1;
    end
end

endmodule