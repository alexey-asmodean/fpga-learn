module beeper #(
	parameter WIDTH
) (
	input clk,
	input enable,
	input [WIDTH-1:0] tone,
	output reg q = 1'b1
);

reg [WIDTH-1:0] ctr = {WIDTH{1'b0}};

always @(posedge clk) begin
	if (!enable) begin
		q <= 1'b1;
		ctr <= {WIDTH{1'b0}};
	end else begin
		if (ctr == tone) begin
			q <= ~q;
			ctr <= 1'b0;
		end else begin
			ctr <= ctr + 1'b1;
		end
	end
end

endmodule
