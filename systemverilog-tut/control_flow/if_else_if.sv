// module tb;
//   int x = 4;

//   initial begin
//     unique if (x == 3)
//       $display("x is %0d", x);
//     else if (x == 5)
//       $display("x is %0d", x);
//     else
//       $display("x is neither 3 nor 5");

//     unique if (x == 3)
//       $display("x is %0d", x);
//     else if (x == 5)
//       $display("x is %0d", x);

//   end
// endmodule

// module tb;
//   int x = 4;

//   initial begin
//     unique if (x == 4)
//       $display("x is %0d", x);
//     else if (x == 4)
//       $display("x is %0d", x);
//     else
//       $display("x is not 4");
//   end
// endmodule

module tb;
  int x = 4;

  initial begin
    priority if (x == 4)
      $display("x is %0d", x);
    else if (x != 5)
      $display("x is not 5 but %0d", x);

    priority if (x == 3)
      $display("x is %0d", x);
    else if (x == 5)
      $display("x is %0d", x);
  end
endmodule