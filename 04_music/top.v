`include "sequencer.v"
`include "song.v"

module top (
    input CLK,
    input S1,
    output DS_D,
    output DS_C,
    output DS_G,
    output DS_DP,
    output BP1
);

parameter ADDR = 8;

wire [11:0] command;
reg [ADDR-1:0] cnt = {ADDR{1'b0}};
reg playing = 1'b0;
reg [1:0] lights = 2'b0;
reg on_light = 1'b0;
wire busy;
wire q;
wire signed [7:0] wave;

song song (CLK, cnt, command);
sequencer sequencer(CLK, command, busy, q);

assign BP1 = ~q;
assign DS_D = ~on_light | lights != 2'd0;
assign DS_C = ~on_light | lights != 2'd1;
assign DS_G = ~on_light | lights != 2'd2;
assign DS_DP = ~on_light | lights != 2'd3;

always @(posedge CLK) begin
    if (~S1 & !playing) begin
        playing <= 1'b1;
        cnt <= {ADDR{1'b0}};
    end else if (command == 12'hfff) begin
        playing <= 1'b0;
    end else if (playing & ~busy) begin
        cnt <= cnt + 1'b1;
    end

    if (command[11:10] == 2'b01) begin
        on_light <= 1'b1;
        lights <= command[1:0];
    end else if (command[11:10] == 2'b00) begin
        on_light <= 1'b0;
    end
end

endmodule