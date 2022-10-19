class Packet;
  int addr;

  function new(int addr);
    this.addr = addr;
  endfunction

  // function void display();
  virtual function void display();
    $display("[Base] addr=0x%0h", addr);
  endfunction
endclass

class ExtPacket extends Packet;
  int data;

  function new(int addr, data);
    super.new(addr);
    this.data = data;
  endfunction

  function void display();
    $display("[Child] addr=0x%0h data=0x%0h", addr, data);
  endfunction
endclass

module tb;
  Packet bc;
  ExtPacket sc;

  initial begin
    sc = new(32'hfeed_feed, 32'h1234_5678);
    bc = sc;
    bc.display();
  end
endmodule