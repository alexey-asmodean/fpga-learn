`include "samples.v"
`include "decoder.v"
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
reg [13:0] pos = 14'b0;
reg [15:0] scale = 16'b0;
reg playing = 1'b0;
wire req;
reg write;

wire signed [7:0] wave;
wire signed [19:0] mem;

decoder decoder(clk, !playing, mem, scale == prescaller, write, req, wave);
samples samples(clk, pos, mem);
pwm pwm(clk, wave, q);

always @(posedge clk) begin
    if (stop) begin
        playing <= 1'b0;
    end else if (start) begin
        playing <= 1'b1;
        scale <= 16'b0;

        case ({octave[1:0], sample})
            4'b0000: pos <= `SAMPLE_CD4;
            4'b0001: pos <= `SAMPLE_F4;
            4'b0010: pos <= `SAMPLE_A4;
            4'b0100: pos <= `SAMPLE_CD5;
            4'b0101: pos <= `SAMPLE_F5;
            4'b0110: pos <= `SAMPLE_A5;
            4'b1000: pos <= `SAMPLE_CD2;
            4'b1001: pos <= `SAMPLE_F2;
            4'b1010: pos <= `SAMPLE_A2;
            4'b1100: pos <= `SAMPLE_CD3;
            4'b1101: pos <= `SAMPLE_F3;
            4'b1110: pos <= `SAMPLE_A3;
        endcase

        case ({octave[1], difference})
            3'd0: prescaller <= `HI_FREQ_DN;
            3'd1: prescaller <= `HI_FREQ_EQ;
            3'd2: prescaller <= `HI_FREQ_UP;
            3'd3: prescaller <= `HI_FREQ_DU;
            3'd4: prescaller <= `LO_FREQ_DN;
            3'd5: prescaller <= `LO_FREQ_EQ;
            3'd6: prescaller <= `LO_FREQ_UP;
            3'd7: prescaller <= `LO_FREQ_DU;
        endcase
    end else if (playing) begin
        if (scale == prescaller) begin
            scale <= 16'b0;
        end else begin
            scale <= scale + 1'b1;
        end
        if (write) begin
            write <= 1'b0;
        end else if (req) begin
            write <= 1'b1;
            pos <= pos + 1'b1;
        end
    end
end

endmodule