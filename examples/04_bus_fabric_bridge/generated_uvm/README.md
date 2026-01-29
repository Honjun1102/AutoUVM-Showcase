# 7-Agent总线互联验证环境

## 📁 完整目录结构

```
generated_uvm/
├── system_pkg.sv                      # UVM Package (包含所有组件)
├── tb_top.sv                          # Testbench顶层
├── Makefile                           # 编译仿真脚本
│
├── interfaces/                        # 接口定义
│   ├── axi4_if.sv                     # AXI4接口
│   ├── apb_if.sv                      # APB接口
│   └── apb_transaction.sv             # APB事务类
│
├── agents/                            # 7个Agent
│   ├── cpu_axi4_master_agent/         # CPU Master (5个文件)
│   │   ├── cpu_axi4_transaction.sv
│   │   ├── cpu_axi4_sequencer.sv
│   │   ├── cpu_axi4_driver.sv
│   │   ├── cpu_axi4_monitor.sv
│   │   └── cpu_axi4_agent.sv
│   │
│   ├── dma_axi4_master_agent/         # DMA Master
│   │   └── dma_axi4_agent.sv
│   │
│   ├── debug_axi4_master_agent/       # Debug Master
│   │   └── debug_axi4_agent.sv
│   │
│   ├── sram_axi4_slave_agent/         # SRAM Slave (Passive)
│   │   ├── sram_slave_monitor.sv
│   │   └── sram_slave_agent.sv
│   │
│   ├── gpio_axi4_slave_agent/         # GPIO Slave (Passive)
│   │   └── gpio_slave_agent.sv
│   │
│   ├── timer_apb_slave_agent/         # Timer Slave (APB)
│   │   ├── timer_apb_monitor.sv
│   │   └── timer_apb_agent.sv
│   │
│   └── bridge_monitor_agent/          # Bridge Monitor (双侧)
│       ├── bridge_monitor.sv
│       └── bridge_monitor_agent.sv
│
├── env/
│   └── system_env.sv                  # 系统环境 (集成7个Agent)
│
├── scoreboard/
│   └── fabric_scoreboard.sv           # Fabric验证
│
├── sequences/                         # 测试序列
│   ├── cpu_random_seq.sv              # CPU随机访问
│   ├── dma_burst_seq.sv               # DMA Burst传输
│   └── debug_reg_seq.sv               # Debug寄存器访问
│
└── tests/                             # 测试用例
    └── concurrent_access_test.sv      # 并发访问测试
```

## 📊 统计信息

- **总文件数**: 26个文件
- **代码行数**: ~1,800行
- **Agent数量**: 7个
- **接口类型**: AXI4 + APB

## 🚀 使用方法

```bash
# 编译
make compile

# 运行测试
make sim TEST=concurrent_access_test

# 生成覆盖率
make coverage

# 清理
make clean
```

## 🎯 7-Agent架构

### Master Agents (主动发起事务)
1. **CPU Master** - 完整Agent (Transaction/Sequencer/Driver/Monitor/Agent)
2. **DMA Master** - 复用CPU组件
3. **Debug Master** - 复用CPU组件

### Slave Agents (被动监控)
4. **SRAM Slave** - AXI4 Passive Monitor
5. **GPIO Slave** - AXI4 Passive Monitor  
6. **Timer Slave** - APB Passive Monitor

### Monitor Agent (双侧监控)
7. **Bridge Monitor** - 同时监控AXI4和APB侧

## 💡 设计亮点

- ✅ **标准UVM结构** - 符合UVM 1.2规范
- ✅ **组件复用** - DMA/Debug复用CPU的Driver/Monitor
- ✅ **多协议** - AXI4 + APB
- ✅ **TLM通信** - Analysis Port连接
- ✅ **层次化架构** - Agent → Env → Test
- ✅ **可配置** - Active/Passive可配置

## 📝 关键文件说明

### system_pkg.sv
包含所有UVM组件的包文件，按照依赖顺序include各个文件。

### tb_top.sv
顶层testbench，实例化DUT和所有接口，配置UVM环境。

### Makefile
VCS编译仿真脚本，支持覆盖率和URG报告生成。

## 🔗 相关文档

- [架构说明](../README.md)
- [RTL设计](../rtl/README.md)
- [项目状态](../STATUS.md)
