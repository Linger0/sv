class Packet;
  int addr;

  function new(int addr);
    this.addr = addr;
  endfunction

  function display();
    $display("[Base] addr=0x%0h", addr);
  endfunction
endclass

class ExtPacket extends Packet;
  int data;

  function new(int addr, data);
    super.new(addr);
    this.data = data;
  endfunction

  function display();
    $display("[Child] addr=0x%0h data=0x%0h", addr, data);
  endfunction
endclass

// module tb;
//   Packet bc;
//   ExtPacket sc;

//   initial begin
//     sc = new(32'hfeed_feed, 32'h1234_5678);

//     bc = sc;

//     bc.display();
//     sc.display();
//   end
// endmodule

module tb;
  Packet bc;
  ExtPacket sc;

  initial begin
    ExtPacket sc2;
    bc = new(32'hface_face);
    sc = new(32'hfeed_feed, 32'h1234_5678);
    bc = sc;

    $cast(sc2, bc);

    sc2.display();
    $display("data=0x%0h", sc2.data);
  end
endmodule