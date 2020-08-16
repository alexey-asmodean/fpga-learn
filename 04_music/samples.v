`include "output/samples.v"

module samples #(
    parameter LENGTH = `SAMPLES_LENGTH,
    parameter WIDTH = 8,
    parameter ADDR = $clog2(LENGTH)
) (
    input clk,
    input [ADDR-1:0] addr,
    output reg signed [WIDTH-1:0] data
);

reg signed [WIDTH-1:0] ram [LENGTH-1:0];

initial begin
    $readmemh("output/samples.txt", ram, 0, LENGTH-1);
end

always @(posedge clk) begin
    data <= ram[addr];
end

endmodule