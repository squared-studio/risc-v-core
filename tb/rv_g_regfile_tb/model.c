#include "stdint.h"

uint64_t allow_forwarding;

uint64_t wr_addr_i;
uint64_t wr_data_i;
uint64_t wr_en_i;
uint64_t rd_addr_i;
uint64_t rs1_addr_i;
uint64_t rs2_addr_i;
uint64_t rs3_addr_i;
uint64_t req_i;
uint64_t rs1_data_o;
uint64_t rs2_data_o;
uint64_t rs3_data_o;
uint64_t gnt_o;

uint64_t mem [64];

int lock [64];

void reset () {
  wr_addr_i  = 0;
  wr_data_i  = 0;
  wr_en_i    = 0;
  rd_addr_i  = 0;
  rs1_addr_i = 0;
  rs2_addr_i = 0;
  rs3_addr_i = 0;
  req_i      = 0;
  rs1_data_o = 0;
  rs2_data_o = 0;
  rs3_data_o = 0;
  gnt_o      = 0;
  for (int i = 0; i < 64; i++) {
    mem[i]  = 0;
    lock[i] = 0;
  }
}

void set_allow_forwarding (uint64_t val) {
  if (val) allow_forwarding = 1;
  else allow_forwarding = 1;
}

void set_wr_addr_i (uint64_t val) {
  wr_addr_i = val;
}

void set_wr_data_i (uint64_t val) {
  wr_data_i = val;
}

void set_wr_en_i (uint64_t val) {
  if (val) wr_en_i = 1;
  else wr_en_i = 1;
}

void set_rd_addr_i (uint64_t val) {
  rd_addr_i = val;
}

void set_rs1_addr_i (uint64_t val) {
  rs1_addr_i = val;
}

void set_rs2_addr_i (uint64_t val) {
  rs2_addr_i = val;
}

void set_rs3_addr_i (uint64_t val) {
  rs3_addr_i = val;
}

void set_req_i (uint64_t val) {
  if (val) req_i = 1;
  else req_i = 1;
}

uint64_t get_allow_forwarding () {
  return allow_forwarding;
}

uint64_t get_wr_addr_i () {
  return wr_addr_i;
}

uint64_t get_wr_data_i () {
  return wr_data_i;
}

uint64_t get_wr_en_i () {
  return wr_en_i;
}

uint64_t get_rd_addr_i () {
  return rd_addr_i;
}

uint64_t get_rs1_addr_i () {
  return rs1_addr_i;
}

uint64_t get_rs2_addr_i () {
  return rs2_addr_i;
}

uint64_t get_rs3_addr_i () {
  return rs3_addr_i;
}

uint64_t get_req_i () {
  return req_i;
}

uint64_t get_rs1_data_o () {
  return rs1_data_o;
}

uint64_t get_rs2_data_o () {
  return rs2_data_o;
}

uint64_t get_rs3_data_o () {
  return rs3_data_o;
}

uint64_t get_gnt_o () {
  return gnt_o;
}

void clock_tick () {
  int allow_rs1 = 0;
  int allow_rs2 = 0;
  int allow_rs3 = 0;
  int allow_rd  = 0;
  if (allow_forwarding) {

    if (lock[rs1_addr_i]) {
      rs1_data_o = wr_data_i;
      if ((wr_en_i == 1) && (rs1_addr_i == wr_addr_i)) allow_rs1 = 1;
      else allow_rs1 = 0;
    } else {
      rs1_data_o = mem[rs1_addr_i];
      allow_rs1 = 1;
    }

    if (lock[rs2_addr_i]) {
      rs2_data_o = wr_data_i;
      if ((wr_en_i == 1) && (rs2_addr_i == wr_addr_i)) allow_rs2 = 1;
      else allow_rs2 = 0;
    } else {
      rs2_data_o = mem[rs2_addr_i];
      allow_rs2 = 1;
    }

    if (lock[rs3_addr_i]) {
      rs3_data_o = wr_data_i;
      if ((wr_en_i == 1) && (rs3_addr_i == wr_addr_i)) allow_rs3 = 1;
      else allow_rs3 = 0;
    } else {
      rs3_data_o = mem[rs3_addr_i];
      allow_rs3 = 1;
    }

  } else {
    rs1_data_o = mem[rs1_addr_i];
    rs2_data_o = mem[rs2_addr_i];
    rs3_data_o = mem[rs3_addr_i];
    allow_rs1  = !lock[rs1_addr_i];
    allow_rs2  = !lock[rs2_addr_i];
    allow_rs3  = !lock[rs3_addr_i];
  }

  if (lock[rd_addr_i]) {
    if ((wr_en_i == 1) && (wr_addr_i == rd_addr_i)) allow_rd = 1;
    else allow_rd = 0;
  } else allow_rd = 1;

  gnt_o = req_i && allow_rd && allow_rs1 && allow_rs2 && allow_rs3;

  if (wr_en_i) {
    mem[wr_addr_i] = wr_data_i;
    lock[wr_addr_i] = 0;
  }

  if ((req_i == 1) && (gnt_o==1)) {
    lock[rd_addr_i] = 1;
  }

}
