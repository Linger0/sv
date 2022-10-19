module top (
  input  clk,
  input  rst,
  input  [15:0] din,
  output [15:0] dout
);

reg  [7:0] dh;
wire [7:0] dl;
wire mem_clk;

always @(posedge clk) begin
  if (rst) begin
    dh <= '0;
  end else begin
    dh <= din[15:8];
  end
end

assign dout = {dh, dl};

assign mem_clk = ~clk;

mem u_mem (
  .clk(mem_clk),
  .rst(rst),
  .din(din[7:0]),
  .dout(dl)
);

endmodule
