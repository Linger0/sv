class MyPacket;
  rand  bit [1:0] mode;
  randc bit [2:0] key;

  constraint c_mode1 {mode < 3;}
  constraint c_key1 {key > 2; key < 7;}

  function display();
    $display("Mode : 0x%0h key : 0x%0h", mode, key);
  endfunction
endclass

module tb_top;
  MyPacket pkt;
  initial begin
    pkt = new();

    for (int i = 0; i < 15; i++) begin
      assert(pkt.randomize());
      pkt.display();
    end
  end
endmodule