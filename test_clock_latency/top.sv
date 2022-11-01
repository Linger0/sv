module top (
  input  logic [255:0] op1,
  input  logic [255:0] op2,
  output logic [255:0] res,
  input  logic clk,
  input  logic [7:0] en1,
  input  logic [7:0] en2
);

  reg  [255:0] temp;
  logic [7:0] en_sum;
  logic en;
  logic clk_n;

  assign clk_n = ~clk;

  always_comb begin
    en_sum = en1 + en2;
    en = (&en_sum) & clk_n;
  end

  always_ff @( posedge clk_n ) begin
    if (en)
      temp <= op1 + op2;
  end

  assign res = temp;

endmodule