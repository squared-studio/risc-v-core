// Author : Foez Ahmed (foez.official@gmail.com)
// This file is part of squared-studio:risc-v-core
// Copyright (c) 2024 squared-studio
// Licensed under the MIT License
// See LICENSE file in the project root for full license information

module riscv_model_tb;

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

  riscv_model model = new();

  `define EXE(__HEX__)                  \
    model.execute('h``__HEX__``, 1);    \

  localparam int XLEN = 64;

  initial begin

    string file;
    if (!$value$plusargs("HEX_FILE=%s", file)) $fatal(2,"hex file not found");
    model.load_hex(file);

    model.boot(0);

    //model.set_pc(0);
    //repeat (160) model.step(0);

    $display("%s", model.int_reg_to_string());

    $finish;

  end

endmodule
