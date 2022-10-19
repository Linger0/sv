`timescale 1ns/1ns

module tb_div_gen_0;

  logic aclk;
  logic s_axis_divisor_tvalid;
  logic s_axis_divisor_tready;
  logic [31:0] s_axis_divisor_tdata;
  logic s_axis_dividend_tvalid;
  logic s_axis_dividend_tready;
  logic [31:0] s_axis_dividend_tdata;
  logic m_axis_dout_tvalid;
  logic [63:0] m_axis_dout_tdata;

  initial begin
    aclk = 0;
    forever #5 aclk = !aclk;
  end

  initial begin
    s_axis_divisor_tvalid = 0;
    #100;
    @(posedge aclk) #1
    s_axis_divisor_tvalid = 1;
    s_axis_divisor_tdata = 32'h11;
    wait (s_axis_divisor_tready);
    @(posedge aclk) #1
    s_axis_divisor_tvalid = 0;
  end

  initial begin
    s_axis_dividend_tvalid = 0;
    #100;
    @(posedge aclk) #1;
    @(posedge aclk) #1
    s_axis_dividend_tvalid = 1;
    s_axis_dividend_tdata = 32'h2222;
    wait (s_axis_dividend_tready);
    @(posedge aclk) #1
    s_axis_dividend_tvalid = 0;
  end

  logic [31:0] true_dout_quotient;
  assign true_dout_quotient = s_axis_dividend_tdata / s_axis_divisor_tdata;

  initial begin
    $display("Simulation begin.");
    #100
    wait (m_axis_dout_tvalid);
    $display($time,,s_axis_divisor_tdata,s_axis_dividend_tdata,,true_dout_quotient,,m_axis_dout_tdata[63:32]);
    #20
    $stop;
  end

  div_gen_0 dut (
    .aclk(aclk),                                      // input wire aclk
    .s_axis_divisor_tvalid(s_axis_divisor_tvalid),    // input wire s_axis_divisor_tvalid
    .s_axis_divisor_tready(s_axis_divisor_tready),    // output wire s_axis_divisor_tready
    .s_axis_divisor_tdata(s_axis_divisor_tdata),      // input wire [31 : 0] s_axis_divisor_tdata
    .s_axis_dividend_tvalid(s_axis_dividend_tvalid),  // input wire s_axis_dividend_tvalid
    .s_axis_dividend_tready(s_axis_dividend_tready),  // output wire s_axis_dividend_tready
    .s_axis_dividend_tdata(s_axis_dividend_tdata),    // input wire [31 : 0] s_axis_dividend_tdata
    .m_axis_dout_tvalid(m_axis_dout_tvalid),          // output wire m_axis_dout_tvalid
    .m_axis_dout_tdata(m_axis_dout_tdata)            // output wire [63 : 0] m_axis_dout_tdata
  );

endmodule