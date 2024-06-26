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
    decoder_B = '0;
    if (decoder_B.funct == INVALID) decoder_B = '0;
  end

  always_comb begin  // decoder_I
    decoder_I = '0;
    if (decoder_I.funct == INVALID) decoder_I = '0;
  end

  always_comb begin  // decoder_J
    decoder_J = '0;
    if (decoder_J.funct == INVALID) decoder_J = '0;
  end

  always_comb begin  // decoder_R
    decoder_R = '0;
    if (decoder_R.funct == INVALID) decoder_R = '0;
  end

  always_comb begin  // decoder_R4
    decoder_R4 = '0;
    if (decoder_R4.funct == INVALID) ecoder_R4 = '0;
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
    decoder_X = '0;
    if (decoder_X.funct == INVALID) decoder_X = '0;
  end


endmodule
