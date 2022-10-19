module alu_8x4 (
  input  logic [63:0] a,
  input  logic [63:0] b,
  input  logic ci,
  output logic co,
  output logic [63:0] s
);
/*
  logic c[9];
  assign c[0] = ci;
  generate for (genvar i = 0; i < 8; i++) begin
    assign {c[i+1],s[i*8+:8]} = a[i*8+:8] + b[i*8+:8] + c[i];
  end endgenerate
  assign co = c[8];
*/
  assign {co,s} = a+b+ci;
endmodule
  
