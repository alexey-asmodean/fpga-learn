`timescale 1ns/100ps
`include "decoder.v"

module decoder_tb();

reg clk = 1'b0;
always begin
    #10 clk = ~clk;
end

reg [19:0] ram [3:0];
reg [1:0] addr = 2'b0;
reg write;
reg [19:0] mem;
initial begin
    ram[0] = 20'b01011111001100110100;
    ram[1] = 20'b00000100111111001001;
    ram[2] = 20'b10011111001101111100;
    ram[3] = 30'b00000000000100101110;
end
/*
encoded values are:
129
144
  1
254
  8
 17
  0
*/

always @(posedge clk) begin
    if (write) begin
        write <= 1'b0;
    end else if (req) begin
        addr <= addr + 1'b1;
        write <= 1'b1;
    end
    mem <= ram[addr];
end

reg read = 1'b0;
reg reset = 1'b1;
wire req;
wire [7:0]value;

decoder decoder(
    .clk(clk),
    .reset(reset),
    .mem(mem),
    .read(read),
    .write(write),
    .req(req),
    .value(value)
);

initial begin
    $dumpfile("decoder.vcd");
    $dumpvars();
    #20 reset = 1'b0;
    #60
    #20 read = 1'b1;
    #20 read = 1'b0;
    $display(value);
    #60
    #20 read = 1'b1;
    #20 read = 1'b0;
    $display(value);
    #40
    #20 read = 1'b1;
    #20 read = 1'b0;
    $display(value);
    #40
    #20 read = 1'b1;
    #20 read = 1'b0;
    $display(value);
    #40
    #20 read = 1'b1;
    #20 read = 1'b0;
    $display(value);
    #40
    #20 read = 1'b1;
    #20 read = 1'b0;
    $display(value);
    #40
    #20 read = 1'b1;
    #20 read = 1'b0;
    $display(value);
    #40
    $finish();
end

endmodule