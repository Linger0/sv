// module des;
//   initial begin
//     display();
//   end

//   task display();
//     $display("Hello World");
//   endtask
// endmodule

// module tb;
//   des u0();

//   initial u0.display();
// endmodule

module tb;
  initial display();

  initial begin
    #50 disable display.T_TASK;
  end

  task display();
    begin : T_TASK
      $display("[%0t] T_Task started", $time);
      #100;
      $display("[%0t] T_Task ended", $time);
    end

    begin : S_TASK
      $display("[%0t] S_Task started", $time);
      #20;
      $display("[%0t] S_Task ended", $time);
    end
  endtask
endmodule