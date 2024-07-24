/*
Write a markdown documentation for this systemverilog module:
Author : Foez Ahmed (foez.official@gmail.com)
*/
`ifndef RV_G_PKG_SV__
`define RV_G_PKG_SV__

package rv_g_pkg;

  typedef enum logic {
    ____ = 0,
    KEEP = 1
  } keep_t;

  typedef enum logic [2:0] {
    NONE,  // NO IMMEDIATE
    BIMM,  // BTYPE INSTRUCTION IMMEDIATE
    IIMM,  // ITYPE INSTRUCTION IMMEDIATE
    JIMM,  // JTYPE INSTRUCTION IMMEDIATE
    SIMM,  // RTYPE INSTRUCTION IMMEDIATE
    UIMM,  // UTYPE INSTRUCTION IMMEDIATE
    CIMM   // CSR INSTRUCTION IMMEDIATE
  } imm_src_t;

  typedef enum logic [9:0] {
    INVALID,
    LUI,
    AUIPC,
    JAL,
    JALR,
    BEQ,
    BNE,
    BLT,
    BGE,
    BLTU,
    BGEU,
    LB,
    LH,
    LW,
    LBU,
    LHU,
    SB,
    SH,
    SW,
    ADDI,
    SLTI,
    SLTIU,
    XORI,
    ORI,
    ANDI,
    SLLI,
    SRLI,
    SRAI,
    ADD,
    SUB,
    SLL,
    SLT,
    SLTU,
    XOR,
    SRL,
    SRA,
    OR,
    AND,
    FENCE,
    FENCE_TSO,
    PAUSE,
    ECALL,
    EBREAK,
    LWU,
    LD,
    SD,
    ADDIW,
    SLLIW,
    SRLIW,
    SRAIW,
    ADDW,
    SUBW,
    SLLW,
    SRLW,
    SRAW,
    FENC_I,
    CSRRW,
    CSRRS,
    CSRRC,
    CSRRWI,
    CSRRSI,
    CSRRCI,
    MUL,
    MULH,
    MULHSU,
    MULHU,
    DIV,
    DIVU,
    REM,
    REMU,
    MULW,
    DIVW,
    DIVUW,
    REMW,
    REMUW,
    LR_W,
    SC_W,
    AMOSWAP_W,
    AMOADD_W,
    AMOXOR_W,
    AMOAND_W,
    AMOOR_W,
    AMOMIN_W,
    AMOMAX_W,
    AMOMINU_W,
    AMOMAXU_W,
    LR_D,
    SC_D,
    AMOSWAP_D,
    AMOADD_D,
    AMOXOR_D,
    AMOAND_D,
    AMOOR_D,
    AMOMIN_D,
    AMOMAX_D,
    AMOMINU_D,
    AMOMAXU_D,
    FLW,
    FSW,
    FMADD_S,
    FMSUB_S,
    FNMSUB_S,
    FNMADD_S,
    FADD_S,
    FSUB_S,
    FMUL_S,
    FDIV_S,
    FSQRT_S,
    FSGNJ_S,
    FSGNJN_S,
    FSGNJX_S,
    FMIN_S,
    FMAX_S,
    FEQ_S,
    FLT_S,
    FLE_S,
    FCLASS_S,
    FCVT_W_S,
    FCVT_WU_S,
    FCVT_S_W,
    FCVT_S_WU,
    FCVT_L_S,
    FCVT_LU_S,
    FCVT_S_L,
    FCVT_S_LU,
    FMV_X_W,
    FMV_W_X,
    FLD,
    FSD,
    FMADD_D,
    FMSUB_D,
    FNMSUB_D,
    FNMADD_D,
    FADD_D,
    FSUB_D,
    FMUL_D,
    FDIV_D,
    FSQRT_D,
    FSGNJ_D,
    FSGNJN_D,
    FSGNJX_D,
    FMIN_D,
    FMAX_D,
    FEQ_D,
    FLT_D,
    FLE_D,
    FCLASS_D,
    FCVT_W_D,
    FCVT_WU_D,
    FCVT_D_W,
    FCVT_D_WU,
    FCVT_L_D,
    FCVT_LU_D,
    FCVT_D_L,
    FCVT_D_LU,
    FMV_X_D,
    FMV_D_X,
    FCVT_S_D,
    FCVT_D_S,
    FLQ,
    FSQ,
    FMADD_Q,
    FMSUB_Q,
    FNMSUB_Q,
    FNMADD_Q,
    FADD_Q,
    FSUB_Q,
    FMUL_Q,
    FDIV_Q,
    FSQRT_Q,
    FSGNJ_Q,
    FSGNJN_Q,
    FSGNJX_Q,
    FMIN_Q,
    FMAX_Q,
    FEQ_Q,
    FLT_Q,
    FLE_Q,
    FCLASS_Q,
    FCVT_W_Q,
    FCVT_WU_Q,
    FCVT_Q_W,
    FCVT_Q_WU,
    FCVT_L_Q,
    FCVT_LU_Q,
    FCVT_Q_L,
    FCVT_Q_LU,
    FCVT_S_Q,
    FCVT_Q_S,
    FCVT_D_Q,
    FCVT_Q_D,
    FLH,
    FSH,
    FMADD_H,
    FMSUB_H,
    FNMSUB_H,
    FNMADD_H,
    FADD_H,
    FSUB_H,
    FMUL_H,
    FDIV_H,
    FSQRT_H,
    FSGNJ_H,
    FSGNJN_H,
    FSGNJX_H,
    FMIN_H,
    FMAX_H,
    FEQ_H,
    FLT_H,
    FLE_H,
    FCLASS_H,
    FCVT_W_H,
    FCVT_WU_H,
    FCVT_H_W,
    FCVT_H_WU,
    FCVT_L_H,
    FCVT_LU_H,
    FCVT_H_L,
    FCVT_H_LU,
    FMV_X_H,
    FMV_H_X,
    FCVT_S_H,
    FCVT_H_S,
    FCVT_D_H,
    FCVT_H_D,
    FCVT_Q_H,
    FCVT_H_Q,
    WRS_NTO,
    WRS_STO,
    INVALID_H = 10'b11_1111_1111
  } func_t;

  typedef enum logic [19:0] {
    //             19:17 16    15    14    13    12    11    10    9:0
    //             IMM_  frs3  frs2  frs1  frd_  xrs2  xrs1  xrd_, Function
    i_INVALID   = {NONE, ____, ____, ____, ____, ____, ____, ____, INVALID},
    i_LUI       = {UIMM, ____, ____, ____, ____, ____, ____, KEEP, LUI},
    i_AUIPC     = {UIMM, ____, ____, ____, ____, ____, ____, KEEP, AUIPC},
    i_JAL       = {JIMM, ____, ____, ____, ____, ____, ____, KEEP, JAL},
    i_JALR      = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, JALR},
    i_BEQ       = {BIMM, ____, ____, ____, ____, KEEP, KEEP, ____, BEQ},
    i_BNE       = {BIMM, ____, ____, ____, ____, KEEP, KEEP, ____, BNE},
    i_BLT       = {BIMM, ____, ____, ____, ____, KEEP, KEEP, ____, BLT},
    i_BGE       = {BIMM, ____, ____, ____, ____, KEEP, KEEP, ____, BGE},
    i_BLTU      = {BIMM, ____, ____, ____, ____, KEEP, KEEP, ____, BLTU},
    i_BGEU      = {BIMM, ____, ____, ____, ____, KEEP, KEEP, ____, BGEU},
    i_LB        = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, LB},
    i_LH        = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, LH},
    i_LW        = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, LW},
    i_LBU       = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, LBU},
    i_LHU       = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, LHU},
    i_SB        = {SIMM, ____, ____, ____, ____, KEEP, KEEP, ____, SB},
    i_SH        = {SIMM, ____, ____, ____, ____, KEEP, KEEP, ____, SH},
    i_SW        = {SIMM, ____, ____, ____, ____, KEEP, KEEP, ____, SW},
    i_ADDI      = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, ADDI},
    i_SLTI      = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, SLTI},
    i_SLTIU     = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, SLTIU},
    i_XORI      = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, XORI},
    i_ORI       = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, ORI},
    i_ANDI      = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, ANDI},
    i_SLLI      = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, SLLI},
    i_SRLI      = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, SRLI},
    i_SRAI      = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, SRAI},
    i_ADD       = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, ADD},
    i_SUB       = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, SUB},
    i_SLL       = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, SLL},
    i_SLT       = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, SLT},
    i_SLTU      = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, SLTU},
    i_XOR       = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, XOR},
    i_SRL       = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, SRL},
    i_SRA       = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, SRA},
    i_OR        = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, OR},
    i_AND       = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AND},
    i_FENCE     = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, FENCE},
    i_FENCE_TSO = {IIMM, ____, ____, ____, ____, ____, ____, ____, FENCE_TSO},
    i_PAUSE     = {IIMM, ____, ____, ____, ____, ____, ____, ____, PAUSE},
    i_ECALL     = {IIMM, ____, ____, ____, ____, ____, ____, ____, ECALL},
    i_EBREAK    = {IIMM, ____, ____, ____, ____, ____, ____, ____, EBREAK},
    i_LWU       = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, LWU},
    i_LD        = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, LD},
    i_SD        = {SIMM, ____, ____, ____, ____, KEEP, KEEP, ____, SD},
    i_ADDIW     = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, ADDIW},
    i_SLLIW     = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, SLLIW},
    i_SRLIW     = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, SRLIW},
    i_SRAIW     = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, SRAIW},
    i_ADDW      = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, ADDW},
    i_SUBW      = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, SUBW},
    i_SLLW      = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, SLLW},
    i_SRLW      = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, SRLW},
    i_SRAW      = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, SRAW},
    i_FENC_I    = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, FENC_I},
    i_CSRRW     = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, CSRRW},
    i_CSRRS     = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, CSRRS},
    i_CSRRC     = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, CSRRC},
    i_CSRRWI    = {CIMM, ____, ____, ____, ____, ____, ____, KEEP, CSRRWI},
    i_CSRRSI    = {CIMM, ____, ____, ____, ____, ____, ____, KEEP, CSRRSI},
    i_CSRRCI    = {CIMM, ____, ____, ____, ____, ____, ____, KEEP, CSRRCI},
    i_MUL       = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, MUL},
    i_MULH      = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, MULH},
    i_MULHSU    = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, MULHSU},
    i_MULHU     = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, MULHU},
    i_DIV       = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, DIV},
    i_DIVU      = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, DIVU},
    i_REM       = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, REM},
    i_REMU      = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, REMU},
    i_MULW      = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, MULW},
    i_DIVW      = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, DIVW},
    i_DIVUW     = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, DIVUW},
    i_REMW      = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, REMW},
    i_REMUW     = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, REMUW},
    i_LR_W      = {NONE, ____, ____, ____, ____, ____, KEEP, KEEP, LR_W},
    i_SC_W      = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, SC_W},
    i_AMOSWAP_W = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOSWAP_W},
    i_AMOADD_W  = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOADD_W},
    i_AMOXOR_W  = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOXOR_W},
    i_AMOAND_W  = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOAND_W},
    i_AMOOR_W   = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOOR_W},
    i_AMOMIN_W  = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOMIN_W},
    i_AMOMAX_W  = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOMAX_W},
    i_AMOMINU_W = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOMINU_W},
    i_AMOMAXU_W = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOMAXU_W},
    i_LR_D      = {NONE, ____, ____, ____, ____, ____, KEEP, KEEP, LR_D},
    i_SC_D      = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, SC_D},
    i_AMOSWAP_D = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOSWAP_D},
    i_AMOADD_D  = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOADD_D},
    i_AMOXOR_D  = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOXOR_D},
    i_AMOAND_D  = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOAND_D},
    i_AMOOR_D   = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOOR_D},
    i_AMOMIN_D  = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOMIN_D},
    i_AMOMAX_D  = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOMAX_D},
    i_AMOMINU_D = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOMINU_D},
    i_AMOMAXU_D = {NONE, ____, ____, ____, ____, KEEP, KEEP, KEEP, AMOMAXU_D},
    i_FLW       = {IIMM, ____, ____, ____, ____, ____, ____, ____, FLW},        // TODO
    i_FSW       = {SIMM, ____, ____, ____, ____, ____, ____, ____, FSW},        // TODO
    i_FMADD_S   = {NONE, ____, ____, ____, ____, ____, ____, ____, FMADD_S},    // TODO
    i_FMSUB_S   = {NONE, ____, ____, ____, ____, ____, ____, ____, FMSUB_S},    // TODO
    i_FNMSUB_S  = {NONE, ____, ____, ____, ____, ____, ____, ____, FNMSUB_S},   // TODO
    i_FNMADD_S  = {NONE, ____, ____, ____, ____, ____, ____, ____, FNMADD_S},   // TODO
    i_FADD_S    = {NONE, ____, ____, ____, ____, ____, ____, ____, FADD_S},     // TODO
    i_FSUB_S    = {NONE, ____, ____, ____, ____, ____, ____, ____, FSUB_S},     // TODO
    i_FMUL_S    = {NONE, ____, ____, ____, ____, ____, ____, ____, FMUL_S},     // TODO
    i_FDIV_S    = {NONE, ____, ____, ____, ____, ____, ____, ____, FDIV_S},     // TODO
    i_FSQRT_S   = {NONE, ____, ____, ____, ____, ____, ____, ____, FSQRT_S},    // TODO
    i_FSGNJ_S   = {NONE, ____, ____, ____, ____, ____, ____, ____, FSGNJ_S},    // TODO
    i_FSGNJN_S  = {NONE, ____, ____, ____, ____, ____, ____, ____, FSGNJN_S},   // TODO
    i_FSGNJX_S  = {NONE, ____, ____, ____, ____, ____, ____, ____, FSGNJX_S},   // TODO
    i_FMIN_S    = {NONE, ____, ____, ____, ____, ____, ____, ____, FMIN_S},     // TODO
    i_FMAX_S    = {NONE, ____, ____, ____, ____, ____, ____, ____, FMAX_S},     // TODO
    i_FEQ_S     = {NONE, ____, ____, ____, ____, ____, ____, ____, FEQ_S},      // TODO
    i_FLT_S     = {NONE, ____, ____, ____, ____, ____, ____, ____, FLT_S},      // TODO
    i_FLE_S     = {NONE, ____, ____, ____, ____, ____, ____, ____, FLE_S},      // TODO
    i_FCLASS_S  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCLASS_S},   // TODO
    i_FCVT_W_S  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_W_S},   // TODO
    i_FCVT_WU_S = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_WU_S},  // TODO
    i_FCVT_S_W  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_S_W},   // TODO
    i_FCVT_S_WU = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_S_WU},  // TODO
    i_FCVT_L_S  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_L_S},   // TODO
    i_FCVT_LU_S = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_LU_S},  // TODO
    i_FCVT_S_L  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_S_L},   // TODO
    i_FCVT_S_LU = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_S_LU},  // TODO
    i_FMV_X_W   = {NONE, ____, ____, ____, ____, ____, ____, ____, FMV_X_W},    // TODO
    i_FMV_W_X   = {NONE, ____, ____, ____, ____, ____, ____, ____, FMV_W_X},    // TODO
    i_FLD       = {IIMM, ____, ____, ____, ____, ____, ____, ____, FLD},        // TODO
    i_FSD       = {SIMM, ____, ____, ____, ____, ____, ____, ____, FSD},        // TODO
    i_FMADD_D   = {NONE, ____, ____, ____, ____, ____, ____, ____, FMADD_D},    // TODO
    i_FMSUB_D   = {NONE, ____, ____, ____, ____, ____, ____, ____, FMSUB_D},    // TODO
    i_FNMSUB_D  = {NONE, ____, ____, ____, ____, ____, ____, ____, FNMSUB_D},   // TODO
    i_FNMADD_D  = {NONE, ____, ____, ____, ____, ____, ____, ____, FNMADD_D},   // TODO
    i_FADD_D    = {NONE, ____, ____, ____, ____, ____, ____, ____, FADD_D},     // TODO
    i_FSUB_D    = {NONE, ____, ____, ____, ____, ____, ____, ____, FSUB_D},     // TODO
    i_FMUL_D    = {NONE, ____, ____, ____, ____, ____, ____, ____, FMUL_D},     // TODO
    i_FDIV_D    = {NONE, ____, ____, ____, ____, ____, ____, ____, FDIV_D},     // TODO
    i_FSQRT_D   = {NONE, ____, ____, ____, ____, ____, ____, ____, FSQRT_D},    // TODO
    i_FSGNJ_D   = {NONE, ____, ____, ____, ____, ____, ____, ____, FSGNJ_D},    // TODO
    i_FSGNJN_D  = {NONE, ____, ____, ____, ____, ____, ____, ____, FSGNJN_D},   // TODO
    i_FSGNJX_D  = {NONE, ____, ____, ____, ____, ____, ____, ____, FSGNJX_D},   // TODO
    i_FMIN_D    = {NONE, ____, ____, ____, ____, ____, ____, ____, FMIN_D},     // TODO
    i_FMAX_D    = {NONE, ____, ____, ____, ____, ____, ____, ____, FMAX_D},     // TODO
    i_FEQ_D     = {NONE, ____, ____, ____, ____, ____, ____, ____, FEQ_D},      // TODO
    i_FLT_D     = {NONE, ____, ____, ____, ____, ____, ____, ____, FLT_D},      // TODO
    i_FLE_D     = {NONE, ____, ____, ____, ____, ____, ____, ____, FLE_D},      // TODO
    i_FCLASS_D  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCLASS_D},   // TODO
    i_FCVT_W_D  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_W_D},   // TODO
    i_FCVT_WU_D = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_WU_D},  // TODO
    i_FCVT_D_W  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_D_W},   // TODO
    i_FCVT_D_WU = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_D_WU},  // TODO
    i_FCVT_L_D  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_L_D},   // TODO
    i_FCVT_LU_D = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_LU_D},  // TODO
    i_FCVT_D_L  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_D_L},   // TODO
    i_FCVT_D_LU = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_D_LU},  // TODO
    i_FMV_X_D   = {NONE, ____, ____, ____, ____, ____, ____, ____, FMV_X_D},    // TODO
    i_FMV_D_X   = {NONE, ____, ____, ____, ____, ____, ____, ____, FMV_D_X},    // TODO
    i_FCVT_S_D  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_S_D},   // TODO
    i_FCVT_D_S  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_D_S},   // TODO
    i_FLQ       = {IIMM, ____, ____, ____, ____, ____, ____, ____, FLQ},        // TODO
    i_FSQ       = {SIMM, ____, ____, ____, ____, ____, ____, ____, FSQ},        // TODO
    i_FMADD_Q   = {NONE, ____, ____, ____, ____, ____, ____, ____, FMADD_Q},    // TODO
    i_FMSUB_Q   = {NONE, ____, ____, ____, ____, ____, ____, ____, FMSUB_Q},    // TODO
    i_FNMSUB_Q  = {NONE, ____, ____, ____, ____, ____, ____, ____, FNMSUB_Q},   // TODO
    i_FNMADD_Q  = {NONE, ____, ____, ____, ____, ____, ____, ____, FNMADD_Q},   // TODO
    i_FADD_Q    = {NONE, ____, ____, ____, ____, ____, ____, ____, FADD_Q},     // TODO
    i_FSUB_Q    = {NONE, ____, ____, ____, ____, ____, ____, ____, FSUB_Q},     // TODO
    i_FMUL_Q    = {NONE, ____, ____, ____, ____, ____, ____, ____, FMUL_Q},     // TODO
    i_FDIV_Q    = {NONE, ____, ____, ____, ____, ____, ____, ____, FDIV_Q},     // TODO
    i_FSQRT_Q   = {NONE, ____, ____, ____, ____, ____, ____, ____, FSQRT_Q},    // TODO
    i_FSGNJ_Q   = {NONE, ____, ____, ____, ____, ____, ____, ____, FSGNJ_Q},    // TODO
    i_FSGNJN_Q  = {NONE, ____, ____, ____, ____, ____, ____, ____, FSGNJN_Q},   // TODO
    i_FSGNJX_Q  = {NONE, ____, ____, ____, ____, ____, ____, ____, FSGNJX_Q},   // TODO
    i_FMIN_Q    = {NONE, ____, ____, ____, ____, ____, ____, ____, FMIN_Q},     // TODO
    i_FMAX_Q    = {NONE, ____, ____, ____, ____, ____, ____, ____, FMAX_Q},     // TODO
    i_FEQ_Q     = {NONE, ____, ____, ____, ____, ____, ____, ____, FEQ_Q},      // TODO
    i_FLT_Q     = {NONE, ____, ____, ____, ____, ____, ____, ____, FLT_Q},      // TODO
    i_FLE_Q     = {NONE, ____, ____, ____, ____, ____, ____, ____, FLE_Q},      // TODO
    i_FCLASS_Q  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCLASS_Q},   // TODO
    i_FCVT_W_Q  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_W_Q},   // TODO
    i_FCVT_WU_Q = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_WU_Q},  // TODO
    i_FCVT_Q_W  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_Q_W},   // TODO
    i_FCVT_Q_WU = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_Q_WU},  // TODO
    i_FCVT_L_Q  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_L_Q},   // TODO
    i_FCVT_LU_Q = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_LU_Q},  // TODO
    i_FCVT_Q_L  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_Q_L},   // TODO
    i_FCVT_Q_LU = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_Q_LU},  // TODO
    i_FCVT_S_Q  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_S_Q},   // TODO
    i_FCVT_Q_S  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_Q_S},   // TODO
    i_FCVT_D_Q  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_D_Q},   // TODO
    i_FCVT_Q_D  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_Q_D},   // TODO
    i_FLH       = {IIMM, ____, ____, ____, ____, ____, ____, ____, FLH},        // TODO
    i_FSH       = {SIMM, ____, ____, ____, ____, ____, ____, ____, FSH},        // TODO
    i_FMADD_H   = {NONE, ____, ____, ____, ____, ____, ____, ____, FMADD_H},    // TODO
    i_FMSUB_H   = {NONE, ____, ____, ____, ____, ____, ____, ____, FMSUB_H},    // TODO
    i_FNMSUB_H  = {NONE, ____, ____, ____, ____, ____, ____, ____, FNMSUB_H},   // TODO
    i_FNMADD_H  = {NONE, ____, ____, ____, ____, ____, ____, ____, FNMADD_H},   // TODO
    i_FADD_H    = {NONE, ____, ____, ____, ____, ____, ____, ____, FADD_H},     // TODO
    i_FSUB_H    = {NONE, ____, ____, ____, ____, ____, ____, ____, FSUB_H},     // TODO
    i_FMUL_H    = {NONE, ____, ____, ____, ____, ____, ____, ____, FMUL_H},     // TODO
    i_FDIV_H    = {NONE, ____, ____, ____, ____, ____, ____, ____, FDIV_H},     // TODO
    i_FSQRT_H   = {NONE, ____, ____, ____, ____, ____, ____, ____, FSQRT_H},    // TODO
    i_FSGNJ_H   = {NONE, ____, ____, ____, ____, ____, ____, ____, FSGNJ_H},    // TODO
    i_FSGNJN_H  = {NONE, ____, ____, ____, ____, ____, ____, ____, FSGNJN_H},   // TODO
    i_FSGNJX_H  = {NONE, ____, ____, ____, ____, ____, ____, ____, FSGNJX_H},   // TODO
    i_FMIN_H    = {NONE, ____, ____, ____, ____, ____, ____, ____, FMIN_H},     // TODO
    i_FMAX_H    = {NONE, ____, ____, ____, ____, ____, ____, ____, FMAX_H},     // TODO
    i_FEQ_H     = {NONE, ____, ____, ____, ____, ____, ____, ____, FEQ_H},      // TODO
    i_FLT_H     = {NONE, ____, ____, ____, ____, ____, ____, ____, FLT_H},      // TODO
    i_FLE_H     = {NONE, ____, ____, ____, ____, ____, ____, ____, FLE_H},      // TODO
    i_FCLASS_H  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCLASS_H},   // TODO
    i_FCVT_W_H  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_W_H},   // TODO
    i_FCVT_WU_H = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_WU_H},  // TODO
    i_FCVT_H_W  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_H_W},   // TODO
    i_FCVT_H_WU = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_H_WU},  // TODO
    i_FCVT_L_H  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_L_H},   // TODO
    i_FCVT_LU_H = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_LU_H},  // TODO
    i_FCVT_H_L  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_H_L},   // TODO
    i_FCVT_H_LU = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_H_LU},  // TODO
    i_FMV_X_H   = {NONE, ____, ____, ____, ____, ____, ____, ____, FMV_X_H},    // TODO
    i_FMV_H_X   = {NONE, ____, ____, ____, ____, ____, ____, ____, FMV_H_X},    // TODO
    i_FCVT_S_H  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_S_H},   // TODO
    i_FCVT_H_S  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_H_S},   // TODO
    i_FCVT_D_H  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_D_H},   // TODO
    i_FCVT_H_D  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_H_D},   // TODO
    i_FCVT_Q_H  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_Q_H},   // TODO
    i_FCVT_H_Q  = {NONE, ____, ____, ____, ____, ____, ____, ____, FCVT_H_Q},   // TODO
    i_WRS_NTO   = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, WRS_NTO},
    i_WRS_STO   = {IIMM, ____, ____, ____, ____, ____, KEEP, KEEP, WRS_STO},
    i_INVALID_H = {NONE, ____, ____, ____, ____, ____, ____, ____, INVALID_H}
    //             IMM_  frs3  frs2  frs1  frd_  xrs2  xrs1  xrd_, Function
    //             19:17 16    15    14    13    12    11    10    9:0
  } intr_func_t;

  typedef struct packed {
    func_t       func;
    logic [5:0]  rd;
    logic [5:0]  rs1;
    logic [5:0]  rs2;
    logic [5:0]  rs3;
    logic [31:0] imm;
    logic        rl;
    logic        aq;
    logic [2:0]  rm;
    logic [5:0]  shamt;
    logic [3:0]  succ;
    logic [3:0]  pred;
    logic [3:0]  fm;
    logic [11:0] csr;
  } decoded_instr_t;

endpackage

`endif
