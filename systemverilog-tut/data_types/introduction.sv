module tb;
  int myFIFO[8];
  int myArray[2][3];

  initial begin
    myFIFO[5] = 32'hface_cafe;
    myArray[1][1] = 7;

  foreach (myFIFO[i])
    $display("myFIFO[%0d] = 0x%0h", i, myFIFO[i]);

  foreach (myArray[i])
    foreach (myArray[i][j])
      $display("myArray[%d][%d] = %0d", i, j, myArray[i][j]);

  end
endmodule