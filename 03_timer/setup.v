module setup(
    input clk,
    input plus,
    input minus,
    input reset,
    output reg [3:0]hi = 4'd0,
    output reg [3:0]lo = 4'd0,
    output reg seconds = 4'b0
);

always @(posedge clk) begin
    if (reset) begin
        hi <= 4'd0;
        lo <= 4'd0;
        seconds <= 1'b0;
    end else if (plus && !minus && (lo != 4'd9 || hi != 4'd9 || !seconds)) begin
        seconds <= ~seconds;
        if (seconds) begin
            if (lo == 4'd9) begin
                lo <= 4'd0;
                hi <= hi + 1'b1;
            end else begin
                lo <= lo + 1'b1;
            end
        end
    end else if (minus && !plus && (lo != 4'd0 || hi != 4'd0 || seconds)) begin
        seconds <= ~seconds;
        if (!seconds) begin
            if (lo == 4'd0) begin
                lo <= 4'd9;
                hi <= hi - 1'b1;
            end else begin
                lo <= lo - 1'b1;
            end
        end
    end
end

endmodule