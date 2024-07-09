#include "typedef.h"
#include "stdio.h"

int sign_ext (uint32_t num, int len) {
  int result;
  result = num >> (len - 1);
  if ((len == 32) || ((result & 0x1) == 0x0)) {
    result = num;
  } else {
    result = (0xFFFFFFFF << len) | num;
  }
  return result;
}

decoded_instr_t decode (uint32_t code) {
  decoded_instr_t result;
  result.func = "INVALID";
  result.rd  = 0;
  result.rs1 = 0;
  result.rs2 = 0;
  result.rs3 = 0;
  result.imm = 0;

  if ((code & 0x0000007F) == 0x00000037) {
    result.func = "LUI";
    result.rd   = (code >> 7) & 0x1F;
    result.imm  = sign_ext(code & 0xFFFFF000, 32);
  }

  if ((code & 0x0000007F) == 0x00000017) {
    result.func = "AUIPC";
    result.rd   = (code >> 7) & 0x1F;
    result.imm  = sign_ext(code & 0xFFFFF000, 32);
  }

  if ((code & 0x0000007F) == 0x0000006F) {
    result.func = "JAL";
    result.rd   = (code >> 7) & 0x1F;
    int temp;
    temp = 0;
    temp = temp | ((0x000FF000 & code) >> 0);
    temp = temp | ((0x00100000 & code) >> 9);
    temp = temp | ((0x7FE00000 & code) >> 20);
    temp = temp | ((0x80000000 & code) >> 10);
    result.imm  = sign_ext(temp,21);
  }

  if ((code & 0x0000707F) == 0x00000067) {
    result.func = "JALR";
    result.rd   = (code >> 7) & 0x1F;
    result.rs1  = (code >> 15) & 0x1F;
    result.imm  = sign_ext((code >> 20) & 0xFFF, 12);
  }

  return result;
}
