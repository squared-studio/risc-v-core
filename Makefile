.PHONY: vivado
vivado: clean
	@xvlog -sv tb_func_decode.sv
	@xelab tb_func_decode -s tb
	@xsim tb -runall

.PHONY: clean
clean:
	@rm -rf *.log *.pb *.jou xsim.dir
