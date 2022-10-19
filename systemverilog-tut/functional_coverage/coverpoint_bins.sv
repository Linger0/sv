module tb;
  bit [2:0] mode;

  covergroup cg;
    coverpoint mode {
      // bins one = {1};
      // bins five = {5};
      bins range[2] = {[0:$]};
    }
  endgroup

  initial begin
    cg cg_inst = new;
    for (int i = 0; i < 5; i++) begin
      #10 mode = $random;
      $display("[%0t] mode = 0x%0h", $time, mode);
      cg_inst.sample();
    end
    $display("Coverage = %0.2f %%", cg_inst.get_inst_coverage());
  end
endmodule