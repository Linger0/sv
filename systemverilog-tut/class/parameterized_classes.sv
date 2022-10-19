class stack #(type T = int);
  T item;

  function T add_a(T a);
    return item + a;
  endfunction
endclass

module tb;
  stack st;
  stack #(bit [3:0]) bs;
  stack #(real) rs;

  initial begin
    st = new;
    bs = new;
    rs = new;

    st.item = -456;
    $display("st.item = %0d", st.add_a(10));

    bs.item = 8'hA1;
    $display("bs.item = %0d", bs.add_a(10));

    rs.item = 3.14;
    $display("rs.item = %0.2f", rs.add_a(10));
  end
endmodule