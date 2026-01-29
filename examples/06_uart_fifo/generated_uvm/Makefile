# AutoUVM生成 - Makefile
VCS = vcs
SIMV = ./simv

VCS_OPTS = -sverilog -ntb_opts uvm-1.2 -timescale=1ns/1ps -full64 -l compile.log
SIM_OPTS = +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(VERB) -l sim.log

TEST ?= uart_fifo_test
VERB ?= UVM_MEDIUM

RTL_FILES = ../rtl/uart_tx_fifo.v ../rtl/uart_transmitter.v ../rtl/uart_tx_top.v
UVM_FILES = interfaces/axis_if.sv interfaces/uart_if.sv interfaces/fifo_status_if.sv \
            uart_pkg.sv tb_top.sv

all: compile sim

compile:
	$(VCS) $(VCS_OPTS) $(RTL_FILES) $(UVM_FILES)

sim:
	$(SIMV) $(SIM_OPTS)

clean:
	rm -rf simv* csrc *.log *.vpd DVEfiles

.PHONY: all compile sim clean
