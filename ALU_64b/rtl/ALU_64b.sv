module ALU_64b
  import SRAM_PIM_pkg::*;
(
  input  logic [           63:0] pim_or,
  input  logic [           63:0] pim_and,
  input  logic [           63:0] pim_xor,
  input  logic [           63:0] reg2,
  input  logic [           63:0] reg3,
  input  logic [ALU_IMM_BIT-1:0] alu_asr_imm,

  input  logic [            1:0] alu_addrmode,
  input  logic [            1:0] alu_raddr1,
  input  logic [            1:0] alu_raddr2,
  input  logic [OPCODE_BIT -1:0] alu_opcode,
  input  logic [            1:0] alu_batch_len,

  output logic [           63:0] alu_res1,
  output logic [           63:0] alu_res2,

  // For the full line shift
  input  logic [            7:0] op1_from_left,
  input  logic [            7:0] op1_from_right,
  output logic [            7:0] op1_to_left,
  output logic [            7:0] op1_to_right
);

  logic [63:0] pim_data;
  logic [63:0] op1, op2;
  logic [63:0] op1_shift_1l;
  logic [63:0] op2_shift_2l;
  logic [63:0] osm_op1_andh, osm_op1_andl;
  logic [63:0] op1_mux, op2_mux;

  logic [63:0] osm_op2_maskh, osm_op2_maskl;
  logic [63:0] fulladd_cout;
  logic [63:0] fulladd_sum;
  logic [63:0] fulladd_cout1l;

  logic [63:0] or_gate, and_gate, xor_gate;
  logic [63:0] cla_p;
  logic [63:0] cla_g;
  logic [63:0] cla_x;
  logic [ 7:0] cla_cin;
  logic [ 7:0] cla_cout;
  logic [63:0] osd_op1;
  logic [63:0] cout2mask;
  logic [63:0] sadd_result;
  logic [63:0] sadi_result;
  logic [63:0] add_result;
  logic [63:0] osd_result;
  logic [63:0] asr_result;
  logic [63:0] lsl8_result;
  logic [63:0] lsr8_result;
  logic [63:0] uavg_result;

  /// Multiplex to select oprand

  assign pim_data = pim_and;

  assign op1 = alu_addrmode==ADDR_RSR ? pim_data : (
                    alu_raddr1==2'd0 ? 64'h0 :
                    alu_raddr1==2'd1 ? {64{1'b1}} :
                    alu_raddr1==2'd2 ? reg2 : reg3);
  assign op2 = alu_raddr2==2'd0 ? 64'h0 :
               alu_raddr2==2'd1 ? {64{1'b1}} :
               alu_raddr2==2'd2 ? reg2 : reg3;

  /// For OSM operation

  assign osm_op1_andh = (op1_shift_1l) & osm_op2_maskh;
  assign osm_op1_andl = (op1      ) & osm_op2_maskl;

  for (genvar j = 0; j < 64; j++) begin : gen_fulladd
    assign {fulladd_cout[j],fulladd_sum[j]} =
            osm_op1_andh[j] + osm_op1_andl[j] + op2_shift_2l[j];
  end

  // Extend the sign bit
  always_comb begin
    unique case (alu_batch_len)
      W64: begin
        osm_op2_maskh  = {64{op2[63]}};
        osm_op2_maskl  = {64{op2[62]}};
        op1_shift_1l   = op1 << 1;
        op2_shift_2l   = op2 << 2;
        fulladd_cout1l = fulladd_cout << 1;
      end
      W32: begin
        for (int j = 0; j < 2; j++) begin
          osm_op2_maskh [32*j+:32] = {32{op2[32*j+31]}};
          osm_op2_maskl [32*j+:32] = {32{op2[32*j+30]}};
          op1_shift_1l  [32*j+:32] = op1[32*j+:32] << 1;
          op2_shift_2l  [32*j+:32] = op2[32*j+:32] << 2;
          fulladd_cout1l[32*j+:32] = fulladd_cout[32*j+:32] << 1;
        end
      end
      W16: begin
        for (int j = 0; j < 4; j++) begin
          osm_op2_maskh [16*j+:16] = {16{op2[16*j+15]}};
          osm_op2_maskl [16*j+:16] = {16{op2[16*j+14]}};
          op1_shift_1l  [16*j+:16] = op1[16*j+:16] << 1;
          op2_shift_2l  [16*j+:16] = op2[16*j+:16] << 2;
          fulladd_cout1l[16*j+:16] = fulladd_cout[16*j+:16] << 1;
        end
      end
      /*W8*/ default: begin
        for (int j = 0; j < 8; j++) begin
          osm_op2_maskh [8*j+:8] = {8{op2[8*j+7]}};
          osm_op2_maskl [8*j+:8] = {8{op2[8*j+6]}};
          op1_shift_1l  [8*j+:8] = op1[8*j+:8] << 1;
          op2_shift_2l  [8*j+:8] = op2[8*j+:8] << 2;
          fulladd_cout1l[8*j+:8] = fulladd_cout[8*j+:8] << 1;
        end
      end
    endcase
  end

  // 2 operands
  assign op1_mux = alu_opcode==ALU_OSM ? fulladd_cout1l : op1;
  assign op2_mux = alu_opcode==ALU_OSM ? fulladd_sum : op2;

  // or/and/xor
  assign  or_gate = op1_mux | op2_mux;
  assign and_gate = op1_mux & op2_mux;
  assign xor_gate = op1_mux ^ op2_mux;

  assign cla_cin = {8{alu_opcode==ALU_ADI  |alu_opcode==ALU_SADI|
                      alu_opcode==ALU_M_ADI|alu_opcode==ALU_OSD}};
  assign cla_p = alu_addrmode==ADDR_RSS ? pim_or  : or_gate;
  assign cla_g = alu_addrmode==ADDR_RSS ? pim_and : and_gate;
  assign cla_x = alu_addrmode==ADDR_RSS ? pim_xor : xor_gate;

  ALU_Add_pgx2sum u_CLA(
  	.p_i        (cla_p        ),
    .g_i        (cla_g        ),
    .x_i        (cla_x        ),
    .c_i        (cla_cin        ),
    .op_width_i (alu_batch_len ),
    .s_o        (add_result        ),
    .c_o        (cla_cout        )
  );

  // Extend the carry output
  for (genvar i = 0; i < 8; i++) begin : gen_cout2mask
    assign cout2mask[8*i+:8] = {8{cla_cout[i]}};
  end

  assign sadd_result = add_result | cout2mask;
  assign sadi_result = add_result & cout2mask;

  /// For OSD operation

  for (genvar i = 0; i < 8; i++) begin : gen_osd_op1
    assign osd_op1[8*i+:8] = cla_cout[i] ? add_result[8*i+:8] : op1[8*i+:8];
  end

  // OSD/UAVG shift operation
  always_comb begin
    unique case (alu_batch_len)
      W64: begin
        osd_result  = {osd_op1[62:0],cla_cout[7]};
        uavg_result = {1'b0,add_result[63:1]};
      end

      W32: begin
        for (int i = 0; i < 2; i++) begin
          osd_result [32*i+:32] = {osd_op1[32*i+:31],cla_cout[4*i+3]};
          uavg_result[32*i+:32] = {1'b0,add_result[(32*i+1)+:31]};
        end
      end

      W16: begin
        for (int i = 0; i < 4; i++) begin
          osd_result [16*i+:16] = {osd_op1[16*i+:15],cla_cout[2*i+1]};
          uavg_result[16*i+:16] = {1'b0,add_result[(16*i+1)+:15]};
        end
      end

      /*W8*/ default: begin
        for (int i = 0; i < 8; i++) begin
          osd_result [8*i+:8] = {osd_op1[8*i+:7],cla_cout[i]};
          uavg_result[8*i+:8] = {1'b0,add_result[(8*i+1)+:7]};
        end
      end
    endcase
  end

  // Arithmetic shift right
  always_comb begin
    unique case (alu_batch_len)
      W64: begin
        case (1'b1)
          alu_asr_imm[5]: asr_result = $signed(op1) >>> 32;
          alu_asr_imm[4]: asr_result = $signed(op1) >>> 16;
          alu_asr_imm[3]: asr_result = $signed(op1) >>> 8;
          alu_asr_imm[2]: asr_result = $signed(op1) >>> 4;
          alu_asr_imm[1]: asr_result = $signed(op1) >>> 2;
          alu_asr_imm[0]: asr_result = $signed(op1) >>> 1;
          default       : asr_result = $signed(op1);
        endcase
      end

      W32: begin
        for (int i = 0; i < 2; i++) begin
          case (1'b1)
            alu_asr_imm[4]: asr_result[32*i+:32] = $signed(op1[32*i+:32]) >>> 16;
            alu_asr_imm[3]: asr_result[32*i+:32] = $signed(op1[32*i+:32]) >>> 8;
            alu_asr_imm[2]: asr_result[32*i+:32] = $signed(op1[32*i+:32]) >>> 4;
            alu_asr_imm[1]: asr_result[32*i+:32] = $signed(op1[32*i+:32]) >>> 2;
            alu_asr_imm[0]: asr_result[32*i+:32] = $signed(op1[32*i+:32]) >>> 1;
            default       : asr_result[32*i+:32] = $signed(op1[32*i+:32]);
          endcase
        end
      end

      W16: begin
        for (int i = 0; i < 4; i++) begin
          case (1'b1)
            alu_asr_imm[3]: asr_result[16*i+:16] = $signed(op1[16*i+:16]) >>> 8;
            alu_asr_imm[2]: asr_result[16*i+:16] = $signed(op1[16*i+:16]) >>> 4;
            alu_asr_imm[1]: asr_result[16*i+:16] = $signed(op1[16*i+:16]) >>> 2;
            alu_asr_imm[0]: asr_result[16*i+:16] = $signed(op1[16*i+:16]) >>> 1;
            default       : asr_result[16*i+:16] = $signed(op1[16*i+:16]);
          endcase
        end
      end

      /*W8*/ default: begin
        for (int i = 0; i < 8; i++) begin
          case (1'b1)
            alu_asr_imm[2]: asr_result[8*i+:8] = $signed(op1[8*i+:8]) >>> 4;
            alu_asr_imm[1]: asr_result[8*i+:8] = $signed(op1[8*i+:8]) >>> 2;
            alu_asr_imm[0]: asr_result[8*i+:8] = $signed(op1[8*i+:8]) >>> 1;
            default       : asr_result[8*i+:8] = $signed(op1[8*i+:8]);
          endcase
        end
      end
    endcase
  end

  assign lsl8_result = {op1[55:0],op1_from_right};
  assign lsr8_result = {op1_from_left,op1[63:8]};

  assign op1_to_left = op1[63:56];
  assign op1_to_right = op1[7:0];

  /// output

  assign alu_res2 = add_result;

  always_comb begin
    case (alu_opcode)
      ALU_OR   : alu_res1 = cla_p;
      ALU_AND  : alu_res1 = cla_g;
      ALU_XOR  : alu_res1 = cla_x;
      ALU_ADD  ,
      ALU_ADI  ,
      ALU_OSM  : alu_res1 = add_result;
      ALU_M_ADD: alu_res1 = cout2mask;
      ALU_M_ADI: alu_res1 = ~cout2mask;
      ALU_UAVG : alu_res1 = uavg_result;
      ALU_SADD : alu_res1 = sadd_result;
      ALU_SADI : alu_res1 = sadi_result;
      ALU_OSD  : alu_res1 = osd_result;
      ALU_ASR  : alu_res1 = asr_result;
      ALU_LSL8 : alu_res1 = lsl8_result;
      ALU_LSR8 : alu_res1 = lsr8_result;
      default  : alu_res1 = add_result;
    endcase
  end

endmodule
