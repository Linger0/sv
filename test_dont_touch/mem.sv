module mem (
  input  clk,
  input  rst,
  input  [7:0] din,
  output [7:0] dout
);
reg  [7:0] dl;

always @(posedge clk) begin
  if (rst) begin
    dl <= '0;
  end else begin
    dl <= din;
  end
end
assign dout = dl;
endmodule
