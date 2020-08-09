module timer #(
    parameter DIV=9
) (
    input clk,
    input plus,
    input minus,
    input start,
    input reset,
    output finish,
    output [15:0] display
);

reg run_mode = 1'b0;
reg [DIV-1:0] fracts = 1'b0;
reg [3:0] min_hi = 4'b0;
reg [3:0] min_lo = 4'b0;
reg [2:0] sec_hi = 3'b0;
reg [3:0] sec_lo = 4'b0;

assign display = {min_hi, min_lo, 1'b0, sec_hi, sec_lo};
assign finish = run_mode & is_min;

wire plus_strobe = !run_mode & ! is_max & plus;
wire minus_strobe = !run_mode & !is_min & minus;

wire fracts_overflow = fracts == {DIV{1'b1}};
wire sec_lo_borrow = sec_lo == 4'd0;
wire sec_hi_borrow = sec_hi == 3'd0;
wire min_lo_borrow = min_lo == 4'd0;
wire min_hi_borrow = min_hi == 4'd0;
wire is_min = sec_lo_borrow & sec_hi_borrow & min_lo_borrow & min_hi_borrow;

wire sec_lo_down = run_mode & fracts_overflow;
wire sec_hi_down = sec_lo_down & sec_lo_borrow;
wire min_lo_down = (minus_strobe | sec_hi_down) & sec_hi_borrow;
wire min_hi_down = min_lo_down & min_lo_borrow;

wire sec_hi_carry = sec_hi == 3'd3;
wire min_lo_carry = min_lo == 4'd9;
wire min_hi_carry = min_hi == 4'd9;
wire is_max = min_lo_carry & min_hi_carry & sec_hi == 3'd3;

wire sec_hi_ch = minus_strobe | plus_strobe;
wire min_lo_up = plus_strobe & sec_hi_carry;
wire min_hi_up = min_lo_up & min_lo_carry;

always @(posedge clk) begin
    if (finish || reset) begin
        run_mode <= 1'b0;
        sec_lo <= 4'd0;
        sec_hi <= 3'd0;
        min_lo <= 4'd0;
        min_hi <= 4'd0;
    end else if (start & !run_mode) begin
        run_mode <= 1'b1;
    end else if (start & run_mode) begin
        run_mode <= 1'b1;
    end else begin
        if (run_mode)
            fracts <= fracts + 1'b1;

        if (sec_lo_down)
            sec_lo <= sec_lo_borrow ? 4'd9 : sec_lo - 1'b1;

        if (sec_hi_down)
            sec_hi <= sec_hi_borrow ? 3'd5 : sec_hi - 1'b1;
        else if (sec_hi_ch)
            sec_hi <= sec_hi_carry ? 3'd0 : 3'd3;

        if (min_lo_down)
            min_lo <= min_lo_borrow ? 4'd9 : min_lo - 1'b1;
        else if (min_lo_up)
            min_lo <= min_lo_carry ? 4'd0 : min_lo + 1'b1;

        if (min_hi_down)
            min_hi <= min_hi - 1'b1;
        else if (min_hi_up)
            min_hi <= min_hi + 1'b1;
    end
end

endmodule