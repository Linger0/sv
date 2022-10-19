module tb;
  bit a, b;
  bit clk;

  sequence s_ab;
    @(posedge clk) a ##2 b;
  endsequence

  assert property (s_ab)
    $display("[%0t] Assertion passed!", $time);

  always #10 clk = ~clk;

  initial begin
    for (int i = 0; i < 10; i++) begin
      @(posedge clk);
      a <= $random;
      b <= $random;

      $display("[%0t] a=%b b=%b", $time, a, b);
    end
    #20 $finish;
  end
endmodule