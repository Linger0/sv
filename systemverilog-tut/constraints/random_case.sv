module tb;
  initial begin
    for (int i = 0; i < 10; i++) begin
      randcase
        1: $display("WT: 1");
        5: $display("WT: 5");
        3: $display("WT: 3");
      endcase
    end
  end
endmodule