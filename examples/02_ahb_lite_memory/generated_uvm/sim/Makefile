# AHB-Lite Memory UVM Testbench Makefile

# VCS configuration
VCS = vcs
VCS_FLAGS = -full64 -sverilog -ntb_opts uvm-1.2 \
            -timescale=1ns/1ps \
            -debug_access+all \
            -lca \
            -kdb \
            +vcs+flush+all

# Directories
TB_DIR = ../tb
RTL_DIR = ../../rtl
CHECKER_DIR = ../checkers

# Source files
RTL_FILES = $(RTL_DIR)/ahb_lite_memory.v
TB_FILES = $(TB_DIR)/ahb_lite_if.sv \
           $(TB_DIR)/ahb_lite_transaction.sv \
           $(TB_DIR)/ahb_lite_driver.sv \
           $(TB_DIR)/ahb_lite_monitor.sv \
           $(TB_DIR)/ahb_lite_sequencer.sv \
           $(TB_DIR)/ahb_lite_agent.sv \
           $(TB_DIR)/ahb_lite_env.sv \
           $(TB_DIR)/ahb_lite_test.sv \
           $(TB_DIR)/tb_top.sv

CHECKER_FILES = $(CHECKER_DIR)/ahb_lite_checker.sv

# Targets
.PHONY: all compile run clean

all: compile run

compile:
	@echo "========================================="
	@echo "  Compiling AHB-Lite UVM Testbench"
	@echo "========================================="
	$(VCS) $(VCS_FLAGS) \
		$(RTL_FILES) \
		$(CHECKER_FILES) \
		$(TB_FILES) \
		-l compile.log
	@echo "Compilation complete!"

run:
	@echo "========================================="
	@echo "  Running simulation"
	@echo "========================================="
	./simv +UVM_TESTNAME=ahb_lite_test \
	       +UVM_VERBOSITY=UVM_LOW \
	       -l simv.log
	@echo ""
	@echo "Simulation complete! Check simv.log for results."

coverage:
	@echo "========================================="
	@echo "  Generating coverage report"
	@echo "========================================="
	urg -dir simv.vdb -format both
	@echo "Coverage report generated in urgReport/"

clean:
	@echo "Cleaning up..."
	rm -rf simv* csrc *.log DVEfiles *.vpd *.vdb urgReport *.key
	@echo "Clean complete!"

help:
	@echo "Available targets:"
	@echo "  make compile  - Compile the testbench"
	@echo "  make run      - Run simulation"
	@echo "  make coverage - Generate coverage report"
	@echo "  make all      - Compile and run"
	@echo "  make clean    - Remove generated files"
