package my_pkg;
  typedef enum bit [1:0] { RED, YELLOW, GREEN, RSVD } e_signal;
  typedef struct {
    bit [3:0] signal_id;
    bit active;
    bit [1:0] timeout;
  } e_sig_param;

  function common ();
    $display("Call for somewhere");
  endfunction

  task run();
  endtask
endpackage

import my_pkg::*;

class MyClass;
  e_signal my_sig;
endclass

module tb;
  MyClass cls;
  initial begin
    cls = new();
    cls.my_sig = GREEN;
    $display("my_sig=%s", cls.my_sig.name());
    common();
  end
endmodule