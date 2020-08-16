`include "samples.v"
`include "pwm.v"

module synthesizer (
    input clk,
    input start,
    input stop,
    input [6:0] note,
    output q
);

wire [2:0] octave = note[6:4];
wire [1:0] sample = note[3:2];
wire [1:0] difference = note[1:0];
reg [15:0] prescaller = 16'b0;
reg [14:0] pos = 15'b0;
reg [15:0] scale = 16'b0;
reg playing = 1'b0;

wire signed [7:0] wave;

samples samples(clk, pos, wave);
pwm pwm(clk, wave, q);

always @(posedge clk) begin
    if (stop) begin
        playing <= 1'b0;
    end else if (start) begin
        playing <= 1'b1;
        scale <= 16'b0;

        case ({octave[0], sample})
            3'b001: pos <= `SAMPLE_F4;
            3'b010: pos <= `SAMPLE_A4;
            3'b100: pos <= `SAMPLE_CD5;
            3'b101: pos <= `SAMPLE_F5;
            3'b110: pos <= `SAMPLE_A5;
            default: pos <= `SAMPLE_CD4;
        endcase

        case (difference)
            2'd0: prescaller <= 16'd12714;
            2'd1: prescaller <= 16'd12000;
            2'd2: prescaller <= 16'd11327;
            2'd3: prescaller <= 16'd10691;
        endcase
    end else if (playing) begin
        if (scale == prescaller) begin
            pos <= pos + 1'b1;
            scale <= 16'b0;
        end else begin
            scale <= scale + 1'b1;
        end
    end
end

endmodule