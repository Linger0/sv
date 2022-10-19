// module tb;
//   bit [3:0] m_data;
//   bit       flag;

//   initial begin
//     for (int i = 0; i < 10; i++) begin
//       m_data = $random;

//       flag = m_data inside {[4:9]} ? 1 : 0;

//       if (m_data inside {[4:9]})
//         $display("m_data=%0d INSIDE [4:9], flag=%0d", m_data, flag);
//       else
//         $display("m_data=%0d OUTSIDE [4:9], flag=%0d", m_data, flag);
//     end
//   end
// endmodule

class Data;
  rand bit [15:0] m_addr;
  constraint c_addr { !(m_addr inside {[16'h4000:16'h4fff]}); }
endclass

module tb;
  initial begin
    Data data = new();
    repeat (5) begin
      data.randomize();
      $display("addr=0x%0h", data.m_addr);
    end
  end
endmodule