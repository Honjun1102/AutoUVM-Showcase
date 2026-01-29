# AutoUVM生成的Makefile

# 工具配置
VCS = vcs
SIMV = ./simv
URG = urg

# 编译选项
VCS_OPTS = -sverilog \
           -ntb_opts uvm-1.2 \
           -timescale=1ns/1ps \
           -full64 \
           -debug_access+all \
           -LDFLAGS -Wl,--no-as-needed \
           +vcs+flush+all \
           -l compile.log

# 仿真选项
SIM_OPTS = +UVM_TESTNAME=$(TEST) \
           +UVM_VERBOSITY=$(VERB) \
           -l sim_$(TEST).log

# 覆盖率选项
COV_OPTS = -cm line+cond+fsm+tgl+branch \
           -cm_dir simv.vdb

# 默认配置
TEST ?= concurrent_access_test
VERB ?= UVM_MEDIUM

# 源文件
RTL_FILES = ../rtl/axi4_crossbar_2x3.v \
            ../rtl/axi2apb_bridge.v \
            ../rtl/simple_sram_axi4.v \
            ../rtl/simple_timer_apb.v

UVM_FILES = interfaces/axi4_if.sv \
            interfaces/apb_if.sv \
            system_pkg.sv \
            tb_top.sv

# 目标
.PHONY: all compile sim clean coverage run_all help

all: compile sim

compile:
	@echo "=== Compiling RTL and UVM ==="
	$(VCS) $(VCS_OPTS) $(COV_OPTS) $(RTL_FILES) $(UVM_FILES)

sim:
	@echo "=== Running Test: $(TEST) ==="
	$(SIMV) $(SIM_OPTS) $(COV_OPTS)

# 运行所有测试
run_all: compile
	@echo "=== Running All Tests ==="
	@for test in concurrent_access_test stress_test outstanding_test \
	             arbiter_test address_decode_test random_traffic_test; do \
		echo ""; \
		echo "========================================"; \
		echo "Running: $$test"; \
		echo "========================================"; \
		$(SIMV) +UVM_TESTNAME=$$test +UVM_VERBOSITY=$(VERB) -l sim_$$test.log || true; \
	done
	@echo ""
	@echo "=== All Tests Completed ==="
	@echo "Check sim_*.log files for results"

coverage:
	@echo "=== Generating Coverage Report ==="
	$(URG) -dir simv.vdb -report coverage_report

clean:
	@echo "=== Cleaning up ==="
	rm -rf simv* csrc *.log *.key *.vpd DVEfiles coverage_report *.vdb

help:
	@echo "AutoUVM Bus Fabric Verification Environment"
	@echo ""
	@echo "Available targets:"
	@echo "  make compile          - Compile RTL and UVM"
	@echo "  make sim TEST=<name>  - Run specific test"
	@echo "  make run_all          - Run all 6 tests"
	@echo "  make coverage         - Generate coverage report"
	@echo "  make clean            - Clean build files"
	@echo ""
	@echo "Available tests (6):"
	@echo "  1. concurrent_access_test  - 3 Masters concurrent access"
	@echo "  2. stress_test             - High load stress test (200 trans per master)"
	@echo "  3. outstanding_test        - Outstanding transactions (8 outstanding)"
	@echo "  4. arbiter_test            - Arbiter fairness and priority"
	@echo "  5. address_decode_test     - Address decode verification"
	@echo "  6. random_traffic_test     - Random delay traffic patterns"
	@echo ""
	@echo "Available sequences (8):"
	@echo "  - cpu_random_seq         - Random CPU access"
	@echo "  - dma_burst_seq          - DMA burst transfers"
	@echo "  - debug_reg_seq          - Debug register access"
	@echo "  - stress_burst_seq       - Stress test bursts"
	@echo "  - back2back_seq          - Back-to-back no delay"
	@echo "  - random_delay_seq       - Random delays between trans"
	@echo "  - outstanding_seq        - Multiple outstanding"
	@echo "  - address_sweep_seq      - Address space sweep"
	@echo ""
	@echo "Examples:"
	@echo "  make sim TEST=stress_test VERB=UVM_HIGH"
	@echo "  make run_all VERB=UVM_LOW"
