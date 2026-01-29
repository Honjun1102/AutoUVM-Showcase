#!/usr/bin/env python3
"""
AHB-Lite Memory验证环境生成脚本

使用AutoUVM v1.6生成完整的AHB-Lite UVM testbench
"""

import sys
import os
from pathlib import Path

# 添加AutoUVM到path
sys.path.insert(0, str(Path(__file__).parent.parent.parent))

from autouvm3.generators.checker_generator import CheckerGenerator

def create_ahb_lite_memory_project():
    """创建AHB-Lite Memory验证项目"""
    
    print("=" * 70)
    print("  AutoUVM v1.6 - AHB-Lite Memory验证环境生成")
    print("=" * 70)
    print()
    
    return {
        'name': 'ahb_lite_memory_uvm',
        'top_module': 'ahb_lite_memory',
        'addr_width': 16,
        'data_width': 32
    }


def generate_testbench(project_info, output_dir):
    """生成testbench文件"""
    
    print(f"\n📁 输出目录: {output_dir}")
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)
    
    # 创建目录结构
    (output_path / "tb").mkdir(exist_ok=True)
    (output_path / "sim").mkdir(exist_ok=True)
    (output_path / "checkers").mkdir(exist_ok=True)
    (output_path / "docs").mkdir(exist_ok=True)
    
    print("\n🔧 生成UVM组件...")
    
    # 1. 生成interface
    print("  ✓ Interface文件")
    if_file = output_path / "tb" / "ahb_lite_if.sv"
    if_content = generate_ahb_lite_interface()
    if_file.write_text(if_content)
    
    # 2. 生成transaction
    print("  ✓ Transaction类")
    trans_file = output_path / "tb" / "ahb_lite_transaction.sv"
    trans_content = generate_ahb_lite_transaction()
    trans_file.write_text(trans_content)
    
    # 3. 生成driver
    print("  ✓ Driver类")
    driver_file = output_path / "tb" / "ahb_lite_driver.sv"
    driver_content = generate_ahb_lite_driver()
    driver_file.write_text(driver_content)
    
    # 4. 生成monitor
    print("  ✓ Monitor类")
    monitor_file = output_path / "tb" / "ahb_lite_monitor.sv"
    monitor_content = generate_ahb_lite_monitor()
    monitor_file.write_text(monitor_content)
    
    # 5. 生成sequencer
    print("  ✓ Sequencer类")
    seq_file = output_path / "tb" / "ahb_lite_sequencer.sv"
    seq_content = generate_sequencer()
    seq_file.write_text(seq_content)
    
    # 6. 生成agent
    print("  ✓ Agent类")
    agent_file = output_path / "tb" / "ahb_lite_agent.sv"
    agent_content = generate_agent()
    agent_file.write_text(agent_content)
    
    # 7. 生成env
    print("  ✓ Environment类")
    env_file = output_path / "tb" / "ahb_lite_env.sv"
    env_content = generate_env()
    env_file.write_text(env_content)
    
    # 8. 生成test
    print("  ✓ Test类")
    test_file = output_path / "tb" / "ahb_lite_test.sv"
    test_content = generate_test()
    test_file.write_text(test_content)
    
    # 9. 生成tb_top
    print("  ✓ Testbench Top")
    tb_file = output_path / "tb" / "tb_top.sv"
    tb_content = generate_tb_top()
    tb_file.write_text(tb_content)
    
    # 10. 生成checker
    print("  ✓ Protocol Checker (20+ SVA)")
    checker_gen = CheckerGenerator()
    checker_file = output_path / "checkers" / "ahb_lite_checker.sv"
    checker_gen.generate_ahb_lite_checker(
        output_file=str(checker_file),
        addr_width=project_info['addr_width'],
        data_width=project_info['data_width'],
        timeout_cycles=2000
    )
    
    # 11. 生成Makefile
    print("  ✓ Makefile")
    makefile = output_path / "sim" / "Makefile"
    makefile_content = generate_makefile()
    makefile.write_text(makefile_content)
    
    # 12. 生成README
    print("  ✓ README")
    readme = output_path / "README.md"
    readme_content = generate_readme()
    readme.write_text(readme_content)
    
    print("\n✅ 生成完成！")
    print(f"\n生成的文件:")
    print(f"  • Interface: ahb_lite_if.sv")
    print(f"  • Transaction: ahb_lite_transaction.sv")
    print(f"  • Driver: ahb_lite_driver.sv")
    print(f"  • Monitor: ahb_lite_monitor.sv")
    print(f"  • Sequencer: ahb_lite_sequencer.sv")
    print(f"  • Agent: ahb_lite_agent.sv")
    print(f"  • Environment: ahb_lite_env.sv")
    print(f"  • Test: ahb_lite_test.sv")
    print(f"  • TB Top: tb_top.sv")
    print(f"  • Checker: ahb_lite_checker.sv (20+ SVA)")
    print(f"  • Makefile: sim/Makefile")
    print(f"  • README: README.md")
    print()
    print(f"📊 统计:")
    print(f"  • 总文件数: 12")
    print(f"  • 估计代码行数: ~3,500")
    print(f"  • SVA断言: 20+")


def generate_ahb_lite_interface():
    """生成AHB-Lite interface"""
    return '''//==============================================================================
// AHB-Lite Interface
//==============================================================================

interface ahb_lite_if(input logic HCLK, input logic HRESETn);
    
    // AHB-Lite Master signals
    logic [15:0]  HADDR;
    logic         HWRITE;
    logic [2:0]   HSIZE;
    logic [2:0]   HBURST;
    logic [1:0]   HTRANS;
    logic [31:0]  HWDATA;
    logic         HSEL;
    
    // AHB-Lite Slave signals
    logic [31:0]  HRDATA;
    logic         HREADY;
    logic         HRESP;
    
    // Modports
    modport master (
        input  HCLK, HRESETn, HRDATA, HREADY, HRESP,
        output HADDR, HWRITE, HSIZE, HBURST, HTRANS, HWDATA, HSEL
    );
    
    modport slave (
        input  HCLK, HRESETn, HADDR, HWRITE, HSIZE, HBURST, HTRANS, HWDATA, HSEL,
        output HRDATA, HREADY, HRESP
    );
    
    modport monitor (
        input HCLK, HRESETn, HADDR, HWRITE, HSIZE, HBURST, HTRANS, 
              HWDATA, HRDATA, HREADY, HRESP, HSEL
    );
    
endinterface
'''


def generate_ahb_lite_transaction():
    """生成transaction类"""
    return '''//==============================================================================
// AHB-Lite Transaction
//==============================================================================

class ahb_lite_transaction extends uvm_sequence_item;
    
    rand bit [15:0]  addr;
    rand bit [31:0]  data;
    rand bit         write;
    rand bit [2:0]   size;
    rand bit [2:0]   burst_type;
    rand bit [1:0]   trans_type;
    bit              resp;  // 0=OKAY, 1=ERROR
    
    `uvm_object_utils_begin(ahb_lite_transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(write, UVM_ALL_ON)
        `uvm_field_int(size, UVM_ALL_ON)
        `uvm_field_int(burst_type, UVM_ALL_ON)
        `uvm_field_int(trans_type, UVM_ALL_ON)
        `uvm_field_int(resp, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "ahb_lite_transaction");
        super.new(name);
    endfunction
    
    // Constraints
    constraint addr_align {
        if (size == 3'b001) addr[0] == 0;      // Halfword aligned
        if (size == 3'b010) addr[1:0] == 0;    // Word aligned
    }
    
    constraint valid_size {
        size inside {3'b000, 3'b001, 3'b010};  // Byte, halfword, word
    }
    
    constraint valid_burst {
        burst_type inside {3'b000, 3'b001, 3'b011, 3'b101, 3'b111};  // SINGLE, INCR, INCR4/8/16
    }
    
endclass
'''


def generate_ahb_lite_driver():
    """生成driver (简化版，实际应从protocol_behaviors导入)"""
    return '''//==============================================================================
// AHB-Lite Driver
//==============================================================================

class ahb_lite_driver extends uvm_driver #(ahb_lite_transaction);
    `uvm_component_utils(ahb_lite_driver)
    
    virtual ahb_lite_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual ahb_lite_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive_transaction(req);
            seq_item_port.item_done();
        end
    endtask
    
    task drive_transaction(ahb_lite_transaction trans);
        // Address phase
        @(posedge vif.HCLK);
        vif.HSEL   <= 1'b1;
        vif.HADDR  <= trans.addr;
        vif.HWRITE <= trans.write;
        vif.HSIZE  <= trans.size;
        vif.HBURST <= trans.burst_type;
        vif.HTRANS <= 2'b10;  // NONSEQ
        
        // Data phase
        @(posedge vif.HCLK);
        if (trans.write) begin
            vif.HWDATA <= trans.data;
        end
        
        // Wait for HREADY
        wait(vif.HREADY);
        @(posedge vif.HCLK);
        
        // Capture response
        trans.resp = vif.HRESP;
        if (!trans.write) begin
            trans.data = vif.HRDATA;
        end
        
        // Return to IDLE
        vif.HTRANS <= 2'b00;  // IDLE
        vif.HSEL   <= 1'b0;
    endtask
    
endclass
'''


def generate_ahb_lite_monitor():
    """生成monitor (简化版)"""
    return '''//==============================================================================
// AHB-Lite Monitor
//==============================================================================

class ahb_lite_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_lite_monitor)
    
    virtual ahb_lite_if vif;
    uvm_analysis_port #(ahb_lite_transaction) analysis_port;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual ahb_lite_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found")
    endfunction
    
    task run_phase(uvm_phase phase);
        ahb_lite_transaction trans;
        forever begin
            @(posedge vif.HCLK);
            if (vif.HSEL && vif.HTRANS inside {2'b10, 2'b11}) begin
                trans = ahb_lite_transaction::type_id::create("trans");
                // Capture address phase
                trans.addr = vif.HADDR;
                trans.write = vif.HWRITE;
                trans.size = vif.HSIZE;
                trans.burst_type = vif.HBURST;
                trans.trans_type = vif.HTRANS;
                
                // Wait for data phase
                @(posedge vif.HCLK);
                wait(vif.HREADY);
                
                // Capture data phase
                if (trans.write) begin
                    trans.data = vif.HWDATA;
                end else begin
                    trans.data = vif.HRDATA;
                end
                trans.resp = vif.HRESP;
                
                // Broadcast
                analysis_port.write(trans);
            end
        end
    endtask
    
endclass
'''


def generate_sequencer():
    """生成sequencer"""
    return '''//==============================================================================
// AHB-Lite Sequencer
//==============================================================================

class ahb_lite_sequencer extends uvm_sequencer #(ahb_lite_transaction);
    `uvm_component_utils(ahb_lite_sequencer)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
endclass
'''


def generate_agent():
    """生成agent"""
    return '''//==============================================================================
// AHB-Lite Agent
//==============================================================================

class ahb_lite_agent extends uvm_agent;
    `uvm_component_utils(ahb_lite_agent)
    
    ahb_lite_driver    driver;
    ahb_lite_monitor   monitor;
    ahb_lite_sequencer sequencer;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = ahb_lite_monitor::type_id::create("monitor", this);
        if (get_is_active() == UVM_ACTIVE) begin
            driver = ahb_lite_driver::type_id::create("driver", this);
            sequencer = ahb_lite_sequencer::type_id::create("sequencer", this);
        end
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (get_is_active() == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction
    
endclass
'''


def generate_env():
    """生成env"""
    return '''//==============================================================================
// AHB-Lite Environment
//==============================================================================

class ahb_lite_env extends uvm_env;
    `uvm_component_utils(ahb_lite_env)
    
    ahb_lite_agent agent;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = ahb_lite_agent::type_id::create("agent", this);
    endfunction
    
endclass
'''


def generate_test():
    """生成test"""
    return '''//==============================================================================
// AHB-Lite Test
//==============================================================================

class ahb_lite_test extends uvm_test;
    `uvm_component_utils(ahb_lite_test)
    
    ahb_lite_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = ahb_lite_env::type_id::create("env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        ahb_lite_transaction trans;
        
        phase.raise_objection(this);
        
        `uvm_info("TEST", "Starting AHB-Lite Memory Test", UVM_LOW)
        
        // Run 10 random transactions
        repeat(10) begin
            trans = ahb_lite_transaction::type_id::create("trans");
            assert(trans.randomize());
            env.agent.sequencer.execute_item(trans);
        end
        
        #1000ns;
        
        `uvm_info("TEST", "Test Completed", UVM_LOW)
        phase.drop_objection(this);
    endtask
    
endclass
'''


def generate_tb_top():
    """生成tb_top"""
    return '''//==============================================================================
// Testbench Top
//==============================================================================

module tb_top;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    // Clock and reset
    logic HCLK = 0;
    logic HRESETn = 0;
    
    // Clock generation
    always #5 HCLK = ~HCLK;  // 100MHz
    
    // Interface instance
    ahb_lite_if dut_if(HCLK, HRESETn);
    
    // DUT instance
    ahb_lite_memory dut (
        .HCLK(dut_if.HCLK),
        .HRESETn(dut_if.HRESETn),
        .HSEL(dut_if.HSEL),
        .HADDR(dut_if.HADDR),
        .HWRITE(dut_if.HWRITE),
        .HSIZE(dut_if.HSIZE),
        .HBURST(dut_if.HBURST),
        .HTRANS(dut_if.HTRANS),
        .HWDATA(dut_if.HWDATA),
        .HRDATA(dut_if.HRDATA),
        .HREADY(dut_if.HREADY),
        .HRESP(dut_if.HRESP)
    );
    
    // Protocol checker instance
    ahb_lite_checker #(
        .ADDR_WIDTH(16),
        .DATA_WIDTH(32),
        .TIMEOUT_CYCLES(2000)
    ) checker (
        .HCLK(dut_if.HCLK),
        .HRESETn(dut_if.HRESETn),
        .HADDR(dut_if.HADDR),
        .HWRITE(dut_if.HWRITE),
        .HSIZE(dut_if.HSIZE),
        .HBURST(dut_if.HBURST),
        .HTRANS(dut_if.HTRANS),
        .HWDATA(dut_if.HWDATA),
        .HRDATA(dut_if.HRDATA),
        .HREADY(dut_if.HREADY),
        .HRESP(dut_if.HRESP)
    );
    
    initial begin
        // Reset sequence
        HRESETn = 0;
        repeat(10) @(posedge HCLK);
        HRESETn = 1;
        
        // Register interface with UVM config_db
        uvm_config_db#(virtual ahb_lite_if)::set(null, "*", "vif", dut_if);
        
        // Run test
        run_test("ahb_lite_test");
    end
    
    // Watchdog
    initial begin
        #10ms;
        `uvm_fatal("TIMEOUT", "Simulation timeout")
    end
    
endmodule
'''


def generate_makefile():
    """生成Makefile"""
    return '''# AHB-Lite Memory UVM Testbench Makefile

# VCS configuration
VCS = vcs
VCS_FLAGS = -full64 -sverilog -ntb_opts uvm-1.2 \\
            -timescale=1ns/1ps \\
            -debug_access+all \\
            -lca \\
            -kdb \\
            +vcs+flush+all

# Directories
TB_DIR = ../tb
RTL_DIR = ../../rtl
CHECKER_DIR = ../checkers

# Source files
RTL_FILES = $(RTL_DIR)/ahb_lite_memory.v
TB_FILES = $(TB_DIR)/ahb_lite_if.sv \\
           $(TB_DIR)/ahb_lite_transaction.sv \\
           $(TB_DIR)/ahb_lite_driver.sv \\
           $(TB_DIR)/ahb_lite_monitor.sv \\
           $(TB_DIR)/ahb_lite_sequencer.sv \\
           $(TB_DIR)/ahb_lite_agent.sv \\
           $(TB_DIR)/ahb_lite_env.sv \\
           $(TB_DIR)/ahb_lite_test.sv \\
           $(TB_DIR)/tb_top.sv

CHECKER_FILES = $(CHECKER_DIR)/ahb_lite_checker.sv

# Targets
.PHONY: all compile run clean

all: compile run

compile:
\t@echo "========================================="
\t@echo "  Compiling AHB-Lite UVM Testbench"
\t@echo "========================================="
\t$(VCS) $(VCS_FLAGS) \\
\t\t$(RTL_FILES) \\
\t\t$(CHECKER_FILES) \\
\t\t$(TB_FILES) \\
\t\t-l compile.log
\t@echo "Compilation complete!"

run:
\t@echo "========================================="
\t@echo "  Running simulation"
\t@echo "========================================="
\t./simv +UVM_TESTNAME=ahb_lite_test \\
\t       +UVM_VERBOSITY=UVM_LOW \\
\t       -l simv.log
\t@echo ""
\t@echo "Simulation complete! Check simv.log for results."

coverage:
\t@echo "========================================="
\t@echo "  Generating coverage report"
\t@echo "========================================="
\turg -dir simv.vdb -format both
\t@echo "Coverage report generated in urgReport/"

clean:
\t@echo "Cleaning up..."
\trm -rf simv* csrc *.log DVEfiles *.vpd *.vdb urgReport *.key
\t@echo "Clean complete!"

help:
\t@echo "Available targets:"
\t@echo "  make compile  - Compile the testbench"
\t@echo "  make run      - Run simulation"
\t@echo "  make coverage - Generate coverage report"
\t@echo "  make all      - Compile and run"
\t@echo "  make clean    - Remove generated files"
'''


def generate_readme():
    """生成README"""
    return '''# AHB-Lite Memory UVM Testbench

自动生成的AHB-Lite Memory Controller验证环境。

## 生成信息

- **生成工具**: AutoUVM v1.6
- **协议**: AHB-Lite
- **生成时间**: Generated by AutoUVM
- **DUT**: ahb_lite_memory (64KB, 32-bit)

## 目录结构

```
.
├── tb/               # UVM testbench组件
├── sim/              # 仿真脚本
├── checkers/         # Protocol checker (SVA)
└── docs/             # 文档
```

## 快速开始

### 1. 编译

```bash
cd sim
make compile
```

### 2. 运行仿真

```bash
make run
```

### 3. 查看结果

```bash
cat simv.log | grep "UVM_INFO"
```

## 生成的组件

- ✅ Interface (ahb_lite_if.sv)
- ✅ Transaction (ahb_lite_transaction.sv)
- ✅ Driver (ahb_lite_driver.sv)
- ✅ Monitor (ahb_lite_monitor.sv)
- ✅ Sequencer (ahb_lite_sequencer.sv)
- ✅ Agent (ahb_lite_agent.sv)
- ✅ Environment (ahb_lite_env.sv)
- ✅ Test (ahb_lite_test.sv)
- ✅ TB Top (tb_top.sv)
- ✅ Protocol Checker (ahb_lite_checker.sv) - 20+ SVA

## Protocol Checker

包含20+个SystemVerilog断言:
- 握手协议检查
- Transfer type转换规则
- Burst规则验证
- Timeout保护
- X/Z检测

## 注意事项

1. 需要VCS和UVM 1.2支持
2. 确保设置了$UVM_HOME环境变量
3. Protocol checker会自动检测协议违规

## AutoUVM v1.6

这个testbench由AutoUVM v1.6自动生成，支持:
- 8种协议 (AXI4/AHB-Lite/APB等)
- 111+ SVA断言
- 完整的UVM组件生成
- Protocol checker自动生成

更多信息: https://github.com/Honjun1102/AutoUVM
'''


def main():
    """主函数"""
    
    # 创建项目信息
    project_info = create_ahb_lite_memory_project()
    
    # 生成testbench
    output_dir = Path(__file__).parent / "generated_uvm"
    generate_testbench(project_info, str(output_dir))
    
    print("\n" + "=" * 70)
    print("  ✅ AHB-Lite验证环境生成完成！")
    print("=" * 70)
    print()
    print("下一步:")
    print("  1. cd generated_uvm/sim")
    print("  2. make compile")
    print("  3. make run")
    print()
    print("AutoUVM v1.6 - 让验证更简单！🚀")
    print()


if __name__ == "__main__":
    main()
