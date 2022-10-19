typedef mailbox #(string) s_mbox;

class comp1;
  s_mbox names;
  task send();
    for (int i = 0; i < 3; i++) begin
      string s = $sformatf("name_%0d", i);
      #1 $display("[%0t] Comp1: put %s", $time, s);
      names.put(s);
    end
  endtask
endclass

class comp2;
  s_mbox list;
  task receive();
    forever begin
      string s;
      list.get(s);
      $display("[%0t] Comp2: got %s", $time, s);
    end
  endtask
endclass

module tb;
  s_mbox m_mbx = new();
  comp1 m_comp1 = new();
  comp2 m_comp2 = new();

  initial begin
    m_comp1.names = m_mbx;
    m_comp2.list = m_mbx;

    fork
      m_comp1.send();
      m_comp2.receive();
    join

  end
endmodule