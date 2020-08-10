module debounce #(
    parameter DIV=3
) (
    input clk,
    input key,
    output pos
);

reg [DIV-1:0]ctr = 0;
reg [1:0]last = 1'b0;
reg pressed = 1'b0;

assign pos = {last, pressed} == 3'b110;
wire neg = {last, pressed} == 3'b001;

always @(posedge clk) begin
    ctr <= ctr + 1'b1;
    if (ctr == 0)
        last <= {last[0], key};
    if (pos)
        pressed <= 1'b1;
    else if (neg)
        pressed <= 1'b0;
    else
        pressed <= pressed;
end

endmodule