#include "typedef.h"
#include "decoder.c"
#include "stdio.h"

#define TEST(__VALUE__)                                                 \
  instr = decode(__VALUE__);                                            \
  printf("RD:%02d RS1:%02d RS2:%02d RS3:%02d IMM:0x%08x FUNC:%s\n",     \
    instr.rd, instr.rs1, instr.rs2, instr.rs3, instr.imm, instr.func);  \


int main () {

  decoded_instr_t instr;

  TEST(0xABCDE637); // RD:12 IMM:0xabcde000 FUNC:LUI
  TEST(0xABCDE617); // RD:12 IMM:0xabcde000 FUNC:AUIPC
  TEST(0xC56237EF); // RD:15 IMM:0xfff23456 FUNC:JAL
  TEST(0x12308567); // RD:10 RS1:01 IMM:0x00000123 FUNC:JALR

}
