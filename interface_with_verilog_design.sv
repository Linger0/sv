module counter_ud #(
  parameter WIDTH = 4
) (
  input                   clk,
  input                   rstn,
  input wire [WIDTH-1:0]  load,
  input                   load_en,
  input                   down,
  output                  rollover,
  output reg [WIDTH-1:0]  count
);

  always @(posedge clk or negedge rstn) begin
    if (!rstn)
      count <= 0;
    else
      if (load_en)
        count <= load;
      else begin
        if (down)
          count <= count - 1;
        else
          count <= count + 1;
      end
  end

  assign rollover = &count;
endmodule

interface cnt_if #(parameter  WIDTH=4) (
  input bit clk
);
  logic             rstn;
  logic             load_en;
  logic [WIDTH-1:0] load;
  logic [WIDTH-1:0] count;
  logic             down;
  logic             rollover;
endinterface // cnt_if

module tb;
  reg clk;

  always #10 clk = ~clk;

  cnt_if cnt_if0 (clk);
  counter_ud c0 (.clk(cnt_if0.clk),
                 .rstn(cnt_if0.rstn),
                 .load(cnt_if0.load),
                 .load_en(cnt_if0.load_en),
                 .down(cnt_if0.down),
                 .rollover(cnt_if0.rollover),
                 .count(cnt_if0.count));

  initial begin
    bit load_en, down;
    bit [3:0] load;

    $monitor("[%0t] down=%0b load_en=%0b load=0x%0h count=0x%h rollover=%0b",
             $time, cnt_if0.down, cnt_if0.load_en, cnt_if0.load, cnt_if0.count, cnt_if0.rollover);

    clk <= 0;
    cnt_if0.rstn <= 0;
    cnt_if0.load_en <= 0;
    cnt_if0.load <= 0;
    cnt_if0.down <= 0;

    repeat (5) @(posedge clk);
    cnt_if0.rstn <= 1;
    for (int i = 0; i < 5; i++) begin
      static int delay = $urandom_range(1, 30);
      #(delay);

      std::randomize(load, load_en, down);

      cnt_if0.load <= load;
      cnt_if0.load_en <= load_en;
      cnt_if0.down <= down;
    end

    repeat (5) @(posedge clk);
    $finish;
  end
endmodule