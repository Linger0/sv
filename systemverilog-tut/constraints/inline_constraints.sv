class Item;
  rand bit [7:0] id;
  constraint id_c { id == 25; }
endclass

module tb;
  initial begin
    Item itm = new();
    if (!(itm.randomize() with { id < 10; }))
      $display("Randomization failed");
    $display("Item Id = %0d", itm.id);
  end
endmodule