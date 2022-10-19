class Packet;
  // rand bit [3:0] d_array[];
  rand bit [3:0] queue[$];

  // constraint c_array {d_array.size() > 5; d_array.size() < 10;}
  // constraint c_val {
  //   foreach (d_array[i]) d_array[i] == i;
  // }
  constraint c_array { queue.size() == 4; }

  // function void display();
  //   foreach (d_array[i]) begin
  //     $display("d_array[%0d] = 0x%0h", i, d_array[i]);
  //   end
  // endfunction
endclass

module tb;
  Packet pkt;

  initial begin
    pkt = new();
    pkt.randomize();
    // pkt.display();
    $display("queue = %p", pkt.queue);
  end
endmodule