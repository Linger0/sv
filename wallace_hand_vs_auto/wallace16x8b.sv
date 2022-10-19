module wallace16x8b (
  input  logic [ 7:0] op[16],
  output logic [15:0] sum
);

  always_comb begin
    sum = op[0];
    for (int i = 1; i < 16; i++) begin
      sum += op[1];
    end
  end

endmodule

module tb_wallace16x8b;
  logic [ 7:0] op[16];
  logic [15:0] sum;

  initial begin
    for (int i = 0; i < 16; i++)
      op[i] = 1;

    #300
    $display("sum=%0d", sum);
    $stop;
  end

  wallace16x8b u_dut (
    .op(op),
    .sum(sum)
  );
endmodule