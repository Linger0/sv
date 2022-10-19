class ABC;
  rand bit [3:0] mode;
  rand bit       mode_en;

  // constraint c_mode { mode inside {[4'h5:4'h8]} -> mode_en == 1; }
  constraint c_mode {
    if (mode inside {[4'h5:4'hB]}) {
      mode_en == 1;
    } else {
      if (mode == 4'h1) {
        mode_en == 1;
      } else {
        mode_en == 0;
      }
    }
  }
endclass

module tb;
  initial begin
    ABC abc = new;
    for (int i = 0; i < 10; i++) begin
      abc.randomize();
      $display("mode=%0d mode_en=%0d", abc.mode, abc.mode_en);
    end
  end
endmodule