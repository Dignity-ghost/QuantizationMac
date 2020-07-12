


all: clean comp sim

comp:
	vcs -full64 -sverilog -cpp g++-4.4 -cc gcc-4.4 \
		+timescale=1ns/1ps \
		./tb_mac_ve5.sv ../rtl/mac_ve5.v

sim:
	./simv +UVM_TIMEOUT=100000000000

clean:
	rm -rf csrc simv.daidir simv ucli.key vc_hdrs.h