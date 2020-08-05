module pulsar #(
    parameter WIDTH = 12
) (
    input clk,
    input update,
    output [WIDTH-1:0] cmp
);

reg [WIDTH-1:0] ctr = 12'h0;
reg direction = 1'b0;

assign cmp = ctr;

always @(posedge clk) begin
    if (update) begin
        if (ctr == {{WIDTH-1{1'b0}}, 1'b1})
            direction <= 1'b0;
        else if (ctr == {{WIDTH-1{1'b1}}, 1'b0})
            direction <= 1'b1;
        else
            direction <= direction;
        ctr <= direction ? ctr - 1'b1 : ctr + 1'b1;
    end
end

endmodule