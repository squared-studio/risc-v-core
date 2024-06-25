####################################################################################################
##
##    Author : Foez Ahmed (foez.official@gmail.com)
##
####################################################################################################

ROOT        = $(shell pwd)
TOP         = $(shell cat ___TOP)
RTL         = $(shell cat ___RTL)
TOP_DIR     = $(shell find $(realpath ./tb/) -wholename "*$(TOP)/$(TOP).sv" | sed "s/\/$(TOP).sv//g")
TBF_LIB     = $(shell find $(TOP_DIR) -name "*.v" -o -name "*.sv")
DES_LIB     = $(shell find $(realpath ./rtl/) -name "*.v" -o -name "*.sv")
INC_DIR     = $(realpath ./inc)
RTL_FILE    = $(shell find $(realpath ./rtl/) -name "$(RTL).sv")
CONFIG      = default
CONFIG_PATH = $(TOP_DIR)/config/$(CONFIG)

CLEAN_TARGETS += $(shell find $(realpath ./) -name "xsim.dir")
CLEAN_TARGETS += $(shell find $(realpath ./) -name ".Xil")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.out")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.vcd")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.log")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.wdb")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.jou")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.pb")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___temp")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___CI_REPORT_TEMP")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___list")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___flist")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_header")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_param")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_raw_param")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_port")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_raw_port")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_inst")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_raw_inst")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___TO_COPY")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.cache")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.hw")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.ip_user_files")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.sim")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.xpr")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.tcl")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.runs")

OS = $(shell uname)
ifeq ($(OS),Linux)
  CLIP = xclip -sel clip
	PYTHON = python3
else
	CLIP = clip
	PYTHON = python
endif

GIT_UNAME = $(shell git config user.name)
GIT_UMAIL = $(shell git config user.email)

CI_LIST  = $(shell cat CI_LIST)

MAKE = make --no-print-directory

ifeq ($(CFG),$(CONFIG)) 
	COLOR = \033[1;33m
else 
	COLOR = \033[1;37m
endif

####################################################################################################
# General
####################################################################################################

.PHONY: help
help:
	@echo -e ""
	@echo -e "\033[3;30mTo create or open a testbench, type:\033[0m"
	@echo -e "\033[1;38mmake create_tb TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo create or open a rtl, type:\033[0m"
	@echo -e "\033[1;38mmake create_rtl RTL=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo run a test with vivado, type:\033[0m"
	@echo -e "\033[1;38mmake simulate TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo clean all temps, type:\033[0m"
	@echo -e "\033[1;38mmake clean\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo open wavedump using gtkwave, type:\033[0m"
	@echo -e "\033[1;38mmake gwave TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo open wave using vivado, type:\033[0m"
	@echo -e "\033[1;38mmake vwave TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo run simulation on the initial block of an RTL, type:\033[0m"
	@echo -e "\033[1;38mmake rtl_init_sim RTL=<rtl>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo open schematic using vivado, type:\033[0m"
	@echo -e "\033[1;38mmake schematic RTL=<rtl>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo find any rtl, type:\033[0m"
	@echo -e "\033[1;38mmake find_rtl RTL=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo run CI check, type:\033[0m"
	@echo -e "\033[1;38mmake CI\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo generate flist of an RTL, type:\033[0m"
	@echo -e "\033[1;38mmake flist RTL=<rtl>\033[0m"
	@echo -e ""

.PHONY: clean
clean:
	@- echo -e "$(CLEAN_TARGETS)" | sed "s/  //g" | sed "s/ /\nremoving /g"
	@rm -rf $(CLEAN_TARGETS)

####################################################################################################
# FLIST (Vivado)
####################################################################################################

.PHONY: find_rtl
find_rtl:
	@find $(realpath ./rtl/) -iname "*$(RTL)*.sv"

.PHONY: list_modules
list_modules: clean
	@$(eval RTL_FILE := $(shell find rtl -name "$(RTL).sv"))
	@xvlog -i $(INC_DIR) -sv -L RTL=$(DES_LIB)
	@xelab $(RTL) -s top
	@cat xelab.log | grep -E "work" > ___list
	@sed -i "s/.*work\.//gi" ___list;
	@sed -i "s/(.*//gi" ___list;
	@sed -i "s/_default.*//gi" ___list;

.PHONY: locate_files
locate_files: list_modules
	@$(eval _TMP := )
	@$(foreach word,$(shell cat ___list), 		\
		$(if $(findstring $(word),$(_TMP)), 		\
			echo "", 															\
			$(eval _TMP += $(word))								\
				find -name "$(word).sv" >> ___flist	\
		);																			\
	)

.PHONY: flist
flist: locate_files
	@cat ___flist | $(CLIP)
	@$(MAKE) clean
	@echo -e "\033[2;35m$(RTL) flist copied to clipboard\033[0m"

####################################################################################################
# Schematic (Vivado)
####################################################################################################

.PHONY: schematic
schematic: locate_files
	@echo "$(RTL)" > ___RTL
	@echo "create_project top" > top.tcl
	@echo "set_property include_dirs ./inc [current_fileset]" >> top.tcl
	@$(foreach word, $(shell cat ___flist), echo "add_files $(word)" >> top.tcl;)
	@echo "set_property top $(RTL) [current_fileset]" >> top.tcl
	@echo "start_gui" >> top.tcl
	@echo "synth_design -top $(RTL) -lint" >> top.tcl
	@echo "synth_design -rtl -rtl_skip_mlo -name rtl_1" >> top.tcl
	@vivado -mode tcl -source top.tcl
	@$(MAKE) clean

####################################################################################################
# Simulate (Vivado)
####################################################################################################

.PHONY: config_touch
config_touch:
	@mkdir -p $(CONFIG_PATH)
	@touch $(CONFIG_PATH)/xvlog
	@touch $(CONFIG_PATH)/xelab
	@touch $(CONFIG_PATH)/xsim
	@touch $(CONFIG_PATH)/des

.PHONY: config_list
config_list: config_touch
	@echo ""
	@$(foreach cfg, $(shell ls -d $(TOP_DIR)/config/*/), \
		$(MAKE) config_print CFG=$(shell basename $(cfg));)

.PHONY: config_print
config_print:
	@echo -e "$(COLOR)$(CFG)\033[0m $(shell cat $(TOP_DIR)/config/$(CFG)/des)"
	@$(if $(shell cat  $(TOP_DIR)/config/$(CFG)/xvlog), echo -e "\033[0;36mxvlog:\033[0m $(shell cat $(TOP_DIR)/config/$(CFG)/xvlog)")
	@$(if $(shell cat  $(TOP_DIR)/config/$(CFG)/xelab), echo -e "\033[0;36mxelab:\033[0m $(shell cat $(TOP_DIR)/config/$(CFG)/xelab)")
	@$(if $(shell cat  $(TOP_DIR)/config/$(CFG)/xsim ), echo -e "\033[0;36mxsim :\033[0m $(shell cat $(TOP_DIR)/config/$(CFG)/xsim) ")
	@echo ""

.PHONY: simulate
simulate: clean
	@echo "$(TOP)" > ___TOP
	@$(MAKE) config_list
	$(MAKE) vivado TOP=$(TOP) CONFIG=$(CONFIG)

.PHONY: vivado
vivado:
	@$(MAKE) config_touch
	@cd $(TOP_DIR); xvlog \
		-f $(CONFIG_PATH)/xvlog \
		-d SIMULATION \
		--define CONFIG=\"$(CONFIG)\" \
		-i $(INC_DIR) \
		-sv -L UVM \
		-L TBF=$(TBF_LIB) \
		-L RTL=$(DES_LIB)
	@cd $(TOP_DIR); xelab \
		-f $(CONFIG_PATH)/xelab \
		$(TOP) -s top
	@cd $(TOP_DIR); xsim \
		top -f $(CONFIG_PATH)/xsim \
		-runall

.PHONY: rtl_init_sim
rtl_init_sim: clean
	@echo "$(RTL)" > ___RTL
	@xvlog -d SIMULATION -i $(INC_DIR) -sv -L RTL=$(DES_LIB) 
	@xelab $(RTL) -s top
	@xsim top -runall

####################################################################################################
# CI (Vivado)
####################################################################################################

.PHONY: CI
CI: clean ci_vivado_run ci_vivado_collect ci_print

include ci_run

.PHONY: ci_vivado_collect
ci_vivado_collect:
	@$(eval _TMP := $(shell find -name "*.log"))
	@$(foreach word,$(_TMP), cat $(word) >> ___CI_REPORT_TEMP;)
	@cat ___CI_REPORT_TEMP | grep -E "ERROR: |\[PASS\]|\[FAIL\]" >> ___CI_REPORT;

.PHONY: ci_print
ci_print:
	@$(eval _PASS := $(shell grep -c "1;32m\[PASS\]" ___CI_REPORT))
	@$(eval _FAIL := $(shell grep -c "1;31m\[FAIL\]" ___CI_REPORT))
	@if [ "$(_FAIL)" = "0" ]; then \
		echo -e "\033[1;32m" >> ___CI_REPORT;\
	else\
		echo -e "\033[1;31m" >> ___CI_REPORT;\
	fi
	@echo ">>>>>>>>>>>>>>>>>>>> $(_PASS)/$(shell expr $(_FAIL) + $(_PASS)) PASSED <<<<<<<<<<<<<<<<<<<<" >> ___CI_REPORT;
	@echo -e "\033[0m" >> ___CI_REPORT;
	@git log -1 >> ___CI_REPORT;
	@$(MAKE) clean
	@echo " "
	@echo " "
	@echo " "
	@echo -e "\033[1;32mCONTINUOUS INTEGRATION SUCCESSFULLY COMPLETE\033[0m";
	@cat ___CI_REPORT
	@grep -r "FAIL" ./___CI_REPORT | tee ___CI_ERROR

####################################################################################################
# Waveform (GTKWave)
####################################################################################################

.PHONY: rawVCD
rawVCD:
	@cd $(TOP_DIR); test -e dump.vcd && gtkwave dump.vcd || echo -e "\033[1;31mNo wave found\033[0m"

.PHONY: gwave
gwave:
	@cd $(TOP_DIR); test -e *.gtkw && gtkwave *.gtkw || cd $(ROOT); $(MAKE) rawVCD

####################################################################################################
# Waveform (Vivado)
####################################################################################################

.PHONY: vwave
vwave:
	@cd $(TOP_DIR); xsim top -f $(CONFIG_PATH)/xsim -gui

##################################################################################################
# Create TB
####################################################################################################

.PHONY: create_tb
create_tb:
	@echo "$(TOP)" > ___TOP
	@test -e ./tb/$(TOP)/$(TOP).sv || \
		(	\
			mkdir -p ./tb/$(TOP) && cat tb_model.sv	\
			  | sed "s/^module tb_model;$$/module $(TOP);/g" \
			  | sed "s/^Author :.*/Author : $(GIT_UNAME) ($(GIT_UMAIL))/g" \
				> ./tb/$(TOP)/$(TOP).sv \
		)
	@code ./tb/$(TOP)/$(TOP).sv

####################################################################################################
# Create RTL
####################################################################################################

.PHONY: create_rtl
create_rtl:
	@echo "$(RTL)" > ___RTL
	@test -e ./rtl/$(RTL).sv || \
		(	\
			cat rtl_model.sv	\
			  | sed "s/^module rtl_model #($$/module $(RTL) #(/g" \
			  | sed "s/^Author :.*/Author : $(GIT_UNAME) ($(GIT_UMAIL))/g" \
				> ./rtl/$(RTL).sv \
		)
	@code ./rtl/$(RTL).sv
