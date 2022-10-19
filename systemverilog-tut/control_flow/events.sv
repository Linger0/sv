// module tb;
//   event event_a;

//   initial begin
//     #20 ->event_a;
//     $display("[%0t] Thread1: triggered event_a", $time);
//   end

//   initial begin
//     $display("[%0t] Thread2: waiting for trigger", $time);
//     @(event_a);
//     $display("[%0t] Thread2: received event_a trigger", $time);
//   end

//   initial begin
//     $display("[%0t] Thread3: waiting for trigger", $time);
//     wait(event_a.triggered);
//     $display("[%0t] Thread3: received event_a trigger", $time);
//   end
// endmodule

module tb;
  event event_a, event_b;

  initial begin
    fork
      begin
        wait(event_a.triggered);
        $display("[%0t] Thread1: Wait for event_a is over", $time);
      end
      begin
        wait(event_b.triggered);
        $display("[%0t] Thread2: Wait for event_b is over", $time);
      end
      #20 ->event_a;
      #30 ->event_b;
      begin
        #10 event_b = event_a;
      end
    join
  end
endmodule