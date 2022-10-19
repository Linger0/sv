class ABC;
  rand bit [3:0] array[5];
  constraint c_sum { array.sum() with (int'(item)) == 20; }
endclass

module tb;
  initial begin
    ABC abc = new();
    abc.randomize();
    $display("array=%p", abc.array);
  end
endmodule