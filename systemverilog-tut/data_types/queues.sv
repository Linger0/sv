class Fruit;
  string name;

  function new(string name="Unknown");
    this.name = name;
  endfunction
endclass

module tb;
  Fruit list[$];

  initial begin
    Fruit f = new("Apple");
    list.push_back(f);

    f = new("Banana");
    list.push_back(f);

    foreach (list[i])
      $display("list[%0d] = %s", i, list[i].name);

    $display("list = %p", list);
  end
endmodule