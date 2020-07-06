


all: clean comp sim

comp:
	vcs -full64 -sverilog -cpp g++-4.4 -cc gcc-4.4 -ntb_opts uvm \
		+timescale=1ns/1ps \
		top_tb.sv base_test.sv ./mac*.sv ../rtl/new_mac/mac.v

sim:
	./simv +UVM_TIMEOUT=100000000000

clean:
	rm -rf csrc simv.daidir simv ucli.key vc_hdrs.h