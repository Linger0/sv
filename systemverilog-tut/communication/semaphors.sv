module tb_top;
  semaphore key;

  initial begin
    key = new(1);
    fork
      personA();
      personB();
      #25 personA();
    join_none
  end

  task getRoom(bit [1:0] id);
    $display("[%0t ns] Trying to get a room for id[%0d] ...", $time, id);
    key.get(1);
    $display("[%0t ns] Room key retrived for id[%0d] ...", $time, id);
  endtask

  task putRoom(bit [1:0] id);
    $display("[%0t ns] Leaving room id[%0d] ...", $time, id);
    key.put(1);
    $display("[%0t ns] Room key put back id[%0d]", $time, id);
  endtask

  task personA();
    getRoom(1);
    #20 putRoom(1);
  endtask

  task personB();
    #5 getRoom(2);
    #10 putRoom(2);
  endtask
endmodule