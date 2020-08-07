module display (
    input clk,
    input [15:0] data,
    output [3:0] en,
    output reg [6:0] seg
);

reg [1:0] current = 2'b0;
reg[3:0] digit;

always @(posedge clk) begin
    current <= current + 1'b1;
end

always @(*) begin
    case (current)
    2'd0: digit = data[3:0];
    2'd1: digit = data[7:4];
    2'd2: digit = data[11:8];
    2'd3: digit = data[15:12];
    endcase
end

always @(*) begin
    case (digit)
    4'h0: seg = 7'b1111110;
    4'h1: seg = 7'b0110000;
    4'h2: seg = 7'b1101101;
    4'h3: seg = 7'b1111001;
    4'h4: seg = 7'b0110011;
    4'h5: seg = 7'b1011011;
    4'h6: seg = 7'b1011111;
    4'h7: seg = 7'b1110000;
    4'h8: seg = 7'b1111111;
    4'h9: seg = 7'b1111011;
    4'ha: seg = 7'b1110111;
    4'hb: seg = 7'b0011111;
    4'hc: seg = 7'b1001110;
    4'hd: seg = 7'b0111101;
    4'he: seg = 7'b1001111;
    4'hf: seg = 7'b1000111;
    endcase
end

assign en = 4'b1 << current;

endmodule