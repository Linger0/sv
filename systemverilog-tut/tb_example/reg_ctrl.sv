module reg_ctrl #(
  parameter ADDR_WIDTH  = 8,
  parameter DATA_WIDTH  = 16,
  parameter DEPTH       = 256,
  parameter RESET_VAL   = 16'h1234
) (
  input                   clk,
  input                   rst_n,
  input [ADDR_WIDTH-1:0]  addr,
  input                   sel,
  input                   wr,
  input [DATA_WIDTH-1:0]  wdata,
  output reg [DATA_WIDTH-1:0] rdata,
  output reg                  ready
);

  reg [DATA_WIDTH-1:0] ctrl[DEPTH];

  reg  ready_dly;
  wire ready_pe;

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      for (int i = 0; i < DEPTH; i += 1) begin
        ctrl[i] <= RESET_VAL;
      end
    end else begin
      if (sel & ready & wr) begin
        ctrl[addr] <= wdata;
      end

      if (sel & ready & !wr) begin
        rdata <= ctrl[addr];
      end else begin
        rdata <= 0;
      end
    end
  end

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      ready <= 1;
    end else begin
      if (sel & ready_pe) begin
        ready <= 1;
      end

      if (sel & ready & !wr) begin
        ready <= 0;
      end
    end
  end

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      ready_dly <= 1;
    end else begin
      ready_dly <= ready;
    end
  end

  assign ready_pe = ~ready & ready_dly;
endmodule