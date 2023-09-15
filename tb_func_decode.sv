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
        case (instr[14:12])
          3'b000:  decode.func = LB;
          3'b001:  decode.func = LH;
          3'b010:  decode.func = LW;
          3'b011:  decode.func = LD;
          3'b100:  decode.func = LBU;
          3'b101:  decode.func = LHU;
          3'b110:  decode.func = LWU;
          default: return '0;
        endcase
        decode.rs1       = instr[19:15];
        decode.rd        = instr[11:7];
        decode.imm[11:0] = instr[31:20];
      end

      7'h07: begin
        case (instr[14:12])
          3'b010:  decode.func = FLW;
          3'b011:  decode.func = FLD;
          3'b100:  decode.func = FLQ;
          default: return '0;
        endcase
        decode.rs1       = instr[19:15];
        decode.rd        = instr[11:7];
        decode.imm[11:0] = instr[31:20];
      end

      7'h0F: begin
        case (instr[14:12])
          3'b001:  decode.func = FENCE;
          default: return '0;
        endcase
        decode.rs1       = instr[19:15];
        decode.rd        = instr[11:7];
        decode.imm[11:0] = instr[31:20];
      end

      7'h13: begin
        case (instr[14:12])
          3'b000: decode.func = ADDI;
          3'b010: decode.func = SLTI;
          3'b011: decode.func = SLTIU;
          3'b100: decode.func = XORI;
          3'b110: decode.func = ORI;
          3'b111: decode.func = ANDI;
          default: begin
            case ({
              instr[31:26], instr[14:12]
            })
              9'b000000_001: decode.func = SLLI;
              9'b000000_101: decode.func = SRLI;
              9'b010000_101: decode.func = SRAI;
              default: return '0;
            endcase
          end
        endcase
        decode.rs1       = instr[19:15];
        decode.rd        = instr[11:7];
        decode.imm[11:0] = instr[31:20];
      end

      7'h17: begin
        decode.func       = AUIPC;
        decode.rd         = instr[11:7];
        decode.imm[31:12] = instr[31:12];
      end

      7'h1B: begin
        case (instr[14:12])
          3'b000: decode.func = ADDIW;
          default: begin
            case ({
              instr[31:26], instr[14:12]
            })
              9'b000000_001: decode.func = SLLIW;
              9'b000000_101: decode.func = SRLIW;
              9'b010000_101: decode.func = SRAIW;
              default: return '0;
            endcase
          end
        endcase
        decode.rs1       = instr[19:15];
        decode.rd        = instr[11:7];
        decode.imm[11:0] = instr[31:20];
      end

      7'h23: begin
        case (instr[14:12])
          3'b000:  decode.func = SB;
          3'b001:  decode.func = SH;
          3'b010:  decode.func = SW;
          3'b011:  decode.func = SD;
          default: return '0;
        endcase
        decode.rs1       = instr[19:15];
        decode.rs2       = instr[24:20];
        decode.imm[11:5] = instr[31:25];
        decode.imm[4:0]  = instr[11:7];
      end

      7'h27: begin
        case (instr[14:12])
          3'b010:  decode.func = FSW;
          3'b011:  decode.func = FSD;
          3'b100:  decode.func = FSQ;
          default: return '0;
        endcase
        decode.rs1       = instr[19:15];
        decode.rs2       = instr[24:20];
        decode.imm[11:5] = instr[31:25];
        decode.imm[4:0]  = instr[11:7];
      end

      7'h2F: begin
        case ({
          instr[31:27], instr[14:12]
        })
          8'b00010_010: decode.func = LR_W;
          8'b00011_010: decode.func = SC_W;
          8'b00001_010: decode.func = AMOSWAP_W;
          8'b00000_010: decode.func = AMOADD_W;
          8'b00100_010: decode.func = AMOXOR_W;
          8'b01100_010: decode.func = AMOAND_W;
          8'b01000_010: decode.func = AMOOR_W;
          8'b10000_010: decode.func = AMOMIN_W;
          8'b10100_010: decode.func = AMOMAX_W;
          8'b11000_010: decode.func = AMOMINU_W;
          8'b11100_010: decode.func = AMOMAXU_W;
          8'b00010_011: decode.func = LR_D;
          8'b00011_011: decode.func = SC_D;
          8'b00001_011: decode.func = AMOSWAP_D;
          8'b00000_011: decode.func = AMOADD_D;
          8'b00100_011: decode.func = AMOXOR_D;
          8'b01100_011: decode.func = AMOAND_D;
          8'b01000_011: decode.func = AMOOR_D;
          8'b10000_011: decode.func = AMOMIN_D;
          8'b10100_011: decode.func = AMOMAX_D;
          8'b11000_011: decode.func = AMOMINU_D;
          8'b11100_011: decode.func = AMOMAXU_D;
          default: return '0;
        endcase
        decode.rs1      = instr[19:15];
        decode.rs2      = instr[24:20];
        decode.rd       = instr[11:7];
        decode.imm[1:0] = instr[26:25];
      end

      7'h33: begin
        case ({
          instr[31:25], instr[14:12]
        })
          10'b0000000_000: decode.func = ADD;
          10'b0100000_000: decode.func = SUB;
          10'b0000000_001: decode.func = SLL;
          10'b0000000_010: decode.func = SLT;
          10'b0000000_011: decode.func = SLTU;
          10'b0000000_100: decode.func = XOR;
          10'b0000000_101: decode.func = SRL;
          10'b0100000_101: decode.func = SRA;
          10'b0000000_110: decode.func = OR;
          10'b0000000_111: decode.func = AND;
          10'b0000001_000: decode.func = MUL;
          10'b0000001_001: decode.func = MULH;
          10'b0000001_010: decode.func = MULHSU;
          10'b0000001_011: decode.func = MULHU;
          10'b0000001_100: decode.func = DIV;
          10'b0000001_101: decode.func = DIVU;
          10'b0000001_110: decode.func = REM;
          10'b0000001_111: decode.func = REMU;
          default: return '0;
        endcase
        decode.rs1 = instr[19:15];
        decode.rs2 = instr[24:20];
        decode.rd  = instr[11:7];
      end

      7'h37: begin
        decode.func       = LUI;
        decode.rd         = instr[11:7];
        decode.imm[31:12] = instr[31:12];
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
