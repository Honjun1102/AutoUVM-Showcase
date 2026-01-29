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
            agents/cpu_axi4_master_agent/*.sv \
            agents/sram_axi4_slave_agent/*.sv \
            agents/bridge_monitor_agent/*.sv \
            env/system_env.sv \
            scoreboard/fabric_scoreboard.sv \
            sequences/*.sv \
            tests/*.sv \
            tb_top.sv

# 目标
.PHONY: all compile sim clean coverage

all: compile sim

compile:
	@echo "=== Compiling RTL and UVM ==="
	$(VCS) $(VCS_OPTS) $(COV_OPTS) $(RTL_FILES) $(UVM_FILES)

sim:
	@echo "=== Running Test: $(TEST) ==="
	$(SIMV) $(SIM_OPTS) $(COV_OPTS)

coverage:
	@echo "=== Generating Coverage Report ==="
	$(URG) -dir simv.vdb -report coverage_report

clean:
	@echo "=== Cleaning up ==="
	rm -rf simv* csrc *.log *.key *.vpd DVEfiles coverage_report *.vdb

help:
	@echo "Available targets:"
	@echo "  make compile          - Compile RTL and UVM"
	@echo "  make sim TEST=<name>  - Run simulation"
	@echo "  make coverage         - Generate coverage report"
	@echo "  make clean            - Clean build files"
	@echo ""
	@echo "Available tests:"
	@echo "  concurrent_access_test   - 3 Masters concurrent access"
	@echo "  arbiter_priority_test    - Arbiter verification"
	@echo "  bridge_protocol_test     - Bridge conversion check"
	@echo ""
	@echo "Example:"
	@echo "  make sim TEST=concurrent_access_test VERB=UVM_HIGH"
