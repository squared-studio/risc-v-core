module tb_func_decode;

  typedef enum int {
    INVALID_INSTRUCTION,
    ADD,
    ADDI,
    ADDIW,
    ADDW,
    AMOADD_D,
    AMOADD_W,
    AMOAND_D,
    AMOAND_W,
    AMOMAX_D,
    AMOMAX_W,
    AMOMAXU_D,
    AMOMAXU_W,
    AMOMIN_D,
    AMOMIN_W,
    AMOMINU_D,
    AMOMINU_W,
    AMOOR_D,
    AMOOR_W,
    AMOSWAP_D,
    AMOSWAP_W,
    AMOXOR_D,
    AMOXOR_W,
    AND,
    ANDI,
    AUIPC,
    BEQ,
    BGE,
    BGEU,
    BLT,
    BLTU,
    BNE,
    DIV,
    DIVU,
    DIVUW,
    DIVW,
    EBREAK,
    ECALL,
    FADD_D,
    FADD_Q,
    FADD_S,
    FCLASS_D,
    FCLASS_Q,
    FCLASS_S,
    FCVT_D_L,
    FCVT_D_LU,
    FCVT_D_Q,
    FCVT_D_S,
    FCVT_D_W,
    FCVT_D_WU,
    FCVT_L_D,
    FCVT_L_Q,
    FCVT_L_S,
    FCVT_LU_D,
    FCVT_LU_Q,
    FCVT_LU_S,
    FCVT_Q_D,
    FCVT_Q_L,
    FCVT_Q_LU,
    FCVT_Q_S,
    FCVT_Q_W,
    FCVT_Q_WU,
    FCVT_S_D,
    FCVT_S_L,
    FCVT_S_LU,
    FCVT_S_Q,
    FCVT_S_W,
    FCVT_S_WU,
    FCVT_W_D,
    FCVT_W_Q,
    FCVT_W_S,
    FCVT_WU_D,
    FCVT_WU_Q,
    FCVT_WU_S,
    FDIV_D,
    FDIV_Q,
    FDIV_S,
    FENCE,
    FEQ_D,
    FEQ_Q,
    FEQ_S,
    FLD,
    FLE_D,
    FLE_Q,
    FLE_S,
    FLQ,
    FLT_D,
    FLT_Q,
    FLT_S,
    FLW,
    FMADD_D,
    FMADD_Q,
    FMADD_S,
    FMAX_D,
    FMAX_Q,
    FMAX_S,
    FMIN_D,
    FMIN_Q,
    FMIN_S,
    FMSUB_D,
    FMSUB_Q,
    FMSUB_S,
    FMUL_D,
    FMUL_Q,
    FMUL_S,
    FMV_D_X,
    FMV_W_X,
    FMV_X_D,
    FMV_X_W,
    FNMADD_D,
    FNMADD_Q,
    FNMADD_S,
    FNMSUB_D,
    FNMSUB_Q,
    FNMSUB_S,
    FSD,
    FSGNJ_D,
    FSGNJ_Q,
    FSGNJ_S,
    FSGNJN_D,
    FSGNJN_Q,
    FSGNJN_S,
    FSGNJX_D,
    FSGNJX_Q,
    FSGNJX_S,
    FSQ,
    FSQRT_D,
    FSQRT_Q,
    FSQRT_S,
    FSUB_D,
    FSUB_Q,
    FSUB_S,
    FSW,
    JAL,
    JALR,
    LB,
    LBU,
    LD,
    LH,
    LHU,
    LR_D,
    LR_W,
    LUI,
    LW,
    LWU,
    MUL,
    MULH,
    MULHSU,
    MULHU,
    MULW,
    OR,
    ORI,
    REM,
    REMU,
    REMUW,
    REMW,
    SB,
    SC_D,
    SC_W,
    SD,
    SH,
    SLL,
    SLLI,
    SLLIW,
    SLLW,
    SLT,
    SLTI,
    SLTIU,
    SLTU,
    SRA,
    SRAI,
    SRAIW,
    SRAW,
    SRL,
    SRLI,
    SRLIW,
    SRLW,
    SUB,
    SUBW,
    SW,
    XOR,
    XORI
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
  //  7'h53     .   .   .   .   .  .


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
        case ({
          instr[31:25], instr[14:12]
        })
          10'b0000000_000: decode.func = ADDW;
          10'b0100000_000: decode.func = SUBW;
          10'b0000000_001: decode.func = SLLW;
          10'b0000000_101: decode.func = SRLW;
          10'b0100000_101: decode.func = SRAW;
          10'b0000001_000: decode.func = MULW;
          10'b0000001_100: decode.func = DIVW;
          10'b0000001_101: decode.func = DIVUW;
          10'b0000001_110: decode.func = REMW;
          10'b0000001_111: decode.func = REMUW;
          default: return '0;
        endcase
        decode.rs1 = instr[19:15];
        decode.rs2 = instr[24:20];
        decode.rd  = instr[11:7];
      end

      7'h43: begin
        case (instr[26:25])
          2'b00:   decode.func = FMADD_S;
          2'b00:   decode.func = FMADD_D;
          2'b11:   decode.func = FMADD_Q;
          default: return '0;
        endcase
        decode.rs1      = instr[19:15];
        decode.rs2      = instr[24:20];
        decode.rs3      = instr[31:27];
        decode.rd       = instr[11:7];
        decode.imm[2:0] = instr[14:12];
      end

      7'h47: begin
        case (instr[26:25])
          2'b00:   decode.func = FMSUB_S;
          2'b00:   decode.func = FMSUB_D;
          2'b11:   decode.func = FMSUB_Q;
          default: return '0;
        endcase
        decode.rs1      = instr[19:15];
        decode.rs2      = instr[24:20];
        decode.rs3      = instr[31:27];
        decode.rd       = instr[11:7];
        decode.imm[2:0] = instr[14:12];
      end

      7'h4B: begin
        case (instr[26:25])
          2'b00:   decode.func = FNMSUB_S;
          2'b00:   decode.func = FNMSUB_D;
          2'b11:   decode.func = FNMSUB_Q;
          default: return '0;
        endcase
        decode.rs1      = instr[19:15];
        decode.rs2      = instr[24:20];
        decode.rs3      = instr[31:27];
        decode.rd       = instr[11:7];
        decode.imm[2:0] = instr[14:12];
      end

      7'h4F: begin
        case (instr[26:25])
          2'b00:   decode.func = FNMADD_S;
          2'b00:   decode.func = FNMADD_D;
          2'b11:   decode.func = FNMADD_Q;
          default: return '0;
        endcase
        decode.rs1      = instr[19:15];
        decode.rs2      = instr[24:20];
        decode.rs3      = instr[31:27];
        decode.rd       = instr[11:7];
        decode.imm[2:0] = instr[14:12];
      end

      7'h53: begin
        // TODO INSTR
        decode.rs1      = instr[19:15];
        decode.rs2      = instr[24:20];
        decode.rd       = instr[11:7];
        decode.imm[2:0] = instr[14:12];
      end

      7'h63: begin
        case (instr[14:12])
          3'b000:  decode.func = BEQ;
          3'b001:  decode.func = BNE;
          3'b100:  decode.func = BLT;
          3'b101:  decode.func = BGE;
          3'b110:  decode.func = BLTU;
          3'b111:  decode.func = BGEU;
          default: return '0;
        endcase
        decode.rs1       = instr[19:15];
        decode.rs2       = instr[24:20];
        decode.imm[12]   = instr[31];
        decode.imm[10:5] = instr[30:25];
        decode.imm[4:1]  = instr[11:8];
        decode.imm[11]   = instr[7];
      end

      7'h67: begin
        case (instr[14:12])
          3'b000:  decode.func = JALR;
          default: return '0;
        endcase
        decode.rs1       = instr[19:15];
        decode.rd        = instr[11:7];
        decode.imm[11:0] = instr[14:12];
      end

      7'h6F: begin
        decode.func       = JAL;
        decode.rd         = instr[11:7];
        decode.imm[20]    = instr[31];
        decode.imm[10:1]  = instr[30:21];
        decode.imm[11]    = instr[20];
        decode.imm[19:12] = instr[19:12];
      end

      7'h73: begin
        case (instr[31:7])
          25'b000000000000_00000_000_00000: decode.func = ECALL;
          25'b000000000001_00000_000_00000: decode.func = EBREAK;
          default: return '0;
        endcase
      end

      default: return '0;
    endcase
  endfunction

  initial begin
    $display("Hello!!");
  end

endmodule
