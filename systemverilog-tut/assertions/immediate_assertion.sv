// interface my_if (input bit clk);
//   logic pop;
//   logic push;
//   logic full;
//   logic empty;
// endinterface

// module my_des (my_if _if);
//   always @(posedge _if.clk) begin
//     if (_if.push) begin
//       a_push: assert(!_if.full) begin
//         $display("[PASS] push when fifo not full");
//       end else begin
//         $display("[FAIL] push when fifo full!");
//       end
//     end

//     if (_if.pop) begin
//       a_pop: assert(!_if.empty) begin
//         $display("[PASS] pop when fifo not empty");
//       end else begin
//         $display("[FAIL] pop when fifo empty!");
//       end
//     end
//   end
// endmodule

// module tb;
//   bit clk;
//   always #10 clk = ~clk;

//   my_if _if (clk);
//   my_des dut (.*);

//   initial begin
//     for (int i = 0; i < 5; i++) begin
//       _if.push <= $random;
//       _if.pop <= $random;
//       _if.empty <= $random;
//       _if.full <= $random;
//       $strobe("[%0t] push=%0b full=%0b pop=%0b empty=%0b", $time, _if.push, _if.full, _if.pop, _if.empty);
//       @(posedge clk);
//     end
//     #10 $finish;
//   end
// endmodule

class Packet;
  rand bit [7:0] addr;
  constraint c_addr { addr > 5; addr < 3; }
endclass

module tb;
  initial begin
    Packet m_pkt = new;
    assert(m_pkt.randomize());
  end
endmodule