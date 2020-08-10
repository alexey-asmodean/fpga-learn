`include "counter.v"
`include "setup.v"

module timer #(
    parameter DIV=9
) (
    input clk,
    input plus,
    input minus,
    input start,
    input reset,
    output finish,
    output [15:0] display
);

reg run_mode = 1'b0;
reg paused = 1'b0;
wire [3:0] setup_hi;
wire [3:0] setup_lo;
wire setup_seconds;
wire [3:0] min_hi;
wire [3:0] min_lo;
wire [2:0] sec_hi;
wire [3:0] sec_lo;

counter #(DIV) counter(
    .clk(clk),
    .enabled(run_mode),
    .paused(paused),
    .hi(setup_hi),
    .lo(setup_lo),
    .seconds(setup_seconds),
    .min_hi(min_hi),
    .min_lo(min_lo),
    .sec_hi(sec_hi),
    .sec_lo(sec_lo)
);

setup setup(
    .clk(clk),
    .plus(plus & !run_mode),
    .minus(minus & !run_mode),
    .reset(finish | (reset & !run_mode)),
    .hi(setup_hi),
    .lo(setup_lo),
    .seconds(setup_seconds)
);

assign display = run_mode ? {min_hi, min_lo, 1'b0, sec_hi, sec_lo}
                          : {setup_hi, setup_lo, setup_seconds ? 4'd3 : 4'd0, 4'd0 };

assign finish = run_mode & min_hi == 4'd0 & min_lo == 4'd0 & sec_hi == 3'd0 & sec_lo == 4'd0;

always @(posedge clk) begin
    if (reset | finish) begin
        run_mode <= 1'b0;
        paused <= 1'b0;
    end else if (start & run_mode) begin
        paused <= ~paused;
    end else if (start & (setup_hi != 4'd0 | setup_lo != 4'd0 | setup_seconds)) begin
        run_mode <= 1'b1;
        paused <= 1'b0;
    end
end

endmodule