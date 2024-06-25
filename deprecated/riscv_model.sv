// ### Authors : Foez Ahmed (foez.official@gmail.com), Md. Mohiuddin Reyad (mreyad30207@gmail.com)

// SUPPORTED INSTRUCTION SET
// RV32I            RV32M            RV32Zifencei     RV32Zicsr
// RV64I            RV64M            RV64Zifencei     RV64Zicsr
// RV32A            RV32F            RV32D            RV32Q
// RV64A            RV64F            RV64D            RV64Q
class riscv_model #(
    parameter bit SOFT_MEM = 1,
    parameter int XLEN     = 64
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-TYPEDEFS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  typedef enum int {  //{{{
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
    XORI,
    INVALID_INSTRUCTION_LAST
  } func_t;  //}}}

  typedef enum logic [2:0] {  //{{{
    RNE = 0,
    RTZ = 1,
    RDN = 2,
    RUP = 3,
    RMM = 4,
    RM_RES_5 = 5,
    RM_RES_6 = 6,
    DYN = 7
  } rm_t;  //}}}

  typedef struct packed {  //{{{
    func_t       func;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rs3;
    logic [4:0]  rd;
    logic [31:0] imm;
    logic [5:0]  shamt;
    logic [3:0]  fm;
    logic [3:0]  pred;
    logic [3:0]  succ;
    logic        aq;
    logic        rl;
    rm_t         rm;
    logic [31:0] uimm;
    logic [11:0] csr;
  } decoded_inst_t;  //}}}

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  local bit [7:0] mem[longint];
  local bit [63:0] pc;
  local bit core_active;
  local bit [XLEN/8-1:0][7:0] int_reg[32];

  rand func_t disassembled_instruction;
  bit [31:0] inst;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  function automatic void load_hex(input string file, input bit print = 0);  //{{{
    if (SOFT_MEM) begin
      bit [7:0] localmem[int];
      mem.delete();
      localmem.delete();
      $readmemh(file, localmem);
      foreach (localmem[i]) mem[i] = localmem[i];
      if (print) begin
        bit [3:0][7:0] mem2[longint];
        mem2.delete();
        foreach (mem[i]) begin
          bit [63:0] word_addr;
          bit [ 1:0] offset;
          word_addr = i;
          offset = i;
          word_addr[0] = 0;
          word_addr[1] = 0;
          mem2[word_addr][offset] = mem[i];
        end
        $display("\033[0;33mLOADED %s\033[0m", file);
        foreach (mem2[i]) begin
          $display("MEM[0x%h]:0x%h", i, mem2[i]);
        end
      end
    end else begin
      $display("\033[6;31mHARDWARE LOADING NOT ALLOWED FROM CORE\033[0m", file);
    end
  endfunction  //}}}

  task automatic read_inst(input bit [63:0] addr, output bit [3:0][7:0] data);  //{{{
    if (SOFT_MEM) begin
      foreach (data[i]) begin
        data[i] = mem[addr+i];
      end
    end
  endtask  //}}}

  task automatic int_read_mem(input bit [63:0] addr, output bit [XLEN/8-1:0][7:0] data);  //{{{
    if (SOFT_MEM) begin
      foreach (data[i]) begin
        data[i] = mem[addr+i];
      end
    end
  endtask  //}}}

  task automatic int_write_mem(input bit [63:0] addr, input bit [XLEN/8-1:0][7:0] data,  //{{{
                               input bit [XLEN/8-1:0] strb);
    if (SOFT_MEM) begin
      foreach (data[i]) begin
        if (strb[i]) begin
          mem[addr+i] = data[i];
        end
      end
    end
  endtask  //}}}

  function automatic bit [63:0] get_pc();  //{{{
    return pc;
  endfunction  //}}}

  function automatic void set_pc(input bit [63:0] addr);  //{{{
    pc = addr;
  endfunction  //}}}

  function automatic bit signed [XLEN-1:0] sign_ext(input bit [XLEN-1:0] data,  //{{{
                                                    input int len);
    sign_ext = data;
    for (int i = len; i < XLEN; i++) begin
      sign_ext[i] = data[len-1];
    end
  endfunction  //}}}

  function automatic bit [XLEN-1:0] read_int_reg(input bit [4:0] reg_id);  //{{{
    return int_reg[reg_id];
  endfunction  //}}}

  function automatic void write_int_reg(input bit [4:0] reg_id, input bit [XLEN-1:0] data);  //{{{
    if (reg_id != 0) begin
      int_reg[reg_id] = data;
    end
  endfunction  //}}}

  function automatic string int_reg_to_string();  //{{{
    string txt;
    $sformat(txt, "\033[0;33mINTEGER REG FILE[%0t]:\033[0m", $realtime);
    for (int i = 0; i < 8; i++) begin
      $sformat(txt, "%s\n%2d:0x%h", txt, i + 00, read_int_reg(i + 00));
      $sformat(txt, "%s  %2d:0x%h", txt, i + 08, read_int_reg(i + 08));
      $sformat(txt, "%s  %2d:0x%h", txt, i + 16, read_int_reg(i + 16));
      $sformat(txt, "%s  %2d:0x%h", txt, i + 24, read_int_reg(i + 24));
    end
    return txt;
  endfunction  //}}}

  function bit [31:0] encode_32();  //{{{
    inst = '0;
    case (disassembled_instruction.func)
      ADD: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000000;
      end  //}}}
      ADDI: begin  //{{{
        inst[06:00] = 7'b0010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm[11:0];
      end  //}}}
      ADDIW: begin  //{{{
        inst[06:00] = 7'b0011011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm[11:0];
      end  //}}}
      ADDW: begin  //{{{
        inst[06:00] = 7'b0111011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000000;
      end  //}}}
      AMOADD_D: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b00000;
      end  //}}}
      AMOADD_W: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b00000;
      end  //}}}
      AMOAND_D: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b01100;
      end  //}}}
      AMOAND_W: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b01100;
      end  //}}}
      AMOMAX_D: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b10100;
      end  //}}}
      AMOMAX_W: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b10100;
      end  //}}}
      AMOMAXU_D: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b11100;
      end  //}}}
      AMOMAXU_W: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b11100;
      end  //}}}
      AMOMIN_D: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b10000;
      end  //}}}
      AMOMIN_W: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b10000;
      end  //}}}
      AMOMINU_D: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b11000;
      end  //}}}
      AMOMINU_W: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b11000;
      end  //}}}
      AMOOR_D: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b01000;
      end  //}}}
      AMOOR_W: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b01000;
      end  //}}}
      AMOSWAP_D: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b00001;
      end  //}}}
      AMOSWAP_W: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b00001;
      end  //}}}
      AMOXOR_D: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b00100;
      end  //}}}
      AMOXOR_W: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25] = disassembled_instruction.rl;
        inst[26] = disassembled_instruction.aq;
        inst[31:27] = 5'b00100;
      end  //}}}
      AND: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b111;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000000;
      end  //}}}
      ANDI: begin  //{{{
        inst[06:00] = 7'b0010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b111;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm[11:0];
      end  //}}}
      AUIPC: begin  //{{{
        inst[06:00] = 7'b0010111;
        inst[11:07] = disassembled_instruction.rd;
        inst[31:12] = disassembled_instruction.imm;
      end  //}}}
      BEQ: begin  //{{{
        inst[06:00] = 7'b1100011;
        inst[07] = disassembled_instruction.imm[11];
        inst[11:08] = disassembled_instruction.imm[4:1];
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[30:25] = disassembled_instruction.imm[10:0];
        inst[31] = disassembled_instruction.imm[12];
      end  //}}}
      BGE: begin  //{{{
        inst[06:00] = 7'b1100011;
        inst[07] = disassembled_instruction.imm[11];
        inst[11:08] = disassembled_instruction.imm[4:1];
        inst[14:12] = 3'b101;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[30:25] = disassembled_instruction.imm[10:0];
        inst[31] = disassembled_instruction.imm[12];
      end  //}}}
      BGEU: begin  //{{{
        inst[06:00] = 7'b1100011;
        inst[07] = disassembled_instruction.imm[11];
        inst[11:08] = disassembled_instruction.imm[4:1];
        inst[14:12] = 3'b111;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[30:25] = disassembled_instruction.imm[10:0];
        inst[31] = disassembled_instruction.imm[12];
      end  //}}}
      BLT: begin  //{{{
        inst[06:00] = 7'b1100011;
        inst[07] = disassembled_instruction.imm[11];
        inst[11:08] = disassembled_instruction.imm[4:1];
        inst[14:12] = 3'b100;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[30:25] = disassembled_instruction.imm[10:0];
        inst[31] = disassembled_instruction.imm[12];
      end  //}}}
      BLTU: begin  //{{{
        inst[06:00] = 7'b1100011;
        inst[07] = disassembled_instruction.imm[11];
        inst[11:08] = disassembled_instruction.imm[4:1];
        inst[14:12] = 3'b110;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[30:25] = disassembled_instruction.imm[10:0];
        inst[31] = disassembled_instruction.imm[12];
      end  //}}}
      BNE: begin  //{{{
        inst[06:00] = 7'b1100011;
        inst[07] = disassembled_instruction.imm[11];
        inst[11:08] = disassembled_instruction.imm[4:1];
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[30:25] = disassembled_instruction.imm[10:0];
        inst[31] = disassembled_instruction.imm[12];
      end  //}}}
      CSRRC: begin  //{{{
        inst[06:00] = 7'b1110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.csr;
      end  //}}}
      CSRRCI: begin  //{{{
        inst[06:00] = 7'b1110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b111;
        inst[19:15] = disassembled_instruction.uimm;
        inst[31:20] = disassembled_instruction.csr;
      end  //}}}
      CSRRS: begin  //{{{
        inst[06:00] = 7'b1110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.csr;
      end  //}}}
      CSRRSI: begin  //{{{
        inst[06:00] = 7'b1110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b110;
        inst[19:15] = disassembled_instruction.uimm;
        inst[31:20] = disassembled_instruction.csr;
      end  //}}}
      CSRRW: begin  //{{{
        inst[06:00] = 7'b1110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.csr;
      end  //}}}
      CSRRWI: begin  //{{{
        inst[06:00] = 7'b1110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b101;
        inst[19:15] = disassembled_instruction.uimm;
        inst[31:20] = disassembled_instruction.csr;
      end  //}}}
      DIV: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b100;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000001;
      end  //}}}
      DIVU: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b101;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000001;
      end  //}}}
      DIVUW: begin  //{{{
        inst[06:00] = 7'b0111011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b101;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000001;
      end  //}}}
      DIVW: begin  //{{{
        inst[06:00] = 7'b0111011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b100;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000001;
      end  //}}}
      EBREAK: begin  //{{{
        inst[06:00] = 7'b1110011;
        inst[20]    = 1'b1;
      end  //}}}
      ECALL: begin  //{{{
        inst[06:00] = 7'b1110011;
      end  //}}}
      FADD_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000000;
      end  //}}}
      FADD_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000011;
      end  //}}}
      FADD_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000000;
      end  //}}}
      FCLASS_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b1110001;
      end  //}}}
      FCLASS_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b1110011;
      end  //}}}
      FCLASS_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b1110000;
      end  //}}}
      FCVT_D_L: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00010;
        inst[31:25] = 7'b1101001;
      end  //}}}
      FCVT_D_LU: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00011;
        inst[31:25] = 7'b1101001;
      end  //}}}
      FCVT_D_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00011;
        inst[31:25] = 7'b0100000;
      end  //}}}
      FCVT_D_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b0100001;
      end  //}}}
      FCVT_D_W: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b1101001;
      end  //}}}
      FCVT_D_WU: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00001;
        inst[31:25] = 7'b1101001;
      end  //}}}
      FCVT_L_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00010;
        inst[31:25] = 7'b1100001;
      end  //}}}
      FCVT_L_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00010;
        inst[31:25] = 7'b1100011;
      end  //}}}
      FCVT_L_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00010;
        inst[31:25] = 7'b1100000;
      end  //}}}
      FCVT_LU_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00011;
        inst[31:25] = 7'b1100001;
      end  //}}}
      FCVT_LU_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00011;
        inst[31:25] = 7'b1100011;
      end  //}}}
      FCVT_LU_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00011;
        inst[31:25] = 7'b1100000;
      end  //}}}
      FCVT_Q_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00001;
        inst[31:25] = 7'b0100011;
      end  //}}}
      FCVT_Q_L: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00010;
        inst[31:25] = 7'b1101011;
      end  //}}}
      FCVT_Q_LU: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00011;
        inst[31:25] = 7'b1101011;
      end  //}}}
      FCVT_Q_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b0100011;
      end  //}}}
      FCVT_Q_W: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b01101011;
      end  //}}}
      FCVT_Q_WU: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00001;
        inst[31:25] = 7'b01101011;
      end  //}}}
      FCVT_S_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00001;
        inst[31:25] = 7'b0100000;
      end  //}}}
      FCVT_S_L: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00010;
        inst[31:25] = 7'b1101000;
      end  //}}}
      FCVT_S_LU: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00011;
        inst[31:25] = 7'b1101000;
      end  //}}}
      FCVT_S_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00011;
        inst[31:25] = 7'b0100000;
      end  //}}}
      FCVT_S_W: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b1101000;
      end  //}}}
      FCVT_S_WU: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00001;
        inst[31:25] = 7'b1101000;
      end  //}}}
      FCVT_W_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b1100001;
      end  //}}}
      FCVT_W_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b1100011;
      end  //}}}
      FCVT_W_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b1100000;
      end  //}}}
      FCVT_WU_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00001;
        inst[31:25] = 7'b1100001;
      end  //}}}
      FCVT_WU_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00001;
        inst[31:25] = 7'b1100011;
      end  //}}}
      FCVT_WU_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00001;
        inst[31:25] = 7'b1100000;
      end  //}}}
      FDIV_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0001101;
      end  //}}}
      FDIV_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0001111;
      end  //}}}
      FDIV_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0001100;
      end  //}}}
      FENCE_I: begin  //{{{
        inst[06:00] = 7'b0001111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm;
      end  //}}}
      FENCE: begin  //{{{
        inst[06:00] = 7'b0001111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[23:20] = disassembled_instruction.succ;
        inst[27:24] = disassembled_instruction.pred;
        inst[31:28] = disassembled_instruction.fm;
      end  //}}}
      FEQ_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b1010001;
      end  //}}}
      FEQ_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b1010011;
      end  //}}}
      FEQ_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b1010000;
      end  //}}}
      FLD: begin  //{{{
        inst[06:00] = 7'b0000111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm[11:0];
      end  //}}}
      FLE_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b1010001;
      end  //}}}
      FLE_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b1010011;
      end  //}}}
      FLE_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b1010000;
      end  //}}}
      FLQ: begin  //{{{
        inst[06:00] = 7'b0000111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b100;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm[11:0];
      end  //}}}
      FLT_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b1010001;
      end  //}}}
      FLT_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b1010011;
      end  //}}}
      FLT_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b1010000;
      end  //}}}
      FLW: begin  //{{{
        inst[06:00] = 7'b0000111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm[11:0];
      end  //}}}
      FMADD_D: begin  //{{{
        inst[06:00] = 7'b1000011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[26:25] = 2'b01;
        inst[31:27] = disassembled_instruction.rs3;
      end  //}}}
      FMADD_Q: begin  //{{{
        inst[06:00] = 7'b1000011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[26:25] = 2'b11;
        inst[31:27] = disassembled_instruction.rs3;
      end  //}}}
      FMADD_S: begin  //{{{
        inst[06:00] = 7'b1000011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[26:25] = 2'b00;
        inst[31:27] = disassembled_instruction.rs3;
      end  //}}}
      FMAX_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0010101;
      end  //}}}
      FMAX_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0010111;
      end  //}}}
      FMAX_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0010100;
      end  //}}}
      FMIN_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0010111;
      end  //}}}
      FMIN_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0010101;
      end  //}}}
      FMIN_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0010100;
      end  //}}}
      FMSUB_D: begin  //{{{
        inst[06:00] = 7'b1000111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[26:25] = 2'b01;
        inst[31:27] = disassembled_instruction.rs3;
      end  //}}}
      FMSUB_Q: begin  //{{{
        inst[06:00] = 7'b1000111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[26:25] = 2'b11;
        inst[31:27] = disassembled_instruction.rs3;
      end  //}}}
      FMSUB_S: begin  //{{{
        inst[06:00] = 7'b1000111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[26:25] = 2'b00;
        inst[31:27] = disassembled_instruction.rs3;
      end  //}}}
      FMUL_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0001001;
      end  //}}}
      FMUL_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0001011;
      end  //}}}
      FMUL_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0001000;
      end  //}}}
      FMV_D_X: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b1111001;
      end  //}}}
      FMV_W_X: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b1111000;
      end  //}}}
      FMV_X_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b1110001;
      end  //}}}
      FMV_X_W: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b1110000;
      end  //}}}
      FNMADD_D: begin  //{{{
        inst[06:00] = 7'b1001111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[26:25] = 2'b01;
        inst[31:27] = disassembled_instruction.rs3;
      end  //}}}
      FNMADD_Q: begin  //{{{
        inst[06:00] = 7'b1001111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[26:25] = 2'b11;
        inst[31:27] = disassembled_instruction.rs3;
      end  //}}}
      FNMADD_S: begin  //{{{
        inst[06:00] = 7'b1001111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[26:25] = 2'b00;
        inst[31:27] = disassembled_instruction.rs3;
      end  //}}}
      FNMSUB_D: begin  //{{{
        inst[06:00] = 7'b1001011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[26:25] = 2'b01;
        inst[31:27] = disassembled_instruction.rs3;
      end  //}}}
      FNMSUB_Q: begin  //{{{
        inst[06:00] = 7'b1001011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[26:25] = 2'b11;
        inst[31:27] = disassembled_instruction.rs3;
      end  //}}}
      FNMSUB_S: begin  //{{{
        inst[06:00] = 7'b1001011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[26:25] = 2'b00;
        inst[31:27] = disassembled_instruction.rs3;
      end  //}}}
      FSD: begin  //{{{
        inst[06:00] = 7'b0100111;
        inst[11:07] = disassembled_instruction.imm[4:0];
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = disassembled_instruction.imm[11:5];
      end  //}}}
      FSGNJ_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0010001;
      end  //}}}
      FSGNJ_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0010011;
      end  //}}}
      FSGNJ_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0010000;
      end  //}}}
      FSGNJN_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0010001;
      end  //}}}
      FSGNJN_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0010011;
      end  //}}}
      FSGNJN_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0010000;
      end  //}}}
      FSGNJX_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0010001;
      end  //}}}
      FSGNJX_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0010011;
      end  //}}}
      FSGNJX_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0010000;
      end  //}}}
      FSQ: begin  //{{{
        inst[06:00] = 7'b0100111;
        inst[11:07] = disassembled_instruction.imm[4:0];
        inst[14:12] = 3'b100;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = disassembled_instruction.imm[11:5];
      end  //}}}
      FSQRT_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b0101101;
      end  //}}}
      FSQRT_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b0101111;
      end  //}}}
      FSQRT_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = 5'b00000;
        inst[31:25] = 7'b0101100;
      end  //}}}
      FSUB_D: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000101;
      end  //}}}
      FSUB_Q: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000111;
      end  //}}}
      FSUB_S: begin  //{{{
        inst[06:00] = 7'b1010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = disassembled_instruction.rm;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000100;
      end  //}}}
      FSW: begin  //{{{
        inst[06:00] = 7'b0100011;
        inst[11:07] = disassembled_instruction.imm[4:0];
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = disassembled_instruction.imm[11:5];
      end  //}}}
      JAL: begin  //{{{
        inst[06:00] = 7'b1101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[19:12] = disassembled_instruction.imm[19:12];
        inst[20]    = disassembled_instruction.imm[11];
        inst[30:21] = disassembled_instruction.imm[10:1];
        inst[31]    = disassembled_instruction.imm[20];
      end  //}}}
      JALR: begin  //{{{
        inst[06:00] = 7'b1100111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm;
      end  //}}}
      LB: begin  //{{{
        inst[06:00] = 7'b0000011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm;
      end  //}}}
      LBU: begin  //{{{
        inst[06:00] = 7'b0000011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b100;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm;
      end  //}}}
      LD: begin  //{{{
        inst[06:00] = 7'b0000011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm;
      end  //}}}
      LH: begin  //{{{
        inst[06:00] = 7'b0000011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm;
      end  //}}}
      LHU: begin  //{{{
        inst[06:00] = 7'b0000011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm;
      end  //}}}
      LR_D: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = '0;
        inst[25]    = disassembled_instruction.rl;
        inst[26]    = disassembled_instruction.aq;
        inst[31:27] = 5'b00010;
      end  //}}}
      LR_W: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = '0;
        inst[25]    = disassembled_instruction.rl;
        inst[26]    = disassembled_instruction.aq;
        inst[31:27] = 5'b00010;
      end  //}}}
      LUI: begin  //{{{
        inst[06:00] = 7'b0110111;
        inst[11:07] = disassembled_instruction.rd;
        inst[31:12] = disassembled_instruction.imm;
      end  //}}}
      LW: begin  //{{{
        inst[06:00] = 7'b0000011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm;
      end  //}}}
      LWU: begin  //{{{
        inst[06:00] = 7'b0000011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b110;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm;
      end  //}}}
      MUL: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000001;
      end  //}}}
      MULH: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000001;
      end  //}}}
      MULHSU: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000001;
      end  //}}}
      MULHU: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000001;
      end  //}}}
      MULW: begin  //{{{
        inst[06:00] = 7'b0111011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000001;
      end  //}}}
      OR: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b110;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000000;
      end  //}}}
      ORI: begin  //{{{
        inst[06:00] = 7'b0010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b110;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm[11:0];
      end  //}}}
      REM: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b110;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000001;
      end  //}}}
      REMU: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b111;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000001;
      end  //}}}
      REMUW: begin  //{{{
        inst[06:00] = 7'b0111011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b111;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000001;
      end  //}}}
      REMW: begin  //{{{
        inst[06:00] = 7'b0111011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b110;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000001;
      end  //}}}
      SB: begin  //{{{
        inst[06:00] = 7'b0100011;
        inst[11:07] = disassembled_instruction.imm[4:0];
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs1;
        inst[31:25] = disassembled_instruction.imm[11:5];
      end  //}}}
      SC_D: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25]    = disassembled_instruction.rl;
        inst[26]    = disassembled_instruction.aq;
        inst[31:27] = 5'b00011;
      end  //}}}
      SC_W: begin  //{{{
        inst[06:00] = 7'b0101111;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[25]    = disassembled_instruction.rl;
        inst[26]    = disassembled_instruction.aq;
        inst[31:27] = 5'b00011;
      end  //}}}
      SD: begin  //{{{
        inst[06:00] = 7'b0100011;
        inst[11:07] = disassembled_instruction.imm[4:0];
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = disassembled_instruction.imm[11:5];
      end  //}}}
      SH: begin  //{{{
        inst[06:00] = 7'b0100011;
        inst[11:07] = disassembled_instruction.imm[4:0];
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = disassembled_instruction.imm[11:5];
      end  //}}}
      SLL: begin  //{{{
        inst[06:00] = 7'b0010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000000;
      end  //}}}
      SLLI: begin  //{{{
        inst[06:00] = 7'b0010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.shamt;
        inst[31:25] = 7'b0000000;
      end  //}}}
      SLLIW: begin  //{{{
        inst[06:00] = 7'b0011011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.shamt;
        inst[31:25] = 7'b0000000;
      end  //}}}
      SLLW: begin  //{{{
        inst[06:00] = 7'b0111011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b001;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000000;
      end  //}}}
      SLT: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000000;
      end  //}}}
      SLTI: begin  //{{{
        inst[06:00] = 7'b0010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm[11:0];
      end  //}}}
      SLTIU: begin  //{{{
        inst[06:00] = 7'b0010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm[11:0];
      end  //}}}
      SLTU: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b011;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000000;
      end  //}}}
      SRA: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b101;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0100000;
      end  //}}}
      SRAI: begin  //{{{
        inst[06:00] = 7'b0010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b101;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.shamt;
        inst[31:25] = 7'b0100000;
      end  //}}}
      SRAIW: begin  //{{{
        inst[06:00] = 7'b0011011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b101;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.shamt;
        inst[31:25] = 7'b0100000;
      end  //}}}
      SRAW: begin  //{{{
        inst[06:00] = 7'b0111011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b101;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0100000;
      end  //}}}
      SRL: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b101;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000000;
      end  //}}}
      SRLI: begin  //{{{
        inst[06:00] = 7'b0010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b101;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.shamt;
        inst[31:25] = 7'b0000000;
      end  //}}}
      SRLIW: begin  //{{{
        inst[06:00] = 7'b0011011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b101;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.shamt;
        inst[31:25] = 7'b0000000;
      end  //}}}
      SRLW: begin  //{{{
        inst[06:00] = 7'b0111011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b101;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000000;
      end  //}}}
      SUB: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0100000;
      end  //}}}
      SUBW: begin  //{{{
        inst[06:00] = 7'b0111011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b000;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0100000;
      end  //}}}
      SW: begin  //{{{
        inst[06:00] = 7'b0100011;
        inst[11:07] = disassembled_instruction.imm[4:0];
        inst[14:12] = 3'b010;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs1;
        inst[31:25] = disassembled_instruction.imm[11:5];
      end  //}}}
      XOR: begin  //{{{
        inst[06:00] = 7'b0110011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b100;
        inst[19:15] = disassembled_instruction.rs1;
        inst[24:20] = disassembled_instruction.rs2;
        inst[31:25] = 7'b0000000;
      end  //}}}
      XORI: begin  //{{{
        inst[06:00] = 7'b0010011;
        inst[11:07] = disassembled_instruction.rd;
        inst[14:12] = 3'b100;
        inst[19:15] = disassembled_instruction.rs1;
        inst[31:20] = disassembled_instruction.imm[11:0];
      end  //}}}
      default: inst = '0;
    endcase
    return inst;
  endfunction  //}}}

  function automatic decoded_inst_t decode(input bit [31:0] instr);  //{{{

    decode = '0;

    case (instr[6:0])

      7'h03: begin  //{{{
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
      end  //}}}

      7'h07: begin  //{{{
        decode.rs1       = instr[19:15];
        decode.rd        = instr[11:7];
        decode.imm[11:0] = instr[31:20];
        case (instr[14:12])
          3'b010:  decode.func = FLW;
          3'b011:  decode.func = FLD;
          3'b100:  decode.func = FLQ;
          default: return '0;
        endcase
      end  //}}}

      7'h0F: begin  //{{{
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
      end  //}}}

      7'h13: begin  //{{{
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
            decode.shamt = instr[25:20];
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
      end  //}}}

      7'h17: begin  //{{{
        decode.rd        = instr[11:7];
        decode.imm[19:0] = instr[31:12];  // TODO VALIDATE
        decode.func      = AUIPC;
      end  //}}}

      7'h1B: begin  //{{{
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
      end  //}}}

      7'h23: begin  //{{{
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
      end  //}}}

      7'h27: begin  //{{{
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
      end  //}}}

      7'h2F: begin  //{{{
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
      end  //}}}

      7'h33: begin  //{{{
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
      end  //}}}

      7'h37: begin  //{{{
        decode.rd        = instr[11:7];
        decode.imm[19:0] = instr[31:12];  // TODO VALIDATE
        decode.func      = LUI;
      end  //}}}

      7'h3B: begin  //{{{
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
      end  //}}}

      7'h43: begin  //{{{
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
      end  //}}}

      7'h47: begin  //{{{
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
      end  //}}}

      7'h4B: begin  //{{{
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
      end  //}}}

      7'h4F: begin  //{{{
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
      end  //}}}

      7'h53: begin  //{{{
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
      end  //}}}

      7'h63: begin  //{{{
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
      end  //}}}

      7'h67: begin  //{{{
        case (instr[14:12])
          3'b000:  decode.func = JALR;
          default: return '0;
        endcase
        decode.rs1       = instr[19:15];
        decode.rd        = instr[11:7];
        decode.imm[11:0] = instr[14:12];
      end  //}}}

      7'h6F: begin  //{{{
        decode.rd         = instr[11:7];
        decode.imm[20]    = instr[31];
        decode.imm[10:1]  = instr[30:21];
        decode.imm[11]    = instr[20];
        decode.imm[19:12] = instr[19:12];
        decode.func       = JAL;
      end  //}}}

      7'h73: begin  //{{{
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
      end  //}}}

      default: return '0;

    endcase

  endfunction  //}}}

  // ------------------------------------------TODO------------------------------------------
  // AMOADD_D   AMOADD_W   AMOAND_D   AMOAND_W
  // AMOMAX_D   AMOMAX_W   AMOMAXU_D  AMOMAXU_W  AMOMIN_D   AMOMIN_W   AMOMINU_D  AMOMINU_W
  // AMOOR_D    AMOOR_W    AMOSWAP_D  AMOSWAP_W  AMOXOR_D   AMOXOR_W   CSRRC
  // CSRRCI     CSRRS      CSRRSI     CSRRW      CSRRWI     DIV        DIVU       DIVUW
  // DIVW       EBREAK     ECALL      FADD_D     FADD_Q     FADD_S     FCLASS_D   FCLASS_Q
  // FCLASS_S   FCVT_D_L   FCVT_D_LU  FCVT_D_Q   FCVT_D_S   FCVT_D_W   FCVT_D_WU  FCVT_L_D
  // FCVT_L_Q   FCVT_L_S   FCVT_LU_D  FCVT_LU_Q  FCVT_LU_S  FCVT_Q_D   FCVT_Q_L   FCVT_Q_LU
  // FCVT_Q_S   FCVT_Q_W   FCVT_Q_WU  FCVT_S_D   FCVT_S_L   FCVT_S_LU  FCVT_S_Q   FCVT_S_W
  // FCVT_S_WU  FCVT_W_D   FCVT_W_Q   FCVT_W_S   FCVT_WU_D  FCVT_WU_Q  FCVT_WU_S  FDIV_D
  // FDIV_Q     FDIV_S     FENCE_I    FENCE      FEQ_D      FEQ_Q      FEQ_S      FLD
  // FLE_D      FLE_Q      FLE_S      FLQ        FLT_D      FLT_Q      FLT_S      FLW
  // FMADD_D    FMADD_Q    FMADD_S    FMAX_D     FMAX_Q     FMAX_S     FMIN_D     FMIN_Q
  // FMIN_S     FMSUB_D    FMSUB_Q    FMSUB_S    FMUL_D     FMUL_Q     FMUL_S     FMV_D_X
  // FMV_W_X    FMV_X_D    FMV_X_W    FNMADD_D   FNMADD_Q   FNMADD_S   FNMSUB_D   FNMSUB_Q
  // FNMSUB_S   FSD        FSGNJ_D    FSGNJ_Q    FSGNJ_S    FSGNJN_D   FSGNJN_Q   FSGNJN_S
  // FSGNJX_D   FSGNJX_Q   FSGNJX_S   FSQ        FSQRT_D    FSQRT_Q    FSQRT_S    FSUB_D
  // FSUB_Q     FSUB_S     FSW        LR_D       LR_W       MUL
  // MULH       MULHSU     MULHU      MULW       REM        REMU
  // REMUW      REMW       SC_D       SC_W
  // ------------------------------------------TODO------------------------------------------
  task automatic execute(input bit [31:0] instr_word, input bit print = 0);  //{{{

    decoded_inst_t instr;
    bit execution_ok;

    execution_ok = 1;
    instr = decode(instr_word);

    if (print) $display("0x%h : %p", instr_word, instr);

    case (instr.func)

      ADD: begin  //{{{
        write_int_reg(instr.rd, read_int_reg(instr.rs1) + read_int_reg(instr.rs2));
      end  //}}}

      ADDI: begin  //{{{
        write_int_reg(instr.rd, (read_int_reg(instr.rs1) + sign_ext(instr.imm, 12)));
      end  //}}}

      ADDIW: begin  //{{{
        write_int_reg(instr.rd, sign_ext(read_int_reg(instr.rs1) + sign_ext(instr.imm, 12), 31));
      end  //}}}

      ADDW: begin  //{{{
        write_int_reg(instr.rd, sign_ext(read_int_reg(instr.rs1) + read_int_reg(instr.rs2), 31));
      end  //}}}

      AMOADD_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOADD_W: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOAND_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOAND_W: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOMAX_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOMAX_W: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOMAXU_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOMAXU_W: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOMIN_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOMIN_W: begin  //{{{<<
        execution_ok = 0;
      end  //}}}

      AMOMINU_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOMINU_W: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOOR_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOOR_W: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOSWAP_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOSWAP_W: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOXOR_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AMOXOR_W: begin  //{{{
        execution_ok = 0;
      end  //}}}

      AND: begin  //{{{
        write_int_reg(instr.rd, read_int_reg(instr.rs1) & read_int_reg(instr.rs2));
      end  //}}}

      ANDI: begin  //{{{
        write_int_reg(instr.rd, (read_int_reg(instr.rs1) & sign_ext(instr.imm, 12)));
      end  //}}}

      AUIPC: begin  //{{{
        write_int_reg(instr.rd, pc + (sign_ext(instr.imm, 20) << 12) - 4);
      end  //}}}

      BEQ: begin  //{{{
        if (read_int_reg(instr.rs1) == read_int_reg(instr.rs2)) begin
          pc = pc + sign_ext(instr.imm, 12) - 4;
        end
      end  //}}}

      BGE: begin  //{{{
        if (signed'(read_int_reg(instr.rs1)) >= signed'(read_int_reg(instr.rs2))) begin
          pc = pc + sign_ext(instr.imm, 12) - 4;
        end
      end  //}}}

      BGEU: begin  //{{{
        if (read_int_reg(instr.rs1) >= read_int_reg(instr.rs2)) begin
          pc = pc + sign_ext(instr.imm, 12) - 4;
        end
      end  //}}}

      BLT: begin  //{{{
        if (signed'(read_int_reg(instr.rs1)) < signed'(read_int_reg(instr.rs2))) begin
          pc = pc + sign_ext(instr.imm, 12) - 4;
        end
      end  //}}}

      BLTU: begin  //{{{
        if (read_int_reg(instr.rs1) < read_int_reg(instr.rs2)) begin
          pc = pc + sign_ext(instr.imm, 12 - 4);
        end
      end  //}}}

      BNE: begin  //{{{
        if (read_int_reg(instr.rs1) != read_int_reg(instr.rs2)) begin
          pc = pc + sign_ext(instr.imm, 12 - 4);
        end
      end  //}}}

      CSRRC: begin  //{{{
        execution_ok = 0;
      end  //}}}

      CSRRCI: begin  //{{{
        execution_ok = 0;
      end  //}}}

      CSRRS: begin  //{{{
        execution_ok = 0;
      end  //}}}

      CSRRSI: begin  //{{{
        execution_ok = 0;
      end  //}}}

      CSRRW: begin  //{{{
        execution_ok = 0;
      end  //}}}

      CSRRWI: begin  //{{{
        execution_ok = 0;
      end  //}}}

      DIV: begin  //{{{
        execution_ok = 0;
      end  //}}}

      DIVU: begin  //{{{
        execution_ok = 0;
      end  //}}}

      DIVUW: begin  //{{{
        execution_ok = 0;
      end  //}}}

      DIVW: begin  //{{{
        execution_ok = 0;
      end  //}}}

      EBREAK: begin  //{{{
        execution_ok = 0;
      end  //}}}

      ECALL: begin  //{{{
        case (read_int_reg(
            17
        ))

          1: $write("\033[1;36m%0d\033[0m", signed'(read_int_reg(10)));

          4: begin
            bit [63:0] addr;
            bit [XLEN/8-1:0][7:0] data;
            int data_avl;
            bit keep_going;
            string txt;
            txt = "";
            addr = read_int_reg(10);
            data_avl = 0;
            keep_going = 1;
            while (keep_going) begin
              if (data_avl == 0) begin
                int_read_mem(addr, data);
                addr = addr + 8;
                data_avl = 8;
              end

              if (data[0] == 0) begin
                keep_going = 0;
              end else begin
                $sformat(txt, "%s%s", txt, data[0]);
                data = data >> 8;
                data_avl--;
              end
            end
            $write("\033[1;36m%s\033[0m", txt);
          end

          10: begin
            $write("\033[1;33m\nPROGRAM EXIT CODE: 0\n\033[0m");
            core_active = 0;
          end

          11: $write("\033[1;36m%s\033[0m", byte'(read_int_reg(10)));

          93: begin
            $write("\033[1;33m\nPROGRAM EXIT CODE: %0d\n\033[0m", read_int_reg(10));
            core_active = 0;
          end

          default: begin
            $write("\033[1;33mSERVICE ROUTINE %0d NOT SUPPORTED\033[0m", read_int_reg(17));
          end

        endcase
      end  //}}}

      FADD_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FADD_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FADD_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCLASS_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCLASS_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCLASS_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_D_L: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_D_LU: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_D_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_D_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_D_W: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_D_WU: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_L_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_L_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_L_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_LU_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_LU_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_LU_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_Q_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_Q_L: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_Q_LU: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_Q_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_Q_W: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_Q_WU: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_S_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_S_L: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_S_LU: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_S_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_S_W: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_S_WU: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_W_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_W_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_W_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_WU_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_WU_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FCVT_WU_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FDIV_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FDIV_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FDIV_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FENCE_I: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FENCE: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FEQ_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FEQ_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FEQ_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FLD: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FLE_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FLE_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FLE_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FLQ: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FLT_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FLT_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FLT_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FLW: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMADD_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMADD_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMADD_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMAX_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMAX_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMAX_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMIN_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMIN_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMIN_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMSUB_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMSUB_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMSUB_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMUL_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMUL_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMUL_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMV_D_X: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMV_W_X: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMV_X_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FMV_X_W: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FNMADD_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FNMADD_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FNMADD_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FNMSUB_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FNMSUB_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FNMSUB_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSD: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSGNJ_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSGNJ_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSGNJ_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSGNJN_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSGNJN_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSGNJN_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSGNJX_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSGNJX_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSGNJX_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSQ: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSQRT_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSQRT_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSQRT_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSUB_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSUB_Q: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSUB_S: begin  //{{{
        execution_ok = 0;
      end  //}}}

      FSW: begin  //{{{
        execution_ok = 0;
      end  //}}}

      JAL: begin  //{{{
        write_int_reg(instr.rd, pc);
        pc = pc + sign_ext(instr.imm, 20) - 4;
      end  //}}}

      JALR: begin  //{{{
        write_int_reg(instr.rd, pc);
        pc = read_int_reg(instr.rs1) + sign_ext(instr.imm, 12);
        pc = pc >> 1;
        pc = pc << 1;
      end  //}}}

      LB: begin  //{{{
        bit [XLEN-1:0] mem_data;
        int_read_mem((read_int_reg(instr.rs1) + sign_ext(instr.imm, 12)), mem_data);
        mem_data = sign_ext(mem_data, 8);
        write_int_reg(instr.rd, mem_data);
      end  //}}}

      LBU: begin  //{{{
        bit [XLEN-1:0] mem_data;
        int_read_mem((read_int_reg(instr.rs1) + sign_ext(instr.imm, 12)), mem_data);
        mem_data = mem_data & 'hFF;
        write_int_reg(instr.rd, mem_data);
      end  //}}}

      LD: begin  //{{{
        bit [XLEN-1:0] mem_data;
        int_read_mem((read_int_reg(instr.rs1) + sign_ext(instr.imm, 12)), mem_data);
        mem_data = sign_ext(mem_data, 64);
        write_int_reg(instr.rd, mem_data);
      end  //}}}

      LH: begin  //{{{
        bit [XLEN-1:0] mem_data;
        int_read_mem((read_int_reg(instr.rs1) + sign_ext(instr.imm, 12)), mem_data);
        mem_data = sign_ext(mem_data, 16);
        write_int_reg(instr.rd, mem_data);
      end  //}}}

      LHU: begin  //{{{
        bit [XLEN-1:0] mem_data;
        int_read_mem((read_int_reg(instr.rs1) + sign_ext(instr.imm, 12)), mem_data);
        mem_data = mem_data & 'hFFFF;
        write_int_reg(instr.rd, mem_data);
      end  //}}}

      LR_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      LR_W: begin  //{{{
        execution_ok = 0;
      end  //}}}

      LUI: begin  //{{{
        write_int_reg(instr.rd, (sign_ext(instr.imm, 20) << 12));
      end  //}}}

      LW: begin  //{{{
        bit [XLEN-1:0] mem_data;
        int_read_mem((read_int_reg(instr.rs1) + sign_ext(instr.imm, 12)), mem_data);
        mem_data = sign_ext(mem_data, 32);
        write_int_reg(instr.rd, mem_data);
      end  //}}}

      LWU: begin  //{{{
        bit [XLEN-1:0] mem_data;
        int_read_mem((read_int_reg(instr.rs1) + sign_ext(instr.imm, 12)), mem_data);
        mem_data = mem_data & 'hFFFFFFFF;
        write_int_reg(instr.rd, mem_data);
      end  //}}}

      MUL: begin  //{{{
        execution_ok = 0;
      end  //}}}

      MULH: begin  //{{{
        execution_ok = 0;
      end  //}}}

      MULHSU: begin  //{{{
        execution_ok = 0;
      end  //}}}

      MULHU: begin  //{{{
        execution_ok = 0;
      end  //}}}

      MULW: begin  //{{{
        execution_ok = 0;
      end  //}}}

      OR: begin  //{{{
        write_int_reg(instr.rd, read_int_reg(instr.rs1) | read_int_reg(instr.rs2));
      end  //}}}

      ORI: begin  //{{{
        write_int_reg(instr.rd, (read_int_reg(instr.rs1) | sign_ext(instr.imm, 12)));
      end  //}}}

      REM: begin  //{{{
        execution_ok = 0;
      end  //}}}

      REMU: begin  //{{{
        execution_ok = 0;
      end  //}}}

      REMUW: begin  //{{{
        execution_ok = 0;
      end  //}}}

      REMW: begin  //{{{
        execution_ok = 0;
      end  //}}}

      SB: begin  //{{{
        int_write_mem(read_int_reg(instr.rs1) + sign_ext(instr.imm, 12), read_int_reg(instr.rs2),
                      'h1);
      end  //}}}

      SC_D: begin  //{{{
        execution_ok = 0;
      end  //}}}

      SC_W: begin  //{{{
        execution_ok = 0;
      end  //}}}

      SD: begin  //{{{
        int_write_mem(read_int_reg(instr.rs1) + sign_ext(instr.imm, 12), read_int_reg(instr.rs2),
                      'hFF);
      end  //}}}

      SH: begin  //{{{
        int_write_mem(read_int_reg(instr.rs1) + sign_ext(instr.imm, 12), read_int_reg(instr.rs2),
                      'h3);
      end  //}}}

      SLL: begin  //{{{
        write_int_reg(instr.rd, read_int_reg(instr.rs1) << read_int_reg(instr.rs2));
      end  //}}}

      SLLI: begin  //{{{
        write_int_reg(instr.rd, read_int_reg(instr.rs1) << instr.shamt);
      end  //}}}

      SLLIW: begin  //{{{
        write_int_reg(instr.rd, sign_ext((read_int_reg(instr.rs1) << instr.shamt), 32));
      end  //}}}

      SLLW: begin  //{{{
        write_int_reg(instr.rd, sign_ext(read_int_reg(instr.rs1) << read_int_reg(instr.rs2), 32));
      end  //}}}

      SLT: begin  //{{{
        write_int_reg(instr.rd, (signed'(read_int_reg(instr.rs1)) < signed'(read_int_reg(instr.rs2
                      ))));
      end  //}}}

      SLTI: begin  //{{{
        write_int_reg(instr.rd, (signed'(read_int_reg(instr.rs1)) < signed'(sign_ext(instr.imm, 12
                      ))));
      end  //}}}

      SLTIU: begin  //{{{
        write_int_reg(instr.rd, (read_int_reg(instr.rs1) < sign_ext(instr.imm, 12)));
      end  //}}}

      SLTU: begin  //{{{
        write_int_reg(instr.rd, (read_int_reg(instr.rs1) < read_int_reg(instr.rs2)));
      end  //}}}

      SRA: begin  //{{{
        write_int_reg(
            instr.rd, sign_ext(
            read_int_reg(instr.rs1) >> read_int_reg(instr.rs2), (XLEN - read_int_reg(instr.rs2))));
      end  //}}}

      SRAI: begin  //{{{
        write_int_reg(instr.rd, sign_ext(
                      read_int_reg(instr.rs1) >> instr.shamt, (XLEN - instr.shamt)));
      end  //}}}

      SRAIW: begin  //{{{
        write_int_reg(instr.rd, sign_ext(read_int_reg(instr.rs1) >> instr.shamt, 31));
      end  //}}}

      SRAW: begin  //{{{
        write_int_reg(instr.rd, sign_ext(read_int_reg(instr.rs1) >> read_int_reg(instr.rs2), 31));
      end  //}}}

      SRL: begin  //{{{
        write_int_reg(instr.rd, read_int_reg(instr.rs1) >> read_int_reg(instr.rs2));
      end  //}}}

      SRLI: begin  //{{{
        write_int_reg(instr.rd, read_int_reg(instr.rs1) >> instr.shamt);
      end  //}}}

      SRLIW: begin  //{{{
        write_int_reg(instr.rd, read_int_reg(instr.rs1) >> instr.shamt);
      end  //}}}

      SRLW: begin  //{{{
        write_int_reg(instr.rd, read_int_reg(instr.rs1) >> read_int_reg(instr.rs2));
      end  //}}}

      SUB: begin  //{{{
        write_int_reg(instr.rd, read_int_reg(instr.rs1) - read_int_reg(instr.rs2));
      end  //}}}

      SUBW: begin  //{{{
        write_int_reg(instr.rd, sign_ext(read_int_reg(instr.rs1) - read_int_reg(instr.rs2), 31));
      end  //}}}

      SW: begin  //{{{
        int_write_mem(read_int_reg(instr.rs1) + sign_ext(instr.imm, 12), read_int_reg(instr.rs2),
                      'hF);
      end  //}}}

      XOR: begin  //{{{
        write_int_reg(instr.rd, read_int_reg(instr.rs1) ^ read_int_reg(instr.rs2));
      end  //}}}

      XORI: begin  //{{{
        write_int_reg(instr.rd, (read_int_reg(instr.rs1) ^ sign_ext(instr.imm, 12)));
      end  //}}}

      default: execution_ok = 0;

    endcase

    if (!execution_ok) begin
      $display("\033[1;31m\n%m failed to execute 0x%h\n%p\n\033[0m", instr_word, instr);
    end

  endtask  //}}}

  task automatic step(input bit print = 0);  //{{{
    bit [31:0] instr;
    read_inst(pc, instr);
    if (instr == 0) begin
      core_active = 0;
      $display("\033[0;33mPC:0x%h INVALID INSTRUCTION 0x%h\033[0m", pc, instr);
    end else begin
      if (print) begin
        $display("PC:0x%h: 0x%h", pc, instr);
      end
      pc = pc + 4;
      execute(instr, print);
    end
  endtask  //}}}

  task automatic boot(input bit [63:0] addr, input bit print = 0);  //{{{
    pc = addr;
    core_active = 1;
    while (core_active) begin
      step();
    end
  endtask  //}}}

  function void post_randomization();  //{{{
    encode_32();
  endfunction  //}}}

  //}}}

endclass

////////////////////////////////////////////////////////////////////////////////////////////////////
//-NOTES{{{
////////////////////////////////////////////////////////////////////////////////////////////////////

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

//}}}
