module serial24to128 (
    input  clk,
    input  rst,
    input  [ 23:0] in,
    output [127:0] out,
    output         valid
);

reg  [143:0] buf;
wire [  2:0] sel;
reg  [  :  ] cnt;

always @(posedge clk) begin
    if (rst)
        cnt <= '0;
    else if (cnt >= 16)
        cnt <= cnt - 15;
    else
        cnt <= cnt + 1;
end

assign valid = (cnt >= 16);
assign sel = {(cnt % 3) == 2, (cnt % 3) == 1, (cnt % 3) == 0};

always @(posedge clk) begin
    if (rst)
        buf <= '0;
    else
        buf <= {buf[128:0], in};
end

assign out = sel[0] ? buf[143:24] :
             sel[1] ? buf[135:16] :
           /*sel[2]*/ buf[127:8];

endmodule
