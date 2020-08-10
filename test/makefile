
CC=gcc  #去掉-4.4即可
CPP=g++
SEED=$(shell head -4 /dev/urandom | od -N 4 -D -A n |awk '{gsub(/ /,"")}1')
TIMEOUT=10000000000

all: clog comp sim

comp:
	vcs -full64 -sverilog -cpp $(CPP) -cc $(CC) \
		-timescale=1ns/1ps  -ntb_opts uvm \
		-f files.f -l mac_ve5_1intmode.comp.log \
		-cm line+tgl+cond

sim:
	./simv +UVM_TIMEOUT=$(TIMEOUT) +ntb_random_seed=${SEED} \
		-l mac_ve5_1intmode.sim.seed_$(SEED).log \
		-cm line+tgl+cond

clean:
	rm -rf csrc simv.daidir simv* ucli.key vc_hdrs.h

clog:
	rm -rf csrc simv.daidir simv* ucli.key vc_hdrs.h *.log

cpt:
	urg -full64 -dir simv.vdb -report both
