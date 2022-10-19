module comparator(
  input  logic [15:0] a,
  input  logic [15:0] b,
  output logic c
);

  assign c = (a >= b);

endmodule