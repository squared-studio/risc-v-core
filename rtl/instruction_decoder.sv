/*
Write a markdown documentation for this systemverilog module:
Author : Foez Ahmed (foez.official@gmail.com)
*/

`include "rv64g_pkg.sv"

module instruction_decoder
  import rv64g_pkg::*;
(
    input logic [31:0] code_i,
    output decoded_instr_t cmd_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  decoded_instr_t decoder_B;
  decoded_instr_t decoder_I;
  decoded_instr_t decoder_J;
  decoded_instr_t decoder_R;
  decoded_instr_t decoder_R4;
  decoded_instr_t decoder_S;
  decoded_instr_t decoder_U;
  decoded_instr_t decoder_X;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign cmd_o =
    decoder_B | decoder_I | decoder_J | decoder_R | decoder_R4 | decoder_S | decoder_U | decoder_X;

  always_comb begin  // decoder_B
    decoder_B           = '0;
    decoder_B.imm       = code_i[31] ? '1 : '0;
    decoder_B.imm[12]   = code_i[31];
    decoder_B.imm[11]   = code_i[7];
    decoder_B.imm[10:5] = code_i[30:25];
    decoder_B.imm[4:1]  = code_i[11:8];
    decoder_B.imm[0]    = '0;
    decoder_B.rs1       = code_i[19:15];
    decoder_B.rs2       = code_i[24:20];
    case (code_i[14:12])
      3'd0: decoder_B.funct = BEQ;
      3'd1: decoder_B.funct = BNE;
      3'd4: decoder_B.funct = BLT;
      3'd5: decoder_B.funct = BGE;
      3'd6: decoder_B.funct = BLTU;
      3'd7: decoder_B.funct = BGEU;
      default decoder_B.funct = INVALID;
    endcase
    if (decoder_B.funct == INVALID) decoder_B = '0;
  end

  always_comb begin  // decoder_I
    decoder_I = '0;
    if (decoder_I.funct == INVALID) decoder_I = '0;
  end

  always_comb begin  // decoder_J
    decoder_J = '0;
    decoder_J.imm = code_i[31] ? '1 : '0;
    decoder_J.imm[20] = code_i[31];
    decoder_J.imm[10:1] = code_i[30:21];
    decoder_J.imm[11] = code_i[20];
    decoder_J.imm[19:12] = code_i[19:12];
    decoder_J.imm[0] = 0;
    decoder_J.rd = code_i[11:7];
    decoder_J.funct = JAL;
    if (decoder_J.funct == INVALID) decoder_J = '0;
  end

  always_comb begin  // decoder_R
    decoder_R = '0;
    if (decoder_R.funct == INVALID) decoder_R = '0;
  end

  always_comb begin  // decoder_R4
    decoder_R4 = '0;
    if (decoder_R4.funct == INVALID) decoder_R4 = '0;
  end

  always_comb begin  // decoder_S
    decoder_S = '0;
    if (decoder_S.funct == INVALID) decoder_S = '0;
  end

  always_comb begin  // decoder_U
    decoder_U = '0;
    if (decoder_U.funct == INVALID) decoder_U = '0;
  end

  always_comb begin  // decoder_X
    decoder_X      = '0;
    decoder_X.csr  = code_i[31:20];
    decoder_X.rd   = code_i[11:7];
    decoder_X.rs1  = code_i[19:15];
    decoder_X.uimm = code_i[19:15];
    case (code_i)
      1: decoder_X.funct = CSRRW;
      2: decoder_X.funct = CSRRS;
      3: decoder_X.funct = CSRRC;
      5: decoder_X.funct = CSRRWI;
      6: decoder_X.funct = CSRRSI;
      7: decoder_X.funct = CSRRCI;
      default: begin
        case (code_i[31:7])
          25'h0000000: decoder_X.funct = ECALL;
          25'h0002000: decoder_X.funct = EBREAK;
          default decoder_X.funct = INVALID;
        endcase
      end
    endcase
    if (decoder_X.funct == INVALID) decoder_X = '0;
  end


endmodule
