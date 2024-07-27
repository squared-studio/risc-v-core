#include "stdint.h"
#include "../../sub/risc-v-model/src/decoder.c"
#include "stdio.h"

uint32_t code;
decoded_instr_t cmd;

void set_code (uint32_t code__) {
  code = code__;
  cmd = decode(code);
} 

uint32_t get_code () {
  return code;
} 

uint32_t get_rd () {
  return cmd.rd;
}

uint32_t get_rs1 () {
  return cmd.rs1;
}

uint32_t get_rs2 () {
  return cmd.rs2;
}

uint32_t get_rs3 () {
  return cmd.rs3;
}

uint32_t get_imm () {
  return cmd.imm;
}

uint32_t get_shamt () {
  return cmd.shamt;
}

uint32_t get_succ () {
  return cmd.succ;
}

uint32_t get_pred () {
  return cmd.pred;
}

uint32_t get_fm () {
  return cmd.fm;
}

uint32_t get_csr () {
  return cmd.csr;
}

uint32_t get_rl () {
  return cmd.rl;
}

uint32_t get_aq () {
  return cmd.aq;
}

uint32_t get_rm () {
  return cmd.rm;
}

char* get_func() {
  if (cmd.func == LUI) return "LUI";
  if (cmd.func == AUIPC) return "AUIPC";
  if (cmd.func == JAL) return "JAL";
  if (cmd.func == JALR) return "JALR";
  if (cmd.func == BEQ) return "BEQ";
  if (cmd.func == BNE) return "BNE";
  if (cmd.func == BLT) return "BLT";
  if (cmd.func == BGE) return "BGE";
  if (cmd.func == BLTU) return "BLTU";
  if (cmd.func == BGEU) return "BGEU";
  if (cmd.func == LB) return "LB";
  if (cmd.func == LH) return "LH";
  if (cmd.func == LW) return "LW";
  if (cmd.func == LBU) return "LBU";
  if (cmd.func == LHU) return "LHU";
  if (cmd.func == SB) return "SB";
  if (cmd.func == SH) return "SH";
  if (cmd.func == SW) return "SW";
  if (cmd.func == ADDI) return "ADDI";
  if (cmd.func == SLTI) return "SLTI";
  if (cmd.func == SLTIU) return "SLTIU";
  if (cmd.func == XORI) return "XORI";
  if (cmd.func == ORI) return "ORI";
  if (cmd.func == ANDI) return "ANDI";
  if (cmd.func == SLLI) return "SLLI";
  if (cmd.func == SRLI) return "SRLI";
  if (cmd.func == SRAI) return "SRAI";
  if (cmd.func == ADD) return "ADD";
  if (cmd.func == SUB) return "SUB";
  if (cmd.func == SLL) return "SLL";
  if (cmd.func == SLT) return "SLT";
  if (cmd.func == SLTU) return "SLTU";
  if (cmd.func == XOR) return "XOR";
  if (cmd.func == SRL) return "SRL";
  if (cmd.func == SRA) return "SRA";
  if (cmd.func == OR) return "OR";
  if (cmd.func == AND) return "AND";
  if (cmd.func == FENCE) return "FENCE";
  if (cmd.func == FENCE_TSO) return "FENCE_TSO";
  if (cmd.func == PAUSE) return "PAUSE";
  if (cmd.func == ECALL) return "ECALL";
  if (cmd.func == EBREAK) return "EBREAK";
  if (cmd.func == LWU) return "LWU";
  if (cmd.func == LD) return "LD";
  if (cmd.func == SD) return "SD";
  if (cmd.func == ADDIW) return "ADDIW";
  if (cmd.func == SLLIW) return "SLLIW";
  if (cmd.func == SRLIW) return "SRLIW";
  if (cmd.func == SRAIW) return "SRAIW";
  if (cmd.func == ADDW) return "ADDW";
  if (cmd.func == SUBW) return "SUBW";
  if (cmd.func == SLLW) return "SLLW";
  if (cmd.func == SRLW) return "SRLW";
  if (cmd.func == SRAW) return "SRAW";
  if (cmd.func == FENC_I) return "FENC_I";
  if (cmd.func == CSRRW) return "CSRRW";
  if (cmd.func == CSRRS) return "CSRRS";
  if (cmd.func == CSRRC) return "CSRRC";
  if (cmd.func == CSRRWI) return "CSRRWI";
  if (cmd.func == CSRRSI) return "CSRRSI";
  if (cmd.func == CSRRCI) return "CSRRCI";
  if (cmd.func == MUL) return "MUL";
  if (cmd.func == MULH) return "MULH";
  if (cmd.func == MULHSU) return "MULHSU";
  if (cmd.func == MULHU) return "MULHU";
  if (cmd.func == DIV) return "DIV";
  if (cmd.func == DIVU) return "DIVU";
  if (cmd.func == REM) return "REM";
  if (cmd.func == REMU) return "REMU";
  if (cmd.func == MULW) return "MULW";
  if (cmd.func == DIVW) return "DIVW";
  if (cmd.func == DIVUW) return "DIVUW";
  if (cmd.func == REMW) return "REMW";
  if (cmd.func == REMUW) return "REMUW";
  if (cmd.func == LR_W) return "LR_W";
  if (cmd.func == SC_W) return "SC_W";
  if (cmd.func == AMOSWAP_W) return "AMOSWAP_W";
  if (cmd.func == AMOADD_W) return "AMOADD_W";
  if (cmd.func == AMOXOR_W) return "AMOXOR_W";
  if (cmd.func == AMOAND_W) return "AMOAND_W";
  if (cmd.func == AMOOR_W) return "AMOOR_W";
  if (cmd.func == AMOMIN_W) return "AMOMIN_W";
  if (cmd.func == AMOMAX_W) return "AMOMAX_W";
  if (cmd.func == AMOMINU_W) return "AMOMINU_W";
  if (cmd.func == AMOMAXU_W) return "AMOMAXU_W";
  if (cmd.func == LR_D) return "LR_D";
  if (cmd.func == SC_D) return "SC_D";
  if (cmd.func == AMOSWAP_D) return "AMOSWAP_D";
  if (cmd.func == AMOADD_D) return "AMOADD_D";
  if (cmd.func == AMOXOR_D) return "AMOXOR_D";
  if (cmd.func == AMOAND_D) return "AMOAND_D";
  if (cmd.func == AMOOR_D) return "AMOOR_D";
  if (cmd.func == AMOMIN_D) return "AMOMIN_D";
  if (cmd.func == AMOMAX_D) return "AMOMAX_D";
  if (cmd.func == AMOMINU_D) return "AMOMINU_D";
  if (cmd.func == AMOMAXU_D) return "AMOMAXU_D";
  if (cmd.func == FLW) return "FLW";
  if (cmd.func == FSW) return "FSW";
  if (cmd.func == FMADD_S) return "FMADD_S";
  if (cmd.func == FMSUB_S) return "FMSUB_S";
  if (cmd.func == FNMSUB_S) return "FNMSUB_S";
  if (cmd.func == FNMADD_S) return "FNMADD_S";
  if (cmd.func == FADD_S) return "FADD_S";
  if (cmd.func == FSUB_S) return "FSUB_S";
  if (cmd.func == FMUL_S) return "FMUL_S";
  if (cmd.func == FDIV_S) return "FDIV_S";
  if (cmd.func == FSQRT_S) return "FSQRT_S";
  if (cmd.func == FSGNJ_S) return "FSGNJ_S";
  if (cmd.func == FSGNJN_S) return "FSGNJN_S";
  if (cmd.func == FSGNJX_S) return "FSGNJX_S";
  if (cmd.func == FMIN_S) return "FMIN_S";
  if (cmd.func == FMAX_S) return "FMAX_S";
  if (cmd.func == FCVT_W_S) return "FCVT_W_S";
  if (cmd.func == FCVT_WU_S) return "FCVT_WU_S";
  if (cmd.func == FMV_X_W) return "FMV_X_W";
  if (cmd.func == FEQ_S) return "FEQ_S";
  if (cmd.func == FLT_S) return "FLT_S";
  if (cmd.func == FLE_S) return "FLE_S";
  if (cmd.func == FCLASS_S) return "FCLASS_S";
  if (cmd.func == FCVT_S_W) return "FCVT_S_W";
  if (cmd.func == FCVT_S_WU) return "FCVT_S_WU";
  if (cmd.func == FMV_W_X) return "FMV_W_X";
  if (cmd.func == FCVT_L_S) return "FCVT_L_S";
  if (cmd.func == FCVT_LU_S) return "FCVT_LU_S";
  if (cmd.func == FCVT_S_L) return "FCVT_S_L";
  if (cmd.func == FCVT_S_LU) return "FCVT_S_LU";
  if (cmd.func == FLD) return "FLD";
  if (cmd.func == FSD) return "FSD";
  if (cmd.func == FMADD_D) return "FMADD_D";
  if (cmd.func == FMSUB_D) return "FMSUB_D";
  if (cmd.func == FNMSUB_D) return "FNMSUB_D";
  if (cmd.func == FNMADD_D) return "FNMADD_D";
  if (cmd.func == FADD_D) return "FADD_D";
  if (cmd.func == FSUB_D) return "FSUB_D";
  if (cmd.func == FMUL_D) return "FMUL_D";
  if (cmd.func == FDIV_D) return "FDIV_D";
  if (cmd.func == FSQRT_D) return "FSQRT_D";
  if (cmd.func == FSGNJ_D) return "FSGNJ_D";
  if (cmd.func == FSGNJN_D) return "FSGNJN_D";
  if (cmd.func == FSGNJX_D) return "FSGNJX_D";
  if (cmd.func == FMIN_D) return "FMIN_D";
  if (cmd.func == FMAX_D) return "FMAX_D";
  if (cmd.func == FCVT_S_D) return "FCVT_S_D";
  if (cmd.func == FCVT_D_S) return "FCVT_D_S";
  if (cmd.func == FEQ_D) return "FEQ_D";
  if (cmd.func == FLT_D) return "FLT_D";
  if (cmd.func == FLE_D) return "FLE_D";
  if (cmd.func == FCLASS_D) return "FCLASS_D";
  if (cmd.func == FCVT_W_D) return "FCVT_W_D";
  if (cmd.func == FCVT_WU_D) return "FCVT_WU_D";
  if (cmd.func == FCVT_D_W) return "FCVT_D_W";
  if (cmd.func == FCVT_D_WU) return "FCVT_D_WU";
  if (cmd.func == FCVT_L_D) return "FCVT_L_D";
  if (cmd.func == FCVT_LU_D) return "FCVT_LU_D";
  if (cmd.func == FMV_X_D) return "FMV_X_D";
  if (cmd.func == FCVT_D_L) return "FCVT_D_L";
  if (cmd.func == FCVT_D_LU) return "FCVT_D_LU";
  if (cmd.func == FMV_D_X) return "FMV_D_X";
  if (cmd.func == FLQ) return "FLQ";
  if (cmd.func == FSQ) return "FSQ";
  if (cmd.func == FMADD_Q) return "FMADD_Q";
  if (cmd.func == FMSUB_Q) return "FMSUB_Q";
  if (cmd.func == FNMSUB_Q) return "FNMSUB_Q";
  if (cmd.func == FNMADD_Q) return "FNMADD_Q";
  if (cmd.func == FADD_Q) return "FADD_Q";
  if (cmd.func == FSUB_Q) return "FSUB_Q";
  if (cmd.func == FMUL_Q) return "FMUL_Q";
  if (cmd.func == FDIV_Q) return "FDIV_Q";
  if (cmd.func == FSQRT_Q) return "FSQRT_Q";
  if (cmd.func == FSGNJ_Q) return "FSGNJ_Q";
  if (cmd.func == FSGNJN_Q) return "FSGNJN_Q";
  if (cmd.func == FSGNJX_Q) return "FSGNJX_Q";
  if (cmd.func == FMIN_Q) return "FMIN_Q";
  if (cmd.func == FMAX_Q) return "FMAX_Q";
  if (cmd.func == FCVT_S_Q) return "FCVT_S_Q";
  if (cmd.func == FCVT_Q_S) return "FCVT_Q_S";
  if (cmd.func == FCVT_D_Q) return "FCVT_D_Q";
  if (cmd.func == FCVT_Q_D) return "FCVT_Q_D";
  if (cmd.func == FEQ_Q) return "FEQ_Q";
  if (cmd.func == FLT_Q) return "FLT_Q";
  if (cmd.func == FLE_Q) return "FLE_Q";
  if (cmd.func == FCLASS_Q) return "FCLASS_Q";
  if (cmd.func == FCVT_W_Q) return "FCVT_W_Q";
  if (cmd.func == FCVT_WU_Q) return "FCVT_WU_Q";
  if (cmd.func == FCVT_Q_W) return "FCVT_Q_W";
  if (cmd.func == FCVT_Q_WU) return "FCVT_Q_WU";
  if (cmd.func == FCVT_L_Q) return "FCVT_L_Q";
  if (cmd.func == FCVT_LU_Q) return "FCVT_LU_Q";
  if (cmd.func == FCVT_Q_L) return "FCVT_Q_L";
  if (cmd.func == FCVT_Q_LU) return "FCVT_Q_LU";
  if (cmd.func == FLH) return "FLH";
  if (cmd.func == FSH) return "FSH";
  if (cmd.func == FMADD_H) return "FMADD_H";
  if (cmd.func == FMSUB_H) return "FMSUB_H";
  if (cmd.func == FNMSUB_H) return "FNMSUB_H";
  if (cmd.func == FNMADD_H) return "FNMADD_H";
  if (cmd.func == FADD_H) return "FADD_H";
  if (cmd.func == FSUB_H) return "FSUB_H";
  if (cmd.func == FMUL_H) return "FMUL_H";
  if (cmd.func == FDIV_H) return "FDIV_H";
  if (cmd.func == FSQRT_H) return "FSQRT_H";
  if (cmd.func == FSGNJ_H) return "FSGNJ_H";
  if (cmd.func == FSGNJN_H) return "FSGNJN_H";
  if (cmd.func == FSGNJX_H) return "FSGNJX_H";
  if (cmd.func == FMIN_H) return "FMIN_H";
  if (cmd.func == FMAX_H) return "FMAX_H";
  if (cmd.func == FCVT_S_H) return "FCVT_S_H";
  if (cmd.func == FCVT_H_S) return "FCVT_H_S";
  if (cmd.func == FCVT_D_H) return "FCVT_D_H";
  if (cmd.func == FCVT_H_D) return "FCVT_H_D";
  if (cmd.func == FCVT_Q_H) return "FCVT_Q_H";
  if (cmd.func == FCVT_H_Q) return "FCVT_H_Q";
  if (cmd.func == FEQ_H) return "FEQ_H";
  if (cmd.func == FLT_H) return "FLT_H";
  if (cmd.func == FLE_H) return "FLE_H";
  if (cmd.func == FCLASS_H) return "FCLASS_H";
  if (cmd.func == FCVT_W_H) return "FCVT_W_H";
  if (cmd.func == FCVT_WU_H) return "FCVT_WU_H";
  if (cmd.func == FMV_X_H) return "FMV_X_H";
  if (cmd.func == FCVT_H_W) return "FCVT_H_W";
  if (cmd.func == FCVT_H_WU) return "FCVT_H_WU";
  if (cmd.func == FMV_H_X) return "FMV_H_X";
  if (cmd.func == FCVT_L_H) return "FCVT_L_H";
  if (cmd.func == FCVT_LU_H) return "FCVT_LU_H";
  if (cmd.func == FCVT_H_L) return "FCVT_H_L";
  if (cmd.func == FCVT_H_LU) return "FCVT_H_LU";
  if (cmd.func == WRS_NTO) return "WRS_NTO";
  if (cmd.func == WRS_STO) return "WRS_STO";
  return "INVALID";
}
