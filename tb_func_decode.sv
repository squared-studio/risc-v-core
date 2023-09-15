module tb_func_decode;

  typedef enum int {
    LB,
    LBU,
    LH,
    LHU,
    LW,
    LWU,
    LD,
    FLD,
    FLW,
    FLQ,
    FENCE,
    ADDI,
    ANDI,
    ORI,
    SLLI,
    SLTI,
    SLTIU,
    SRAI,
    SRLI,
    XORI,
    AUIPC,
    ADDIW,
    SLLIW,
    SRAIW,
    SRLIW,
    SB,
    SH,
    SW,
    SD,
    FSD,
    FSW,
    FSQ,
    AMOADD_W,
    AMOAND_W,
    AMOMAX_W,
    AMOMAXU_W,
    AMOMIN_W,
    AMOMINU_W,
    AMOOR_W,
    AMOSWAP_W,
    AMOXOR_W,
    LR_W,
    SC_W,
    AMOADD_D,
    AMOAND_D,
    AMOMAX_D,
    AMOMAXU_D,
    AMOMIN_D,
    AMOMINU_D,
    AMOOR_D,
    AMOSWAP_D,
    AMOXOR_D,
    LR_D,
    SC_D,
    ADD,
    AND,
    OR,
    SLL,
    SLT,
    SLTU,
    SRA,
    SRL,
    SUB,
    XOR,
    DIV,
    DIVU,
    MUL,
    MULH,
    MULHSU,
    MULHU,
    REM,
    REMU,
    LUI,
    ADDW,
    SLLW,
    SRAW,
    SRLW,
    SUBW,
    DIVUW,
    DIVW,
    MULW,
    REMUW,
    REMW,
    FMADD_D,
    FMADD_S,
    FMADD_Q,
    FMSUB_D,
    FMSUB_S,
    FMSUB_Q,
    FNMSUB_D,
    FNMSUB_S,
    FNMSUB_Q,
    FNMADD_D,
    FNMADD_S,
    FNMADD_Q,
    FADD_D,
    FCLASS_D,
    FCVT_D_S,
    FCVT_D_W,
    FCVT_D_WU,
    FCVT_S_D,
    FCVT_W_D,
    FCVT_WU_D,
    FDIV_D,
    FEQ_D,
    FLE_D,
    FLT_D,
    FMAX_D,
    FMIN_D,
    FMUL_D,
    FSGNJ_D,
    FSGNJN_D,
    FSGNJX_D,
    FSQRT_D,
    FSUB_D,
    FADD_S,
    FCLASS_S,
    FCVT_S_W,
    FCVT_S_WU,
    FCVT_W_S,
    FCVT_WU_S,
    FDIV_S,
    FEQ_S,
    FLE_S,
    FLT_S,
    FMAX_S,
    FMIN_S,
    FMUL_S,
    FMV_W_X,
    FMV_X_W,
    FSGNJ_S,
    FSGNJN_S,
    FSGNJX_S,
    FSQRT_S,
    FSUB_S,
    FADD_Q,
    FCLASS_Q,
    FCVT_D_Q,
    FCVT_Q_D,
    FCVT_Q_S,
    FCVT_Q_W,
    FCVT_Q_WU,
    FCVT_S_Q,
    FCVT_W_Q,
    FCVT_WU_Q,
    FDIV_Q,
    FEQ_Q,
    FLE_Q,
    FLT_Q,
    FMAX_Q,
    FMIN_Q,
    FMUL_Q,
    FSGNJ_Q,
    FSGNJN_Q,
    FSGNJX_Q,
    FSQRT_Q,
    FSUB_Q,
    FCVT_D_L,
    FCVT_D_LU,
    FCVT_L_D,
    FCVT_LU_D,
    FMV_D_X,
    FMV_X_D,
    FCVT_L_S,
    FCVT_LU_S,
    FCVT_S_L,
    FCVT_S_LU,
    FCVT_L_Q,
    FCVT_LU_Q,
    FCVT_Q_L,
    FCVT_Q_LU,
    BEQ,
    BGE,
    BGEU,
    BLT,
    BLTU,
    BNE,
    JALR,
    JAL,
    EBREAK,
    ECALL
  } func_t;

  typedef struct packed {
    func_t       func;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rs3;
    logic [4:0]  rd;
    logic [31:0] imm;   // TODO RESIZE
  } decoded_inst_t;

  //  OPCODE  func rs1 rs2 rs3 rd imm
  //  7'h03     .   .   .   .   .  .
  //  7'h07     .   .   .   .   .  .
  //  7'h0F     .   .   .   .   .  .
  //  7'h13     .   .   .   .   .  .
  //  7'h17     x   x   x   x   x  x
  //  7'h1B     .   .   .   .   .  .
  //  7'h23     .   .   .   .   .  .
  //  7'h27     .   .   .   .   .  .
  //  7'h2F     .   .   .   .   .  .
  //  7'h33     .   .   .   .   .  .
  //  7'h37     x   x   x   x   x  x
  //  7'h3B     .   .   .   .   .  .
  //  7'h43     .   .   .   .   .  .
  //  7'h47     .   .   .   .   .  .
  //  7'h4B     .   .   .   .   .  .
  //  7'h4F     .   .   .   .   .  .
  //  7'h53     .   .   .   .   .  .
  //  7'h63     .   .   .   .   .  .
  //  7'h67     .   .   .   .   .  .
  //  7'h6F     .   .   .   .   .  .
  //  7'h73     .   .   .   .   .  .


  function automatic decoded_inst_t decode(bit [31:0] instr);
    decode = '0;
    case (instr[6:0])
      7'h03: begin
      end

      7'h07: begin
      end

      7'h0F: begin
      end

      7'h13: begin
      end

      7'h17: begin
        decode.rd         = instr[11:7];
        decode.imm[31:12] = instr[31:12];
        decode.func       = AUIPC;
      end

      7'h1B: begin
      end

      7'h23: begin
      end

      7'h27: begin
      end

      7'h2F: begin
      end

      7'h33: begin
      end

      7'h37: begin
        decode.rd         = instr[11:7];
        decode.imm[31:12] = instr[31:12];
        decode.func       = LUI;
      end

      7'h3B: begin
      end

      7'h43: begin
      end

      7'h47: begin
      end

      7'h4B: begin
      end

      7'h4F: begin
      end

      7'h53: begin
      end

      7'h63: begin
      end

      7'h67: begin
      end

      7'h6F: begin
      end

      7'h73: begin
      end

      default: return '0;
    endcase
  endfunction

  initial begin
    $display("Hello!!");
  end

endmodule
