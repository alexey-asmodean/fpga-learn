module selector #(
	parameter INPUT = 48000000,
	parameter WIDTH = $clog2(INPUT / 262 / 2 - 1)
) (
	input a,
	input g,
	input f,
	input c,
	output reg [WIDTH-1:0] tone
);

localparam FREQ_A4 = 440;
localparam FREQ_G4 = 392;
localparam FREQ_F4 = 349;
localparam FREQ_C4 = 262;

localparam TONE_A4 = INPUT / FREQ_A4 / 2 - 1;
localparam TONE_G4 = INPUT / FREQ_G4 / 2 - 1;
localparam TONE_F4 = INPUT / FREQ_F4 / 2 - 1;
localparam TONE_C4 = INPUT / FREQ_C4 / 2 - 1;

always @(*) begin
	if (a)
		tone = TONE_A4[WIDTH-1:0];
	else if (g)
		tone = TONE_G4[WIDTH-1:0];
	else if (f)
		tone = TONE_F4[WIDTH-1:0];
	else
		tone = TONE_C4[WIDTH-1:0];
end

endmodule
