module delay #(
    parameter PREDIV = 93750, // 512 hz for delays
    parameter WIDTH = 11
) (
    input clk,
    input [WIDTH-1:0] duration,
    input enabled,
    output active
);

localparam PREWIDTH = $clog2(PREDIV);
localparam PREMAX = PREDIV - 1;

reg [PREWIDTH-1:0] prescale = 0; // delay prescaller
reg [WIDTH-1:0] ctr = {WIDTH{1'b0}}; // delay counter

assign active = enabled && ctr != duration;

always @(posedge clk) begin
    if (!enabled) begin
        prescale <= 1'b0;
        ctr <= {WIDTH{1'b0}};
    end else begin
        if (prescale == PREMAX) begin
            if (active) begin
                ctr <= ctr + 1'b1;
            end
            prescale <= 0;
        end else begin
            prescale <= prescale + 1'b1;
        end
    end
end

endmodule