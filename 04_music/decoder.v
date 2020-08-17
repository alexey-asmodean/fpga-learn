module decoder(
    input clk,
    input reset,
    input [19:0] mem,
    input read,
    input write,
    output req,
    output reg [7:0] value = 8'd128
);

reg [35:0] buffer = 36'b0;
reg [5:0] fill = 5'b0;
reg signed [8:0] selected = 9'b0;
reg [3:0] bits = 4'b0;
wire [4:0] shift = bits << 1;

always @(*) begin
    casez (buffer[6:0])
        8'b10111111: selected = {{1{1'b1}}, ~buffer[15:8]} - 9'd252;
        8'b?1011111: selected = {{2{1'b1}}, ~buffer[13:7]} - 9'd124;
        8'b??101111: selected = {{3{1'b1}}, ~buffer[11:6]} - 9'd60;
        8'b???10111: selected = {{4{1'b1}}, ~buffer[9:5]} - 9'd28;
        8'b????1011: selected = {{5{1'b1}}, ~buffer[7:4]} - 9'd12;
        8'b?????101: selected = {{6{1'b1}}, ~buffer[5:3]} - 9'd4;
        8'b??????10: selected = {{7{1'b1}}, ~buffer[3:2]};
        8'b00111111: selected = {{1{1'b0}}, buffer[15:8]} + 9'd252;
        8'b?0011111: selected = {{2{1'b0}}, buffer[13:7]} + 9'd124;
        8'b??001111: selected = {{3{1'b0}}, buffer[11:6]} + 9'd60;
        8'b???00111: selected = {{4{1'b0}}, buffer[9:5]} + 9'd28;
        8'b????0011: selected = {{5{1'b0}}, buffer[7:4]} + 9'd12;
        8'b?????001: selected = {{6{1'b0}}, buffer[5:3]} + 9'd4;
        default: selected = {{7{1'b0}}, buffer[3:2]};
    endcase

    casez (buffer[6:0])
        7'b0111111: bits = 4'd8;
        7'b?011111: bits = 4'd7;
        7'b??01111: bits = 4'd6;
        7'b???0111: bits = 4'd5;
        7'b????011: bits = 4'd4;
        7'b?????01: bits = 4'd3;
        default: bits = 4'd2;
    endcase
end

assign req = fill < 5'd16;

always @(posedge clk) begin
    if (reset) begin
        buffer <= 34'b0;
        fill <= 5'b0;
        value <= 8'd128;
    end else if (write) begin
        buffer = buffer | (mem << fill);
        fill <= fill + 5'd20;
    end else if (read) begin
        value <= value + selected;
        buffer = buffer >> shift;
        fill <= fill - shift;
    end
end

endmodule