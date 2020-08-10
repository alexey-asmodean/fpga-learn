module counter #(
    parameter DIV=9
) (
    input clk,
    input enabled,
    input paused,
    input [3:0] hi,
    input [3:0] lo,
    input seconds,
    output reg [3:0]min_hi = 4'd0,
    output reg [3:0]min_lo = 4'd0,
    output reg [2:0]sec_hi = 3'd0,
    output reg [3:0]sec_lo = 4'd0
);

reg [DIV-1:0] fracts = 1'b0;

wire sec_lo_strobe = !paused & fracts == {DIV{1'b1}};
wire sec_hi_strobe = sec_lo_strobe & sec_lo == 4'd0;
wire min_lo_strobe = sec_hi_strobe & sec_hi == 3'd0;
wire min_hi_strobe = min_lo_strobe & min_lo == 4'd0;

always @(posedge clk) begin
    if (!enabled) begin
        sec_lo <= 4'd0;
        sec_hi <= seconds ? 3'd3 : 3'd0;
        min_lo <= lo;
        min_hi <= hi;
    end else begin
        if (enabled & !paused)
            fracts <= fracts + 1'b1;

        if (sec_lo_strobe)
            sec_lo <= sec_lo == 4'd0 ? 4'd9 : sec_lo - 1'b1;

        if (sec_hi_strobe)
            sec_hi <= sec_hi == 3'd0 ? 3'd5 : sec_hi - 1'b1;

        if (min_lo_strobe)
            min_lo <= min_lo == 4'd0 ? 4'd9 : min_lo - 1'b1;

        if (min_hi_strobe)
            min_hi <= min_hi - 1'b1;
    end
end

endmodule