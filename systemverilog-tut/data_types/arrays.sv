module tb;
  bit [3:0][7:0] stack[2][4];

  initial begin
    foreach(stack[i])
      foreach(stack[i][j]) begin
        stack[i][j] = $random;
        $display("stack[%0d][%0d] = 0x%0h", i, j, stack[i][j]);
      end

    $display("stack = %p", stack);
    $display("stack[0][0][2] = 0x%0h", stack[0][0][2]);

  end
endmodule

// module tb;
//   int array[];
//   int id[];

//   initial begin
//     array = new[5];
//     array = '{1, 2, 3, 4, 5};

//     id = array;

//     $display("id = %p", id );

//     id = new[id.size() + 1](id);

//     id[id.size() - 1] = 6;

//     $display("New id = %p", id);
//     $display("array.size() = %0d, id.size() = %0d", array.size(), id.size());
//   end
// endmodule

// module tb;
//   int fruits_l0[string];

//   initial begin
//     fruits_l0 = '{"apple": 4,
//                   "orange": 10,
//                   "plum": 9,
//                   "guava": 1};

//     $display("fruits_l0.size() = %0d", fruits_l0.size());
//     $display("fruits_l0.num() = %0d", fruits_l0.num());

//     if (fruits_l0.exists("orange"));
//       $display("Found %0d orange!", fruits_l0["orange"]);

//     if (!fruits_l0.exists("apricots"))
//       $display("Sorry, season for apricots is over...");

//     begin
//       string f;
//       if (fruits_l0.first(f))
//         $display("fruits_l0.first[%s] = %0d", f, fruits_l0[f]);
//     end

//     begin
//       string f;
//       if (fruits_l0.last(f))
//         $display("fruits_l0.last[%s] = %0d", f, fruits_l0[f]);
//     end

//     begin
//       string f = "orange";
//       if (fruits_l0.prev(f))
//         $display("fruits_l0.prev[%s] = %0d", f, fruits_l0[f]);
//     end

//     begin
//       string f = "orange";
//       if (fruits_l0.next(f))
//         $display("fruits_l0.next[%s] = %0d", f, fruits_l0[f]);
//     end

//   end
// endmodule