`ifndef __PACKAGE
`define __PACKAGE

package SRAM_PIM_pkg;
// verilator lint_off UNUSED

  parameter ROW_BIT     = 4096;
  parameter WORD_BIT    = 16;
  parameter NUM_WORD    = ROW_BIT / WORD_BIT;

  parameter ALU_IMM_BIT = 6;
  parameter OPCODE_BIT  = 4;

  typedef enum logic [OPCODE_BIT-1:0] {
    ALU_AND   = 4'b0100,
    ALU_OR    = 4'b0101,
    ALU_XOR   = 4'b0110,
    ALU_LSR8  = 4'b0010,
    ALU_LSL8  = 4'b0011,
    ALU_ASR   = 4'b0001,
    ALU_ADD   = 4'b1000,
    ALU_ADI   = 4'b1001,
    ALU_UAVG  = 4'b0111,
    ALU_SADD  = 4'b1010,
    ALU_SADI  = 4'b1011,
    ALU_M_ADD = 4'b1100,
    ALU_M_ADI = 4'b1101,
    ALU_OSM   = 4'b1110,
    ALU_OSD   = 4'b1111
  } inst_opcode_e;

  typedef enum logic [1:0] {
    ADDR_RSS = 2'b00,
    ADDR_RSR = 2'b01,
    ADDR_RRR = 2'b10,
    ADDR_SRR = 2'b11
  } inst_addrmode_e;

  typedef enum logic [1:0] {
    W64 = 2'b00,
    W32 = 2'b01,
    W16 = 2'b10,
    W8  = 2'b11
  } inst_opwidth_e;

  typedef enum logic [1:0] {
    OMUX_NONE = 2'd0,
    OMUX_SRAM = 2'd1,
    OMUX_R2   = 2'd2,
    OMUX_R3   = 2'd3
  } omux_osel_e;

  typedef enum int {
    NR    = 'd0, // CD=0, NWR=1, NRD=0
    NW    = 'd1, // CD=0, NWR=0
    PR    = 'd2, // CD=1, NWR=1, NRD=0
    PWRSS = 'd3, // CD=1, NWR=0
    PWRSR = 'd4,
    PWRRR = 'd5,
    PWSRR = 'd6,
    NP    = 'd7, // Normal Pre-work mode: CD=0, NWR=1, NRD=1
    PPRSS = 'd8, // Pim Pre-work mode: CD=1, NWR=1, NRD=1
    PPRSR = 'd9,
    PPRRR = 'd10,
    PPSRR = 'd11
  } work_mode_index_e;

endpackage

// verilator lint_off DECLFILENAME
package Definitions;

  parameter SRAM_ROW_SIZE         = 256;
  parameter SRAM_COL_SIZE         = 256;
  parameter SRAM_BIT_WIDTH        = SRAM_COL_SIZE * 16;
  parameter SRAM_ROW_ADDR_BIT     = 8;
  parameter SRAM_COL_ADDR_BIT     = 8;
  parameter SRAM_BYTE_ACCESS_MODE = 1'b0;
  parameter SRAM_ALL_ACCESS_MODE  = 1'b1;

endpackage

`endif
