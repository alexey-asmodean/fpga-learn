module pitches(
    input clk,
    input enable,
    input [5:0] addr,
    output reg [15:0] tone
);

reg [15:0] rom [63:0];

initial begin
    $readmemh("pitches.txt", rom, 0, 63);
end

always @(posedge clk) begin
    if (enable) begin
        tone <= rom[addr];
    end
end

endmodule