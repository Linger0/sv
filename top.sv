module top;
  logic clk;
  always #20 clk = ~clk;
  initial clk = 0;
  initial begin
    #300
    $display("Finish");
    $finish;
  end
endmodule
