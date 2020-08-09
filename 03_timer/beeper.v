module beeper #(
    parameter DIV = 10
) (
    input clk,
    input signal,
    output q
);

reg [DIV+1:0] cnt = {DIV+2{1'b1}};

assign q = clk & !cnt[DIV-1];

always @(posedge clk) begin
    if (cnt != {DIV+2{1'b1}} || signal) begin
        cnt <= cnt + 1'b1;
    end
end

endmodule