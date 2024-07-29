/*
Write a markdown documentation for this systemverilog module:
Author : Foez Ahmed (foez.official@gmail.com)
*/

//`include "addr_map.svh"
//`include "axi4l_assign.svh"
//`include "axi4l_typedef.svh"
//`include "axi4_assign.svh"
//`include "axi4_typedef.svh"
//`include "default_param_pkg.sv"

`include "rv_g_pkg.sv"

module rv_g_instdec
  import rv_g_pkg::*;
#(
    parameter type decoded_instr_t = rv_g_pkg::decoded_instr_t
) (
    input logic [31:0] code_i,

    output decoded_instr_t cmd_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [ 4:0] rd;
  logic [ 4:0] rs1;
  logic [ 4:0] rs2;
  logic [ 4:0] rs3;

  logic [31:0] bimm;
  logic [31:0] iimm;
  logic [31:0] jimm;
  logic [31:0] simm;
  logic [31:0] uimm;
  logic [31:0] cimm;
  logic [31:0] aimm;

  wand  [19:0] intr_func;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign rd          = code_i[11:7];
  assign rs1         = code_i[19:15];
  assign rs2         = code_i[24:20];
  assign rs3         = code_i[31:27];

  assign bimm[0]     = '0;
  assign bimm[4:1]   = code_i[11:8];
  assign bimm[10:5]  = code_i[30:25];
  assign bimm[11]    = code_i[7];
  assign bimm[12]    = code_i[31];
  assign bimm[31:13] = {19{code_i[31]}};

  assign iimm[11:0]  = code_i[31:20];
  assign iimm[31:12] = {20{code_i[31]}};

  assign jimm[0]     = '0;
  assign jimm[10:1]  = code_i[30:21];
  assign jimm[19:12] = code_i[19:12];
  assign jimm[11]    = code_i[20];
  assign jimm[20]    = code_i[31];
  assign jimm[31:21] = {11{code_i[31]}};

  assign simm[4:0]   = code_i[11:7];
  assign simm[11:5]  = code_i[31:25];
  assign simm[31:12] = {20{code_i[31:25]}};

  assign uimm[11:0]  = '0;
  assign uimm[31:12] = code_i[31:12];

  assign cimm[11:0]  = code_i[31:20];
  assign cimm[16:12] = code_i[19:15];
  assign cimm[31:17] = '0;

  assign aimm[5:0]   = code_i[25:20];
  assign aimm[31:6]  = '0;

  assign intr_func   = ((code_i & 32'h0000007F) == 32'h00000037) ? i_LUI : '1;
  assign intr_func   = ((code_i & 32'h0000007F) == 32'h00000017) ? i_AUIPC : '1;
  assign intr_func   = ((code_i & 32'h0000007F) == 32'h0000006F) ? i_JAL : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00000067) ? i_JALR : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00000063) ? i_BEQ : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00001063) ? i_BNE : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00004063) ? i_BLT : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00005063) ? i_BGE : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00006063) ? i_BLTU : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00007063) ? i_BGEU : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00000003) ? i_LB : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00001003) ? i_LH : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00002003) ? i_LW : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00004003) ? i_LBU : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00005003) ? i_LHU : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00000023) ? i_SB : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00001023) ? i_SH : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00002023) ? i_SW : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00000013) ? i_ADDI : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00002013) ? i_SLTI : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00003013) ? i_SLTIU : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00004013) ? i_XORI : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00006013) ? i_ORI : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00007013) ? i_ANDI : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h00001013) ? i_SLLI : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h00005013) ? i_SRLI : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h40005013) ? i_SRAI : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h00000033) ? i_ADD : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h40000033) ? i_SUB : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h00001033) ? i_SLL : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h00002033) ? i_SLT : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h00003033) ? i_SLTU : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h00004033) ? i_XOR : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h00005033) ? i_SRL : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h40005033) ? i_SRA : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h00006033) ? i_OR : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h00007033) ? i_AND : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h0000000F) ? i_FENCE : '1;
  assign intr_func   = ((code_i & 32'hFFFFFFFF) == 32'h8330000F) ? i_FENCE_TSO : '1;
  assign intr_func   = ((code_i & 32'hFFFFFFFF) == 32'h0100000F) ? i_PAUSE : '1;
  assign intr_func   = ((code_i & 32'hFFFFFFFF) == 32'h00000073) ? i_ECALL : '1;
  assign intr_func   = ((code_i & 32'hFFFFFFFF) == 32'h00100073) ? i_EBREAK : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00006003) ? i_LWU : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00003003) ? i_LD : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00003023) ? i_SD : '1;
  assign intr_func   = ((code_i & 32'hFC00707F) == 32'h00001013) ? i_SLLI : '1;
  assign intr_func   = ((code_i & 32'hFC00707F) == 32'h00005013) ? i_SRLI : '1;
  assign intr_func   = ((code_i & 32'hFC00707F) == 32'h40005013) ? i_SRAI : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h0000001B) ? i_ADDIW : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h0000101B) ? i_SLLIW : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h0000501B) ? i_SRLIW : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h4000501B) ? i_SRAIW : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h0000003B) ? i_ADDW : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h4000003B) ? i_SUBW : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h0000103B) ? i_SLLW : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h0000503B) ? i_SRLW : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h4000503B) ? i_SRAW : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h0000100F) ? i_FENCE_I : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00001073) ? i_CSRRW : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00002073) ? i_CSRRS : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00003073) ? i_CSRRC : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00005073) ? i_CSRRWI : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00006073) ? i_CSRRSI : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00007073) ? i_CSRRCI : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h02000033) ? i_MUL : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h02001033) ? i_MULH : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h02002033) ? i_MULHSU : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h02003033) ? i_MULHU : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h02004033) ? i_DIV : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h02005033) ? i_DIVU : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h02006033) ? i_REM : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h02007033) ? i_REMU : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h0200003B) ? i_MULW : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h0200403B) ? i_DIVW : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h0200503B) ? i_DIVUW : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h0200603B) ? i_REMW : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h0200703B) ? i_REMUW : '1;
  assign intr_func   = ((code_i & 32'hF9F0707F) == 32'h1000202F) ? i_LR_W : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'h1800202F) ? i_SC_W : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'h0800202F) ? i_AMOSWAP_W : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'h0000202F) ? i_AMOADD_W : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'h2000202F) ? i_AMOXOR_W : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'h6000202F) ? i_AMOAND_W : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'h4000202F) ? i_AMOOR_W : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'h8000202F) ? i_AMOMIN_W : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'hA000202F) ? i_AMOMAX_W : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'hC000202F) ? i_AMOMINU_W : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'hE000202F) ? i_AMOMAXU_W : '1;
  assign intr_func   = ((code_i & 32'hF9F0707F) == 32'h1000302F) ? i_LR_D : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'h1800302F) ? i_SC_D : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'h0800302F) ? i_AMOSWAP_D : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'h0000302F) ? i_AMOADD_D : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'h2000302F) ? i_AMOXOR_D : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'h6000302F) ? i_AMOAND_D : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'h4000302F) ? i_AMOOR_D : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'h8000302F) ? i_AMOMIN_D : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'hA000302F) ? i_AMOMAX_D : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'hC000302F) ? i_AMOMINU_D : '1;
  assign intr_func   = ((code_i & 32'hF800707F) == 32'hE000302F) ? i_AMOMAXU_D : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00002007) ? i_FLW : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00002027) ? i_FSW : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h00000043) ? i_FMADD_S : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h00000047) ? i_FMSUB_S : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h0000004B) ? i_FNMSUB_S : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h0000004F) ? i_FNMADD_S : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h00000053) ? i_FADD_S : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h08000053) ? i_FSUB_S : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h10000053) ? i_FMUL_S : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h18000053) ? i_FDIV_S : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h58000053) ? i_FSQRT_S : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h20000053) ? i_FSGNJ_S : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h20001053) ? i_FSGNJN_S : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h20002053) ? i_FSGNJX_S : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h28000053) ? i_FMIN_S : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h28001053) ? i_FMAX_S : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC0000053) ? i_FCVT_W_S : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC0100053) ? i_FCVT_WU_S : '1;
  assign intr_func   = ((code_i & 32'hFFF0707F) == 32'hE0000053) ? i_FMV_X_W : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'hA0002053) ? i_FEQ_S : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'hA0001053) ? i_FLT_S : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'hA0000053) ? i_FLE_S : '1;
  assign intr_func   = ((code_i & 32'hFFF0707F) == 32'hE0001053) ? i_FCLASS_S : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD0000053) ? i_FCVT_S_W : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD0100053) ? i_FCVT_S_WU : '1;
  assign intr_func   = ((code_i & 32'hFFF0707F) == 32'hF0000053) ? i_FMV_W_X : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC0200053) ? i_FCVT_L_S : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC0300053) ? i_FCVT_LU_S : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD0200053) ? i_FCVT_S_L : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD0300053) ? i_FCVT_S_LU : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00003007) ? i_FLD : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00003027) ? i_FSD : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h02000043) ? i_FMADD_D : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h02000047) ? i_FMSUB_D : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h0200004B) ? i_FNMSUB_D : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h0200004F) ? i_FNMADD_D : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h02000053) ? i_FADD_D : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h0A000053) ? i_FSUB_D : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h12000053) ? i_FMUL_D : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h1A000053) ? i_FDIV_D : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h5A000053) ? i_FSQRT_D : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h22000053) ? i_FSGNJ_D : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h22001053) ? i_FSGNJN_D : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h22002053) ? i_FSGNJX_D : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h2A000053) ? i_FMIN_D : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h2A001053) ? i_FMAX_D : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h40100053) ? i_FCVT_S_D : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h42000053) ? i_FCVT_D_S : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'hA2002053) ? i_FEQ_D : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'hA2001053) ? i_FLT_D : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'hA2000053) ? i_FLE_D : '1;
  assign intr_func   = ((code_i & 32'hFFF0707F) == 32'hE2001053) ? i_FCLASS_D : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC2000053) ? i_FCVT_W_D : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC2100053) ? i_FCVT_WU_D : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD2000053) ? i_FCVT_D_W : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD2100053) ? i_FCVT_D_WU : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC2200053) ? i_FCVT_L_D : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC2300053) ? i_FCVT_LU_D : '1;
  assign intr_func   = ((code_i & 32'hFFF0707F) == 32'hE2000053) ? i_FMV_X_D : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD2200053) ? i_FCVT_D_L : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD2300053) ? i_FCVT_D_LU : '1;
  assign intr_func   = ((code_i & 32'hFFF0707F) == 32'hF2000053) ? i_FMV_D_X : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00004007) ? i_FLQ : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00004027) ? i_FSQ : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h06000043) ? i_FMADD_Q : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h06000047) ? i_FMSUB_Q : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h0600004B) ? i_FNMSUB_Q : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h0600004F) ? i_FNMADD_Q : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h06000053) ? i_FADD_Q : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h0E000053) ? i_FSUB_Q : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h16000053) ? i_FMUL_Q : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h1E000053) ? i_FDIV_Q : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h5E000053) ? i_FSQRT_Q : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h26000053) ? i_FSGNJ_Q : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h26001053) ? i_FSGNJN_Q : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h26002053) ? i_FSGNJX_Q : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h2E000053) ? i_FMIN_Q : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h2E001053) ? i_FMAX_Q : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h40300053) ? i_FCVT_S_Q : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h46000053) ? i_FCVT_Q_S : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h42300053) ? i_FCVT_D_Q : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h46100053) ? i_FCVT_Q_D : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'hA6002053) ? i_FEQ_Q : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'hA6001053) ? i_FLT_Q : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'hA6000053) ? i_FLE_Q : '1;
  assign intr_func   = ((code_i & 32'hFFF0707F) == 32'hE6001053) ? i_FCLASS_Q : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC6000053) ? i_FCVT_W_Q : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC6100053) ? i_FCVT_WU_Q : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD6000053) ? i_FCVT_Q_W : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD6100053) ? i_FCVT_Q_WU : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC6200053) ? i_FCVT_L_Q : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC6300053) ? i_FCVT_LU_Q : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD6200053) ? i_FCVT_Q_L : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD6300053) ? i_FCVT_Q_LU : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00001007) ? i_FLH : '1;
  assign intr_func   = ((code_i & 32'h0000707F) == 32'h00001027) ? i_FSH : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h04000043) ? i_FMADD_H : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h04000047) ? i_FMSUB_H : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h0400004B) ? i_FNMSUB_H : '1;
  assign intr_func   = ((code_i & 32'h0600007F) == 32'h0400004F) ? i_FNMADD_H : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h04000053) ? i_FADD_H : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h0C000053) ? i_FSUB_H : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h14000053) ? i_FMUL_H : '1;
  assign intr_func   = ((code_i & 32'hFE00007F) == 32'h1C000053) ? i_FDIV_H : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h5C000053) ? i_FSQRT_H : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h24000053) ? i_FSGNJ_H : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h24001053) ? i_FSGNJN_H : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h24002053) ? i_FSGNJX_H : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h2C000053) ? i_FMIN_H : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'h2C001053) ? i_FMAX_H : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h40200053) ? i_FCVT_S_H : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h44000053) ? i_FCVT_H_S : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h42200053) ? i_FCVT_D_H : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h44100053) ? i_FCVT_H_D : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h46200053) ? i_FCVT_Q_H : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'h44300053) ? i_FCVT_H_Q : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'hA4002053) ? i_FEQ_H : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'hA4001053) ? i_FLT_H : '1;
  assign intr_func   = ((code_i & 32'hFE00707F) == 32'hA4000053) ? i_FLE_H : '1;
  assign intr_func   = ((code_i & 32'hFFF0707F) == 32'hE4001053) ? i_FCLASS_H : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC4000053) ? i_FCVT_W_H : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC4100053) ? i_FCVT_WU_H : '1;
  assign intr_func   = ((code_i & 32'hFFF0707F) == 32'hE4000053) ? i_FMV_X_H : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD4000053) ? i_FCVT_H_W : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD4100053) ? i_FCVT_H_WU : '1;
  assign intr_func   = ((code_i & 32'hFFF0707F) == 32'hF4000053) ? i_FMV_H_X : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC4200053) ? i_FCVT_L_H : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hC4300053) ? i_FCVT_LU_H : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD4200053) ? i_FCVT_H_L : '1;
  assign intr_func   = ((code_i & 32'hFFF0007F) == 32'hD4300053) ? i_FCVT_H_LU : '1;
  assign intr_func   = ((code_i & 32'hFFFFFFFF) == 32'h00D00073) ? i_WRS_NTO : '1;
  assign intr_func   = ((code_i & 32'hFFFFFFFF) == 32'h01D00073) ? i_WRS_STO : '1;

  assign cmd_o.func  = func_t'(intr_func[9:0]);

  always_comb begin
    case ({
      intr_func[13], intr_func[10]
    })
      default cmd_o.rd = '0;
      'b01: cmd_o.rd = {1'b0, rd};
      'b10: cmd_o.rd = {1'b1, rd};
    endcase
  end

  always_comb begin
    case ({
      intr_func[14], intr_func[11]
    })
      default cmd_o.rs1 = '0;
      'b01: cmd_o.rs1 = {1'b0, rs1};
      'b10: cmd_o.rs1 = {1'b1, rs1};
    endcase
  end

  always_comb begin
    case ({
      intr_func[15], intr_func[12]
    })
      default cmd_o.rs2 = '0;
      'b01: cmd_o.rs2 = {1'b0, rs2};
      'b10: cmd_o.rs2 = {1'b1, rs2};
    endcase
  end

  always_comb begin
    case (intr_func[16])
      default cmd_o.rs3 = '0;
      'b1: cmd_o.rs3 = {1'b1, rs3};
    endcase
  end

  always_comb begin
    case (intr_func[19:17])
      default cmd_o.imm = '0;
      BIMM: cmd_o.imm = bimm;
      IIMM: cmd_o.imm = iimm;
      JIMM: cmd_o.imm = jimm;
      SIMM: cmd_o.imm = simm;
      UIMM: cmd_o.imm = uimm;
      CIMM: cmd_o.imm = cimm;
      AIMM: cmd_o.imm = cimm;
    endcase
  end

  assign cmd_o.rl  = code_i[25:25];
  assign cmd_o.aq  = code_i[26:26];
  assign cmd_o.rm  = code_i[14:12];

endmodule
