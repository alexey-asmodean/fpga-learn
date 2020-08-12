`include "delay.v"
`include "beeper.v"

module sequencer #(
    parameter BEEPER = 3, // beeper prediv
    parameter PREDIV = 46875 // 1024 hz for delays
) (
    input clk,
    input [11:0] command,
    output busy,
    output q
);

wire active;
wire [15:0] tone;

wire is_delay = command[11];
wire [10:0] duration = command[10:0];
wire start_play = ~is_delay & command[10];
wire stop_play = ~is_delay & ~command[10];
wire [6:0] note = command[6:0];

assign busy = is_delay & active;

delay #(PREDIV) delay(clk, duration, is_delay, active);
beeper #(BEEPER) beeper(clk, start_play, stop_play, note, q);

endmodule