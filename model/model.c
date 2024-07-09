#include "typedef.h"
#include "decoder.c"
#include "stdio.h"

int main () {

  decoded_instr_t instr;

  instr = decode(0xABCDE637);
  
  printf("RD:%02d RS1:%02d RS2:%02d RS3:%02d IMM:0x%08x FUNC:%s\n",
    instr.rd,
    instr.rs1,
    instr.rs2,
    instr.rs3,
    instr.imm,
    instr.func
  );

  return 0;

}
