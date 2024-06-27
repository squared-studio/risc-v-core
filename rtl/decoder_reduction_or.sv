/*
Write a markdown documentation for this systemverilog module:
Author : Foez Ahmed (foez.official@gmail.com)
*/
`include "rv64g_pkg.sv"

module decoder_reduction_or
  import rv64g_pkg::*;
#(
    parameter int NUM_INPUTS = 8
) (
    input decoded_instr_t wire_i[NUM_INPUTS],

    output decoded_instr_t wire_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS GENERATED
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int Width = $bits(wire_o);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [NUM_INPUTS-1:0][Width-1:0] packed_wire;
  logic [NUM_INPUTS-1:0] rearranged_wire[Width];
  logic [Width-1:0] reduced_packed_wire;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_comb begin
    foreach (packed_wire[i]) packed_wire[i] = wire_i[i];
  end

  always_comb begin
    foreach (packed_wire[i, j]) rearranged_wire[j][i] = packed_wire[i][j];
  end

  always_comb begin
    foreach (reduced_packed_wire[i]) reduced_packed_wire[i] = |rearranged_wire[i];
  end

  always_comb begin
    wire_o = reduced_packed_wire;
  end

endmodule
