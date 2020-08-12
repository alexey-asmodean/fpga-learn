module song #(
    parameter LENGTH = 170,
    parameter WIDTH = 12,
    parameter ADDR = $clog2(LENGTH)
) (
    input clk,
    input [ADDR-1:0] addr,
    output [WIDTH-1:0] command
);

reg [WIDTH-1:0] song [LENGTH-1:0];

initial begin
    $readmemh("song.txt", song, 0, LENGTH-1);
end

assign command = song[addr];

endmodule