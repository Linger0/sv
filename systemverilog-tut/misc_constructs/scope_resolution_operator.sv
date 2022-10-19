package my_pkg;
  typedef enum bit {FALSE, TRUE} e_bool;
endpackage

module tb;
  my_pkg::e_bool val;
  initial begin
    val = my_pkg::TRUE;
    $display("val=%0h name=%s", val, val.name());
  end
endmodule