


all: clean comp sim

comp:
	vcs -full64 -sverilog -cpp g++-4.4 -cc gcc-4.4 -ntb_opts uvm\
		top_tb.sv base_test.sv ./mac*.sv dut.sv

sim:
	./simv

clean:
	rm -rf csrc simv.daidir simv ucli.key vc_hdrs.h