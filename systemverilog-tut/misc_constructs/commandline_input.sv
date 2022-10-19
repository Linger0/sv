module tb;
  initial begin
    string var1;
    bit [31:0] data;

    if ($value$plusargs("STRING=%s", var1))
      $display("STRING with FS has a value %s", var1);

    if ($value$plusargs("NUMBER=", data))
      $display("NUMBER without FS has a value %d", data);
  end
endmodule