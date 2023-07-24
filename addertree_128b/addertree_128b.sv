module addertree_128b (
  input  logic [127:0] a_i,
  output logic [  7:0] b_i
);

always_comb begin : adder_128b
  b_i = 0;
  for (int k = 0; k < 128; k++) begin
    b_i += a_i[k];
  end
end

endmodule

// synthesis translate_off
module tb;
  logic [127:0] a;
  logic [7:0] b;
  addertree_128b u_dut (a,b);
  initial begin
    a = '1;
    #3
    $display(b);
    $stop;
  end
endmodule
// synthesis translate_on
