// module tb;
//   shortint  var_a;
//   int       var_b;
//   longint   var_c;

//   initial begin
//     $display("Sizes var_a=%0d var_b=%0d var_c=%0d", $bits(var_a), $bits(var_b), $bits(var_c));

//     #1
//     var_a = 'hFFFF;
//     var_b = 'hFFFF_FFFF;
//     var_c = 'hFFFF_FFFF_FFFF_FFFF;

//     #1
//     var_a += 1;
//     var_b += 1;
//     var_c += 1;
//   end

//   initial begin
//     $monitor("var_a=%0d var_b=%0d var_c=%0d", var_a, var_b, var_c);
//   end
// endmodule

module tb;
  byte          s_byte;
  byte unsigned u_byte;

  initial begin
    $display("Size s_byte=%0d u_byte=%0d", $bits(s_byte), $bits(u_byte ));

    #1  s_byte = 'h7f;
        u_byte = 'h7f;

    #1  s_byte += 1;
        u_byte += 1;

    #1  u_byte = 'hff;
    #1  u_byte += 1;
  end

  initial begin
    $monitor("[%0t ns] s_byte=%0d u_byte=%0d", $time, s_byte, u_byte);
  end
endmodule