// module tb;
//   initial begin
//     int a, res;

//     a = $urandom_range(1, 10);

//     $display("Before calling fn: a=%0d res=%0d", a, res);

//     res = fn(a);

//     $display("After calling fn: a=%0d res=%0d", a, res);
//   end

//   function int fn(int a);
//     a = a + 5;
//     return a * 10;
//   endfunction
// endmodule

module tb;
  initial begin
    int a, res;

    a = $urandom_range(1, 10);

    $display("Before calling fn: a=%0d res=%0d", a, res);

    res = fn(a);

    $display("After calling fn: a=%0d res=%0d", a, res);
  end

  function automatic int fn(ref int a);
    a = a + 5;
    return a * 10;
  endfunction
endmodule