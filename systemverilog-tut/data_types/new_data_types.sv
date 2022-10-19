// module tb;
//   logic [3:0] my_data;
//   logic       en;

//   initial begin
//     $display("my_data=0x%0h en=%0b", my_data, en);
//     my_data <= 4'hb;
//     $display("my_data=0x%0h en=%0b", my_data, en);
//     #1;
//     $display("my_data=0x%0h en=%0b", my_data, en);
//   end

//   assign en = my_data[0];
// endmodule

module tb;
  bit       var_a;
  bit [3:0] var_b;

  logic [3:0] x_val;

  initial begin
    $display("Initial value var_a=%0b var_b=0x%0h", var_a, var_b);

    var_a = 1;
    var_b = 'hf;
    $display("New values    var_a=%0b var_b=0x%0h", var_a, var_b);

    var_b = 16'h481a;
    $display("Truncated value: var_a=%0b var_b=0x%0h", var_a, var_b);

    var_b = 4'b01zx;
    $display("var_b = %b", var_b);
  end
endmodule