B
HEX = console_print.s.hex
HEX_FILE = $(shell find ./prebuilt_hex -name "*$(HEX)*")

INST_BASE = 0000000000000000
DATA_BASE = 0000000010000000

.PHONY: vivado
vivado: build simulate

.PHONY: simulate
simulate:
	@xsim top -runall -testplusarg \"HEX_FILE=$(HEX_FILE)\"

.PHONY: build
build: clean
	@xvlog -sv riscv_model.sv riscv_model_tb.sv
	@xelab riscv_model_tb -s top

.PHONY: clean
clean:
	@rm -rf *.log *.pb *.jou xsim.dir

.PHONY: update_hex_list
update_hex_list: temp_setup gen_hex collect_hex temp_remove

.PHONY: temp_setup
temp_setup:
	@rm -rf prebuilt_hex temp
	@mkdir prebuilt_hex
	@mkdir temp
	@cd temp; git clone https://github.com/squared-studio/RISC-V-TESTS.git

.PHONY: gen_hex
gen_hex:
	@cd temp/RISC-V-TESTS; make all INST_BASE=$(INST_BASE) DATA_BASE=$(DATA_BASE)

.PHONY: collect_hex
collect_hex:
	@$(foreach file, $(shell find temp/RISC-V-TESTS/build/ -name "*.hex"), cp $(file) prebuilt_hex/;)
	@echo "\`\`\`" > prebuilt_hex/README.md
	@echo "Instruction Section Base = 0x$(INST_BASE)" >> prebuilt_hex/README.md
	@echo "Data Section Base        = 0x$(DATA_BASE)" >> prebuilt_hex/README.md
	@echo "\`\`\`" >> prebuilt_hex/README.md

.PHONY: temp_remove
temp_remove:
	@rm -rf temp
