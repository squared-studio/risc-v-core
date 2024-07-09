#ifndef TYPEDEF_H__
#define TYPEDEF_H__

#include "stdint.h"

typedef struct {
  char*    func;
  uint32_t rd    :5;
  uint32_t rs1   :5;
  uint32_t rs2   :5;
  uint32_t rs3   :5;
  uint32_t imm   :32;
} decoded_instr_t;

#endif
