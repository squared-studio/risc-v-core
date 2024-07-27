/*
Description
Author : Foez Ahmed (foez.official@gmail.com)
*/

module rv_g_regfile_tb;

  //`define ENABLE_DUMPFILE

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // bring in the testbench essentials functions and macros
  `include "vip/tb_ess.sv"

  import "DPI-C" function void model_reset();
  import "DPI-C" function void set_XLEN(longint val);
  import "DPI-C" function void set_FLEN(longint val);
  import "DPI-C" function void set_allow_forwarding(longint val);
  import "DPI-C" function void set_wr_addr_i(longint val);
  import "DPI-C" function void set_wr_data_i(longint val);
  import "DPI-C" function void set_wr_en_i(longint val);
  import "DPI-C" function void set_rd_addr_i(longint val);
  import "DPI-C" function void set_rs1_addr_i(longint val);
  import "DPI-C" function void set_rs2_addr_i(longint val);
  import "DPI-C" function void set_rs3_addr_i(longint val);
  import "DPI-C" function void set_req_i(longint val);
  import "DPI-C" function longint get_XLEN();
  import "DPI-C" function longint get_FLEN();
  import "DPI-C" function longint get_allow_forwarding();
  import "DPI-C" function longint get_wr_addr_i();
  import "DPI-C" function longint get_wr_data_i();
  import "DPI-C" function longint get_wr_en_i();
  import "DPI-C" function longint get_rd_addr_i();
  import "DPI-C" function longint get_rs1_addr_i();
  import "DPI-C" function longint get_rs2_addr_i();
  import "DPI-C" function longint get_rs3_addr_i();
  import "DPI-C" function longint get_req_i();
  import "DPI-C" function longint get_rs1_data_o();
  import "DPI-C" function longint get_rs2_data_o();
  import "DPI-C" function longint get_rs3_data_o();
  import "DPI-C" function longint get_gnt_o();
  import "DPI-C" function void clock_tick();
  import "DPI-C" function longint get_lock(int index);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS
  //////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef C32320
  localparam int XLEN = 32;
  localparam int FLEN = 32;
  localparam bit AllowForwarding = 0;
`elsif C32321
  localparam int XLEN = 32;
  localparam int FLEN = 32;
  localparam bit AllowForwarding = 1;
`elsif C32640
  localparam int XLEN = 32;
  localparam int FLEN = 64;
  localparam bit AllowForwarding = 0;
`elsif C32641
  localparam int XLEN = 32;
  localparam int FLEN = 64;
  localparam bit AllowForwarding = 1;
`elsif C64320
  localparam int XLEN = 64;
  localparam int FLEN = 32;
  localparam bit AllowForwarding = 0;
`elsif C64321
  localparam int XLEN = 64;
  localparam int FLEN = 32;
  localparam bit AllowForwarding = 1;
`elsif C64640
  localparam int XLEN = 64;
  localparam int FLEN = 64;
  localparam bit AllowForwarding = 0;
`elsif C64641
  localparam int XLEN = 64;
  localparam int FLEN = 64;
  localparam bit AllowForwarding = 1;
`else
  localparam int XLEN = 64;
  localparam int FLEN = 64;
  localparam bit AllowForwarding = 1;
`endif

  localparam int MaxLen = (XLEN > FLEN) ? XLEN : FLEN;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-TYPEDEFS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // generates static task start_clk_i with tHigh:4ns tLow:6ns

  `CREATE_CLK(clk_i, 4ns, 6ns)
  logic              arst_ni = 1;
  logic [       5:0] wr_addr_i = '0;
  logic [MaxLen-1:0] wr_data_i = '0;
  logic              wr_en_i = '0;
  logic [       5:0] rd_addr_i = '0;
  logic [       5:0] rs1_addr_i = '0;
  logic [       5:0] rs2_addr_i = '0;
  logic [       5:0] rs3_addr_i = '0;
  logic              req_i = '0;
  logic [MaxLen-1:0] rs1_data_o;
  logic [MaxLen-1:0] rs2_data_o;
  logic [MaxLen-1:0] rs3_data_o;
  logic              gnt_o;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  bit                rs1_data_o_ok;
  bit                rs2_data_o_ok;
  bit                rs3_data_o_ok;
  bit                gnt_o_ok;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  rv_g_regfile #(
      .XLEN(XLEN),
      .FLEN(FLEN),
      .ALLOW_FORWARDING(AllowForwarding)
  ) u_rv_g_regfile (
      .arst_ni,
      .clk_i,
      .wr_addr_i,
      .wr_data_i,
      .wr_en_i,
      .rd_addr_i,
      .rs1_addr_i,
      .rs2_addr_i,
      .rs3_addr_i,
      .req_i,
      .rs1_data_o,
      .rs2_data_o,
      .rs3_data_o,
      .gnt_o
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  function automatic bit [63:0] model_get_locks();
    for (int i = 0; i < 64; i++) model_get_locks[i] = get_lock(i);
  endfunction

  function automatic bit [63:0] rtl_get_locks();
    for (int i = 0; i < 64; i++) rtl_get_locks[i] = u_rv_g_regfile.lock[i];
  endfunction

  task static apply_reset();
    #100ns;
    model_reset();
    arst_ni       <= 0;
    rs1_data_o_ok <= '1;
    rs2_data_o_ok <= '1;
    rs3_data_o_ok <= '1;
    gnt_o_ok      <= '1;
    #100ns;
    arst_ni <= 1;
    #100ns;
  endtask

  task static start_driver();
    fork
      forever begin
        @(posedge clk_i);
        wr_addr_i  <= {$urandom};
        wr_data_i  <= {$urandom, $urandom};
        wr_en_i    <= {$urandom};
        rd_addr_i  <= {$urandom};
        rs1_addr_i <= {$urandom};
        rs2_addr_i <= {$urandom};
        rs3_addr_i <= {$urandom};
        req_i      <= {$urandom};
      end
    join_none
  endtask

  `define CHECK(__SIGNAL__)                                              \
    if (get_``__SIGNAL__``() != ``__SIGNAL__``) begin                    \
      $warning(`"\n``__SIGNAL__`` - RTL:0x%0h MDL:0x%0h req_i:0x%0h\n`", \
        ``__SIGNAL__``, get_``__SIGNAL__``(), get_req_i());              \
      ``__SIGNAL__``_ok = '0;                                            \
    end                                                                  \

  task static start_checker();
    fork
      forever begin
        @(posedge clk_i);
        set_wr_addr_i(wr_addr_i);
        set_wr_data_i(wr_data_i);
        set_wr_en_i(wr_en_i);
        set_rd_addr_i(rd_addr_i);
        set_rs1_addr_i(rs1_addr_i);
        set_rs2_addr_i(rs2_addr_i);
        set_rs3_addr_i(rs3_addr_i);
        set_req_i(req_i);
        clock_tick();
        `CHECK(rs1_data_o)
        `CHECK(rs2_data_o)
        `CHECK(rs3_data_o)
        `CHECK(gnt_o)
      end
    join_none
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin  // main initial

    $display("XLEN:%0d FLEN:%0d ALLOW_FORWARDING:%0d", XLEN, FLEN, AllowForwarding);

    set_XLEN(XLEN);
    set_FLEN(FLEN);
    set_allow_forwarding(AllowForwarding);

    apply_reset();
    start_clk_i();

    @(posedge clk_i);
    start_driver();
    start_checker();

    repeat (10000) @(posedge clk_i);

    result_print(rs1_data_o_ok, "rs1_data_o");
    result_print(rs2_data_o_ok, "rs2_data_o");
    result_print(rs3_data_o_ok, "rs3_data_o");
    result_print(gnt_o_ok, "gnt_o     ");

    $finish;

  end

endmodule
