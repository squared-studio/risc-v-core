/*

.---------------------------------------------------------------------------------------------.
|                         Floating-Point Control and Status Registers                         |
.--------.------------.----------.------------------------------------------------------------.
| Number | Privilege  | Name     | Description                                                |
|--------+------------+----------+------------------------------------------------------------|
| 0x001  | Read/write | fflags   | Floating-Point Accrued Exceptions.                         |
| 0x002  | Read/write | frm      | Floating-Point Dynamic Rounding Mode.                      |
| 0x003  | Read/write | fcsr     | Floating-Point Control and Status Register (frm + fflags). |
'--------'------------'----------'------------------------------------------------------------'

.---------------------------------------------------------------------------------------------.
|                                     Counters and Timers                                     |
|--------.------------.----------.------------------------------------------------------------|
| Number | Privilege  | Name     | Description                                                |
|--------+------------+----------+------------------------------------------------------------|
| 0xC00  | Read-only  | cycle    | Cycle counter for RDCYCLE instruction.                     |
| 0xC01  | Read-only  | time     | Timer for RDTIME instruction.                              |
| 0xC02  | Read-only  | instret  | Instructions-retired counter for RDINSTRET instruction.    |
| 0xC80  | Read-only  | cycleh   | Upper 32 bits of cycle, RV32I only.                        |
| 0xC81  | Read-only  | timeh    | Upper 32 bits of time, RV32I only.                         |
| 0xC82  | Read-only  | instreth | Upper 32 bits of instret, RV32I only.                      |
'--------'------------'----------'------------------------------------------------------------'

Table 24.3: RISC-V control and status register (CSR) address map.

*/

module tb_func_decode;

  initial begin
    $display("\033[7;38m####################### TEST STARTED #######################\033[0m");
    $timeformat(-6, 3, "us");
    repeat (1000) repeat (1000) repeat (1000) #1000;
    $display("\033[1;31m[FATAL][TIMEOUT]\033[0m");
    $finish;
  end

  final begin
    $display("\033[7;38m######################## TEST ENDED ########################\033[0m");
  end

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
    CSRRC,
    CSRRCI,
    CSRRS,
    CSRRSI,
    CSRRW,
    CSRRWI,
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
    FENCE_I,
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

  typedef enum logic [2:0] {
    RNE = 0,
    RTZ = 1,
    RDN = 2,
    RUP = 3,
    RMM = 4,
    RM_RES_5 = 5,
    RM_RES_6 = 6,
    DYN = 7
  } rm_t;

  typedef struct packed {
    func_t       func;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rs3;
    logic [4:0]  rd;
    logic [31:0] imm;
    logic [4:0]  shamt;

    logic [3:0] fm;
    logic [3:0] pred;
    logic [3:0] succ;

    logic aq;
    logic rl;

    rm_t rm;

    logic [31:0] uimm;
    logic [11:0] csr;

  } decoded_inst_t;

  function automatic decoded_inst_t decode(bit [31:0] instr);
    decode = '0;
    case (instr[6:0])
      7'h03: begin
        decode.rs1       = instr[19:15];
        decode.rd        = instr[11:7];
        decode.imm[11:0] = instr[31:20];
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
      end

      7'h07: begin
        decode.rs1       = instr[19:15];
        decode.rd        = instr[11:7];
        decode.imm[11:0] = instr[31:20];
        case (instr[14:12])
          3'b010:  decode.func = FLW;
          3'b011:  decode.func = FLD;
          3'b100:  decode.func = FLQ;
          default: return '0;
        endcase
      end

      7'h0F: begin
        decode.rs1 = instr[19:15];
        decode.rd  = instr[11:7];
        case (instr[14:12])
          3'b000: begin
            decode.fm   = instr[31:28];
            decode.pred = instr[27:24];
            decode.succ = instr[23:20];
          end
          3'b001: begin
            decode.imm[11:0] = instr[31:20];
          end
          default: return '0;
        endcase
        case (instr[14:12])
          3'b000:  decode.func = FENCE;
          3'b001:  decode.func = FENCE_I;
          default: return '0;
        endcase
      end

      7'h13: begin
        decode.rs1       = instr[19:15];
        decode.rd        = instr[11:7];
        decode.imm[11:0] = instr[31:20];
        case (instr[14:12])
          3'b000: decode.func = ADDI;
          3'b010: decode.func = SLTI;
          3'b011: decode.func = SLTIU;
          3'b100: decode.func = XORI;
          3'b110: decode.func = ORI;
          3'b111: decode.func = ANDI;
          default: begin
            decode.imm   = '0;
            decode.shamt = instr[24:20];
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
      end

      7'h17: begin
        decode.rd         = instr[11:7];
        decode.imm[31:12] = instr[31:12];
        decode.func       = AUIPC;
      end

      7'h1B: begin
        decode.rs1       = instr[19:15];
        decode.rd        = instr[11:7];
        decode.imm[11:0] = instr[31:20];
        case (instr[14:12])
          3'b000: decode.func = ADDIW;
          default: begin
            decode.imm   = '0;
            decode.shamt = instr[24:20];
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
      end

      7'h23: begin
        decode.rs1       = instr[19:15];
        decode.rs2       = instr[24:20];
        decode.imm[11:5] = instr[31:25];
        decode.imm[4:0]  = instr[11:7];
        case (instr[14:12])
          3'b000:  decode.func = SB;
          3'b001:  decode.func = SH;
          3'b010:  decode.func = SW;
          3'b011:  decode.func = SD;
          default: return '0;
        endcase
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
        decode.rs1 = instr[19:15];
        decode.rs2 = instr[24:20];
        decode.rd  = instr[11:7];
        decode.aq  = instr[26];
        decode.rl  = instr[25];
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
      end

      7'h33: begin
        decode.rs1 = instr[19:15];
        decode.rs2 = instr[24:20];
        decode.rd  = instr[11:7];
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
      end

      7'h37: begin
        decode.rd         = instr[11:7];
        decode.imm[31:12] = instr[31:12];
        decode.func       = LUI;
      end

      7'h3B: begin
        decode.rs1 = instr[19:15];
        decode.rs2 = instr[24:20];
        decode.rd  = instr[11:7];
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
      end

      7'h43: begin
        decode.rs1 = instr[19:15];
        decode.rs2 = instr[24:20];
        decode.rs3 = instr[31:27];
        decode.rd  = instr[11:7];
        decode.rm  = rm_t'(instr[14:12]);
        case (instr[26:25])
          2'b00:   decode.func = FMADD_S;
          2'b00:   decode.func = FMADD_D;
          2'b11:   decode.func = FMADD_Q;
          default: return '0;
        endcase
      end

      7'h47: begin
        decode.rs1 = instr[19:15];
        decode.rs2 = instr[24:20];
        decode.rs3 = instr[31:27];
        decode.rd  = instr[11:7];
        decode.rm  = rm_t'(instr[14:12]);
        case (instr[26:25])
          2'b00:   decode.func = FMSUB_S;
          2'b00:   decode.func = FMSUB_D;
          2'b11:   decode.func = FMSUB_Q;
          default: return '0;
        endcase
      end

      7'h4B: begin
        decode.rs1 = instr[19:15];
        decode.rs2 = instr[24:20];
        decode.rs3 = instr[31:27];
        decode.rd  = instr[11:7];
        decode.rm  = rm_t'(instr[14:12]);
        case (instr[26:25])
          2'b00:   decode.func = FNMSUB_S;
          2'b00:   decode.func = FNMSUB_D;
          2'b11:   decode.func = FNMSUB_Q;
          default: return '0;
        endcase
      end

      7'h4F: begin
        decode.rs1 = instr[19:15];
        decode.rs2 = instr[24:20];
        decode.rs3 = instr[31:27];
        decode.rd  = instr[11:7];
        decode.rm  = rm_t'(instr[14:12]);
        case (instr[26:25])
          2'b00:   decode.func = FNMADD_S;
          2'b00:   decode.func = FNMADD_D;
          2'b11:   decode.func = FNMADD_Q;
          default: return '0;
        endcase
      end

      7'h53: begin
        case (instr[31:25])
          //--------------------------------------------------------------------
          7'b0000000, 7'b0000001, 7'b0000011, 7'b0000100, 7'b0000101,
          7'b0000111, 7'b0001000, 7'b0001001, 7'b0001011, 7'b0001100,
          7'b0001101, 7'b0001111 : begin
            decode.rs1 = instr[19:15];
            decode.rs2 = instr[24:20];
            decode.rd  = instr[11:7];
            decode.rm  = rm_t'(instr[14:12]);
            case (instr[31:25])
              7'b0000000: decode.func = FADD_S;
              7'b0000001: decode.func = FADD_D;
              7'b0000011: decode.func = FADD_Q;
              7'b0000100: decode.func = FSUB_S;
              7'b0000101: decode.func = FSUB_D;
              7'b0000111: decode.func = FSUB_Q;
              7'b0001000: decode.func = FMUL_S;
              7'b0001001: decode.func = FMUL_D;
              7'b0001011: decode.func = FMUL_Q;
              7'b0001100: decode.func = FDIV_S;
              7'b0001101: decode.func = FDIV_D;
              7'b0001111: decode.func = FDIV_Q;
              default: return '0;
            endcase
          end
          //--------------------------------------------------------------------
          7'b0010000, 7'b0010001, 7'b0010011, 7'b0010100, 7'b0010101,
          7'b0010111, 7'b1010000, 7'b1010001, 7'b1010011 : begin
            decode.rs1 = instr[19:15];
            decode.rs2 = instr[24:20];
            decode.rd  = instr[11:7];
            case ({
              instr[31:25], instr[14:12]
            })
              10'b0010000_000: decode.func = FSGNJ_S;
              10'b0010000_001: decode.func = FSGNJN_S;
              10'b0010000_010: decode.func = FSGNJX_S;
              10'b0010001_000: decode.func = FSGNJ_D;
              10'b0010001_001: decode.func = FSGNJN_D;
              10'b0010001_010: decode.func = FSGNJX_D;
              10'b0010011_000: decode.func = FSGNJ_Q;
              10'b0010011_001: decode.func = FSGNJN_Q;
              10'b0010011_010: decode.func = FSGNJX_Q;
              10'b0010100_000: decode.func = FMIN_S;
              10'b0010100_001: decode.func = FMAX_S;
              10'b0010101_000: decode.func = FMIN_D;
              10'b0010101_001: decode.func = FMAX_D;
              10'b0010111_000: decode.func = FMIN_Q;
              10'b0010111_001: decode.func = FMAX_Q;
              10'b1010000_000: decode.func = FLE_S;
              10'b1010000_001: decode.func = FLT_S;
              10'b1010000_010: decode.func = FEQ_S;
              10'b1010001_000: decode.func = FLE_D;
              10'b1010001_001: decode.func = FLT_D;
              10'b1010001_010: decode.func = FEQ_D;
              10'b1010011_000: decode.func = FLE_Q;
              10'b1010011_001: decode.func = FLT_Q;
              10'b1010011_010: decode.func = FEQ_Q;
              default: return '0;
            endcase
          end
          //--------------------------------------------------------------------
          7'b0100000, 7'b0100001, 7'b0100011, 7'b0101100, 7'b0101101,
          7'b0101111, 7'b1100000, 7'b1100001, 7'b1100011, 7'b1101000,
          7'b1101001, 7'b1101011 : begin
            decode.rs1 = instr[19:15];
            decode.rd  = instr[11:7];
            decode.rm  = rm_t'(instr[14:12]);
            case ({
              instr[31:25], instr[24:20]
            })
              12'b0100000_00001: decode.func = FCVT_S_D;
              12'b0100000_00011: decode.func = FCVT_S_Q;
              12'b0100001_00000: decode.func = FCVT_D_S;
              12'b0100001_00011: decode.func = FCVT_D_Q;
              12'b0100011_00000: decode.func = FCVT_Q_S;
              12'b0100011_00001: decode.func = FCVT_Q_D;
              12'b0101100_00000: decode.func = FSQRT_S;
              12'b0101101_00000: decode.func = FSQRT_D;
              12'b0101111_00000: decode.func = FSQRT_Q;
              12'b1100000_00000: decode.func = FCVT_W_S;
              12'b1100000_00001: decode.func = FCVT_WU_S;
              12'b1100000_00010: decode.func = FCVT_L_S;
              12'b1100000_00011: decode.func = FCVT_LU_S;
              12'b1100001_00000: decode.func = FCVT_W_D;
              12'b1100001_00001: decode.func = FCVT_WU_D;
              12'b1100001_00010: decode.func = FCVT_L_D;
              12'b1100001_00011: decode.func = FCVT_LU_D;
              12'b1100011_00000: decode.func = FCVT_W_Q;
              12'b1100011_00001: decode.func = FCVT_WU_Q;
              12'b1100011_00010: decode.func = FCVT_L_Q;
              12'b1100011_00011: decode.func = FCVT_LU_Q;
              12'b1101000_00000: decode.func = FCVT_S_W;
              12'b1101000_00001: decode.func = FCVT_S_WU;
              12'b1101000_00010: decode.func = FCVT_S_L;
              12'b1101000_00011: decode.func = FCVT_S_LU;
              12'b1101001_00000: decode.func = FCVT_D_W;
              12'b1101001_00001: decode.func = FCVT_D_WU;
              12'b1101001_00010: decode.func = FCVT_D_L;
              12'b1101001_00011: decode.func = FCVT_D_LU;
              12'b1101011_00000: decode.func = FCVT_Q_W;
              12'b1101011_00001: decode.func = FCVT_Q_WU;
              12'b1101011_00010: decode.func = FCVT_Q_L;
              12'b1101011_00011: decode.func = FCVT_Q_LU;
              default: return '0;
            endcase
          end
          //--------------------------------------------------------------------
          7'b1110000, 7'b1110001, 7'b1110011, 7'b1111000, 7'b1111001: begin
            decode.rs1 = instr[19:15];
            decode.rd  = instr[11:7];
            case ({
              instr[31:25], instr[24:20], instr[14:12]
            })
              15'b1110000_00000_000: decode.func = FMV_X_W;
              15'b1110000_00000_001: decode.func = FCLASS_S;
              15'b1110001_00000_000: decode.func = FMV_X_D;
              15'b1110001_00000_001: decode.func = FCLASS_D;
              15'b1110011_00000_001: decode.func = FCLASS_Q;
              15'b1111000_00000_000: decode.func = FMV_W_X;
              15'b1111001_00000_000: decode.func = FMV_D_X;
              default: return '0;
            endcase
          end
          //--------------------------------------------------------------------
          default: return '0;
        endcase
      end

      7'h63: begin
        decode.rs1       = instr[19:15];
        decode.rs2       = instr[24:20];
        decode.imm[12]   = instr[31];
        decode.imm[10:5] = instr[30:25];
        decode.imm[4:1]  = instr[11:8];
        decode.imm[11]   = instr[7];
        case (instr[14:12])
          3'b000:  decode.func = BEQ;
          3'b001:  decode.func = BNE;
          3'b100:  decode.func = BLT;
          3'b101:  decode.func = BGE;
          3'b110:  decode.func = BLTU;
          3'b111:  decode.func = BGEU;
          default: return '0;
        endcase
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
        decode.rd         = instr[11:7];
        decode.imm[20]    = instr[31];
        decode.imm[10:1]  = instr[30:21];
        decode.imm[11]    = instr[20];
        decode.imm[19:12] = instr[19:12];
        decode.func       = JAL;
      end

      7'h73: begin
        case (instr[31:7])
          25'b000000000000_00000_000_00000: decode.func = ECALL;
          25'b000000000001_00000_000_00000: decode.func = EBREAK;
          default: begin
            if (instr[14]) decode.uimm[4:0] = instr[19:15];
            else decode.rs1 = instr[19:15];
            decode.csr = instr[31:20];
            decode.rd  = instr[11:7];
            case (instr[14:12])
              3'b001:  decode.func = CSRRW;
              3'b010:  decode.func = CSRRS;
              3'b011:  decode.func = CSRRC;
              3'b101:  decode.func = CSRRWI;
              3'b110:  decode.func = CSRRSI;
              3'b111:  decode.func = CSRRCI;
              default: return '0;
            endcase
          end
        endcase
      end

      default: return '0;
    endcase
  endfunction

  initial begin
    $display("%p", decode('h06f00293));
    $display("%p", decode('h0de00313));
    $display("%p", decode('h006283b3));
    $display("%p", decode('h006283b0));
    $finish;
  end

endmodule
