module ALU_Add_pgx2sum (
  input  logic [63:0] p_i,
  input  logic [63:0] g_i,
  input  logic [63:0] x_i,
  input  logic [ 7:0] c_i,
  input  logic [ 1:0] op_width_i,  // 64,32,16,8
  output logic [63:0] s_o,
  output logic [ 7:0] c_o
);
  import SRAM_PIM_pkg::*;
  genvar j;

  logic [63:0] p;
  logic [63:0] g;
  logic [64:0] c;

  logic group8_n;
  logic group16_n;
  logic group32_n;
  logic group64_n;
  logic group8;
  logic group16;
  logic group32;
  logic group64;

  assign group8 = op_width_i==W8;
  assign group16 = op_width_i==W16;
  assign group32 = op_width_i==W32;
  assign group64 = op_width_i==W64;

  assign group8_n  = ~group8;
  assign group16_n = ~group16;
  assign group32_n = ~group32;
  assign group64_n = ~group64;

  // forbid to propogate
  always_comb begin : comb_p
    p = p_i;
    p[8]  = p_i[8]  & group8_n;
    p[16] = p_i[16] & group8_n & group16_n;
    p[24] = p_i[24] & group8_n;
    p[32] = p_i[32] & group64;
    p[40] = p_i[40] & group8_n;
    p[48] = p_i[48] & group8_n & group16_n;
    p[56] = p_i[56] & group8_n;
  end

  // insert carry bit
  always_comb begin : comb_g
    g = g_i;
    g[8]  = g_i[8]  | group8 & p_i[8]&c_i[1];
    g[16] = g_i[16] | (group8|group16) & p_i[16]&c_i[2];
    g[24] = g_i[24] | group8 & p_i[24]&c_i[3];
    g[32] = g_i[32] | group64_n & p_i[32]&c_i[4];
    g[40] = g_i[40] | group8 & p_i[40]&c_i[5];
    g[48] = g_i[48] | (group8|group16) & p_i[48]&c_i[6];
    g[56] = g_i[56] | group8 & p_i[56]&c_i[7];
  end

  // OUTPUT carry bit
  always_comb begin : comb_c
    c_o = {8{c[64]}};
    unique if (group8) begin
      c_o = {c[64],c[56],c[48],c[40],c[32],c[24],c[16],c[8]};
    end else if (group16) begin
      c_o[1:0] = {2{c[16]}};
      c_o[3:2] = {2{c[32]}};
      c_o[5:4] = {2{c[48]}};
      c_o[7:6] = {2{c[64]}};
    end else if (group32) begin
      c_o[3:0] = {4{c[32]}};
      c_o[7:4] = {4{c[64]}};
    end else begin
      c_o = {8{c[64]}};
    end
  end

  // OUTPUT sum
  always_comb begin : comb_sum
    s_o = x_i ^ c[63:0];
    s_o[8] = x_i[8] ^ (c[8]&group8_n | c_i[1]&group8);
    s_o[16] = x_i[16] ^
              (c[16]&group8_n&group16_n | c_i[2]&group32_n&group64_n);
    s_o[24] = x_i[24] ^ (c[24]&group8_n | c_i[3]&group8);
    s_o[32] = x_i[32] ^ (c[32]&group64 | c_i[4]&group64_n);
    s_o[40] = x_i[40] ^ (c[40]&group8_n | c_i[5]&group8);
    s_o[48] = x_i[48] ^
              (c[48]&group8_n&group16_n | c_i[6]&group32_n&group64_n);
    s_o[56] = x_i[56] ^ (c[56]&group8_n | c_i[7]&group8);
  end

  //
  // Normal 64-bit lookahead carry unit
  //

  // Level 1: 16 blocks
  logic [15:0] P1, G1;
  logic [15:0] C2; // from the 2nd level
  generate
    for (j = 0; j < 15; j++) begin : gen_level1
      gen4_cpg u_cpg_l1 (
        .p_i(p[(j*4)+:4]),
        .g_i(g[(j*4)+:4]),
        .c_i(C2[j]),
        .c_o(c[(j*4)+:4]), // output
        .P_o(P1[j]),
        .G_o(G1[j])
      );
    end
  endgenerate

  gen4_c4 u_c4pg_l1 (
    .p_i(p[60+:4]),
    .g_i(g[60+:4]),
    .c_i(C2[15]),
    .c_o(c[60+:5]), // output including the MSB
    .P_o(P1[15]),
    .G_o(G1[15])
  );

  // Level 2: 4 blocks
  logic [3:0] P2, G2;
  logic [3:0] C3; // from the 3rd level
  generate
    for (j = 0; j < 4; j++) begin : gen_level2
      gen4_cpg u_cpg_l2 (
        .p_i(P1[(j*4)+:4]),
        .g_i(G1[(j*4)+:4]),
        .c_i(C3[j]),
        .c_o(C2[(j*4)+:4]),
        .P_o(P2[j]),
        .G_o(G2[j])
      );
    end
  endgenerate

  // Level 3: 1 block, last level
// verilator lint_off PINCONNECTEMPTY
  gen4_cpg u_c3_l3 (
    .p_i(P2),
    .g_i(G2),
    .c_i(c_i[0]),
    .c_o(C3),
    .P_o(),
    .G_o()
  );
// verilator lint_on PINCONNECTEMPTY

endmodule

// verilator lint_off DECLFILENAME
module gen4_cpg (
  input  logic [3:0] p_i,
  input  logic [3:0] g_i,
  input  logic       c_i,
  output logic [3:0] c_o,
  output logic       P_o,
  output logic       G_o
);

  assign c_o[0] = c_i;
  assign c_o[1] = g_i[0] | p_i[0]&c_i;
  assign c_o[2] = g_i[1] | p_i[1]&g_i[0] | p_i[1]&p_i[0]&c_i;
  assign c_o[3] = g_i[2] | p_i[2]&g_i[1] | p_i[2]&p_i[1]&g_i[0] |
                  p_i[2]&p_i[1]&p_i[0]&c_i;
  assign P_o = p_i[3]&p_i[2]&p_i[1]&p_i[0];
  assign G_o = g_i[3] | p_i[3]&g_i[2] | p_i[3]&p_i[2]&g_i[1] |
               p_i[3]&p_i[2]&p_i[1]&g_i[0];

endmodule


module gen4_c4 (
  input  logic [3:0] p_i,
  input  logic [3:0] g_i,
  input  logic       c_i,
  output logic [4:0] c_o,
  output logic       P_o,
  output logic       G_o
);

  assign c_o[0] = c_i;
  assign c_o[1] = g_i[0] | p_i[0]&c_i;
  assign c_o[2] = g_i[1] | p_i[1]&g_i[0] | p_i[1]&p_i[0]&c_i;
  assign c_o[3] = g_i[2] | p_i[2]&g_i[1] | p_i[2]&p_i[1]&g_i[0] |
                  p_i[2]&p_i[1]&p_i[0]&c_i;
  assign P_o = p_i[3]&p_i[2]&p_i[1]&p_i[0];
  assign G_o = g_i[3] | p_i[3]&g_i[2] | p_i[3]&p_i[2]&g_i[1] |
               p_i[3]&p_i[2]&p_i[1]&g_i[0];
  assign c_o[4] = g_i[3] | p_i[3]&g_i[2] | p_i[3]&p_i[2]&g_i[1] |
                  p_i[3]&p_i[2]&p_i[1]&g_i[0] |
                  p_i[3]&p_i[2]&p_i[1]&p_i[0]&c_i;
endmodule
