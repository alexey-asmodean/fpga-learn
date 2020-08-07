module debounce(
    input clk,
    input key,
    output pos
);

reg pressed = 1'b0;
reg [2:0]last = 1'b0;

assign pos = {last, pressed} == 4'b1110;
wire neg = {last, pressed} == 4'b0001;

always @(posedge clk) begin
    last <= {last[1:0], key};
    if (pos)
        pressed <= 1'b1;
    else if (neg)
        pressed <= 1'b0;
    else
        pressed <= pressed;
end

endmodule