module tb;
  bit a;
  bit clk;

  sequence s_a;
    @(posedge clk) $stable(a);
  endsequence

  assert property (s_a);

  always #10 clk = ~clk;

  initial begin
    for (int i = 0; i < 10; i++) begin
      a = $random;
      @(posedge clk);

      $display("[%0t] a=%0d", $time, a);
    end
    #20 $finish;
  end
endmodule