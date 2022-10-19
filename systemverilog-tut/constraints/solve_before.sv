class ABC;
  rand bit a;
  rand bit [2:0] b;
  constraint c_ab { a -> b == 7; solve a before b; }
endclass

module tb;
  initial begin
    ABC abc = new();
    for (int i = 0; i < 16; i++) begin
      abc.randomize();
      $display("a=%0d b=%0d", abc.a, abc.b);
    end
  end
endmodule