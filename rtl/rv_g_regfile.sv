/*
Write a markdown documentation for this systemverilog module:
Author : Foez Ahmed (foez.official@gmail.com)
<br>
<br>This file is part of squared-studio:risc-v-core
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module rv_g_regfile #(
    parameter int XLEN = 64,  // Length of Integer Registers
    parameter int FLEN = 32,  // Length of Floating Point Registers
    localparam int MaxLen = ((FLEN > XLEN) ? FLEN : XLEN),  // max(FLEN, XLEN)
    parameter bit ALLOW_FORWARDING = 1  // Allow forwarding write data
) (
    input logic arst_ni,  // Asynchronous Global Reset
    input logic clk_i,    // Synchronous Clock

    input logic [       5:0] wr_addr_i,  // Write & Unlock Address
    input logic [MaxLen-1:0] wr_data_i,  // Write Data
    input logic              wr_en_i,    // Write & Unlock Enable

    input logic [5:0] rd_addr_i,   // Destination & Lock Address
    input logic [5:0] rs1_addr_i,  // Source Register 1 Address
    input logic [5:0] rs2_addr_i,  // Source Register 2 Address
    input logic [5:0] rs3_addr_i,  // Source Register 3 Address
    input logic       req_i,       // Request Source Register Data & Lock Destination Register

    output logic [MaxLen-1:0] rs1_data_o,  // Source Register 1 Data
    output logic [MaxLen-1:0] rs2_data_o,  // Source Register 2 Data
    output logic [MaxLen-1:0] rs3_data_o,  // Source Register 3 Data
    output logic gnt_o  // Grant Access to Source Register Data & Lock Destination Register
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic x_wr_en;
  logic f_wr_en;

  logic [1:0][XLEN-1:0] x_rs;
  logic [2:0][FLEN-1:0] f_rs;

  logic lock[64];

  logic rd_ready;
  logic rs1_ready;
  logic rs2_ready;
  logic rs3_ready;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign x_wr_en  = ~wr_addr_i[5] & wr_en_i;
  assign f_wr_en  = wr_addr_i[5] & wr_en_i;

  assign rd_ready = lock[rd_addr_i] ? ((wr_en_i == '1) && (wr_addr_i == rd_addr_i)) : '1;
  if (ALLOW_FORWARDING) begin : g_forward_paths
    // COMPUTE RS READYs
    assign rs1_ready = lock[rs1_addr_i] ? ((wr_en_i == '1) && (wr_addr_i == rs1_addr_i)) : '1;
    assign rs2_ready = lock[rs2_addr_i] ? ((wr_en_i == '1) && (wr_addr_i == rs2_addr_i)) : '1;
    assign rs3_ready = rs3_addr_i[5] ?
        (lock[rs3_addr_i] ? ((wr_en_i == '1) && (wr_addr_i == rs3_addr_i)) : '1) : '1;
    // COMPUTE RS DATAs
    assign rs1_data_o = lock[rs1_addr_i] ? wr_data_i : (rs1_addr_i[5] ? f_rs[0] : x_rs[0]);
    assign rs2_data_o = lock[rs2_addr_i] ? wr_data_i : (rs2_addr_i[5] ? f_rs[1] : x_rs[1]);
    assign rs3_data_o =
      rs3_addr_i[5] ? (lock[rs3_addr_i] ? wr_data_i : (rs3_addr_i[5] ? f_rs[2] : '0)) : '0;
  end else begin : g_no_forward
    // COMPUTE RS READYs
    assign rs1_ready  = ~lock[rs1_addr_i];
    assign rs2_ready  = ~lock[rs2_addr_i];
    assign rs3_ready  = rs3_addr_i[5] ? ~lock[rs3_addr_i] : '1;
    // COMPUTE RS DATAs
    assign rs1_data_o = rs1_addr_i[5] ? f_rs[0] : x_rs[0];
    assign rs2_data_o = rs2_addr_i[5] ? f_rs[1] : x_rs[1];
    assign rs3_data_o = rs3_addr_i[5] ? f_rs[2] : '0;
  end

  assign gnt_o = req_i & rd_ready & rs1_ready & rs2_ready & rs3_ready;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  regfile #(
      .NUM_RS   (2),
      .ZERO_REG (1),
      .NUM_REG  (32),
      .REG_WIDTH(XLEN)
  ) u_x_regfile (
      .clk_i    (clk_i),
      .arst_ni  (arst_ni),
      .rd_addr_i(wr_addr_i[4:0]),
      .rd_data_i(wr_data_i[XLEN-1:0]),
      .rd_en_i  (x_wr_en),
      .rs_addr_i({rs2_addr_i[4:0], rs1_addr_i[4:0]}),
      .rs_data_o(x_rs)
  );

  regfile #(
      .NUM_RS   (3),
      .ZERO_REG (0),
      .NUM_REG  (32),
      .REG_WIDTH(FLEN)
  ) u_f_regfile (
      .clk_i    (clk_i),
      .arst_ni  (arst_ni),
      .rd_addr_i(wr_addr_i[4:0]),
      .rd_data_i(wr_data_i[FLEN-1:0]),
      .rd_en_i  (f_wr_en),
      .rs_addr_i({rs3_addr_i[4:0], rs2_addr_i[4:0], rs1_addr_i[4:0]}),
      .rs_data_o(f_rs)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      foreach (lock[i]) lock[i] <= '0;
    end else begin
      if (wr_en_i) lock[wr_addr_i] <= '0;
      if (req_i & gnt_o) lock[rd_addr_i] <= (rd_addr_i != '0);
    end
  end

endmodule
