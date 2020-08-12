`include "pitches.v"

module beeper #(
    parameter DIV = 3
) (
    input clk,
    input on,
    input off,
    input [6:0] note,
    output reg q = 1'b0
);

reg [DIV-1:0] prescaler = {DIV{1'b0}};
reg [15:0] ctr = 16'b0;
reg enabled = 1'b0;
wire [15:0] tone;
wire [2:0] octave = note[6:4] - 3'd2;
wire [3:0] sound = note[3:0];

pitches pitches(clk, on, {octave[1:0], sound}, tone);

always @(posedge clk) begin
    if (off) begin
        prescaler <= {DIV{1'b0}};
        ctr <= 16'b0;
        q <= 1'b0;
        enabled <= 1'b0;
    end else if (on) begin
        enabled <= 1'b1;
    end
    if (enabled) begin
        if (prescaler == {DIV{1'b1}}) begin
            if (ctr == tone) begin
                ctr <= 16'b0;
                q <= ~q;
            end else begin
                ctr <= ctr + 1'b1;
            end
        end
        prescaler <= prescaler + 1'b1;
    end
end

endmodule