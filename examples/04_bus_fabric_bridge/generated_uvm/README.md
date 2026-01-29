# AutoUVM生成的验证环境

本目录包含AutoUVM为复杂拓扑系统自动生成的UVM验证代码。

## 📊 生成统计

```
总代码量: 15,000+ 行SystemVerilog

分类:
  • Agents:     7,000 行 (7个Agent)
  • Scoreboard: 2,000 行
  • Tests:      3,000 行
  • Sequences:  2,000 行
  • Checkers:   1,000 行

生成时间: 约30分钟
```

## 📁 目录结构

```
generated_uvm/
├── agents/                        # 7个Agent (Master + Slave)
│   ├── cpu_axi4_master_agent/    # CPU Master Agent
│   │   ├── cpu_axi4_driver.sv
│   │   ├── cpu_axi4_monitor.sv
│   │   ├── cpu_axi4_sequencer.sv
│   │   ├── cpu_axi4_transaction.sv
│   │   └── cpu_axi4_agent.sv
│   │
│   ├── dma_axi4_master_agent/    # DMA Master Agent
│   ├── debug_apb_master_agent/   # Debug Master Agent
│   ├── sram_axi4_slave_agent/    # SRAM Slave Agent
│   ├── gpio_axi4_slave_agent/    # GPIO Slave Agent
│   ├── timer_apb_slave_agent/    # Timer Slave Agent
│   └── bridge_monitor_agent/     # Bridge Monitor
│
├── env/                           # 系统级Environment
│   ├── system_env.sv             # 顶层环境
│   ├── system_config.sv          # 系统配置
│   └── system_env_pkg.sv
│
├── scoreboard/                    # 验证组件
│   ├── fabric_scoreboard.sv      # 总线记分板
│   ├── bridge_checker.sv         # Bridge协议检查
│   └── address_decoder_model.sv  # 地址解码参考模型
│
├── sequences/                     # 测试序列
│   ├── concurrent_seq.sv         # 并发访问序列
│   ├── arbiter_test_seq.sv       # 仲裁测试序列
│   ├── bridge_test_seq.sv        # Bridge测试序列
│   └── stress_test_seq.sv        # 压力测试序列
│
├── tests/                         # 测试用例
│   ├── concurrent_access_test.sv
│   ├── arbiter_priority_test.sv
│   ├── bridge_protocol_test.sv
│   └── system_stress_test.sv
│
├── interfaces/                    # 接口定义
│   ├── axi4_if.sv
│   └── apb_if.sv
│
└── tb_top.sv                      # Testbench顶层
```

## 🎯 7个Agent详细说明

### Master侧 (3个Active Agent)

#### 1. CPU Master Agent (AXI4)
```systemverilog
// cpu_axi4_master_agent/
├── cpu_axi4_driver.sv         # 发起读写事务
├── cpu_axi4_monitor.sv        # 监控CPU总线
├── cpu_axi4_sequencer.sv      # 序列管理
├── cpu_axi4_transaction.sv    # 事务类型
└── cpu_axi4_agent.sv          # Agent顶层

功能:
- 发起内存访问（读/写）
- 支持Outstanding事务
- 支持Burst传输
- 优先级配置

代码量: 约1200行
```

#### 2. DMA Master Agent (AXI4)
```systemverilog
功能:
- 批量数据传输
- Burst优化（INCR/WRAP）
- 高性能连续访问
- 通道管理

代码量: 约1200行
```

#### 3. Debug Master Agent (APB)
```systemverilog
功能:
- 调试寄存器访问
- 单次传输
- 低优先级
- 简单握手

代码量: 约800行
```

### Bridge Monitor

#### 4. AXI2APB Bridge Monitor
```systemverilog
功能:
- 监控AXI4侧接口
- 监控APB侧接口
- 协议转换验证
- 时序对齐检查

代码量: 约1000行
```

### Slave侧 (3个Passive Agent)

#### 5. SRAM Slave Agent (AXI4)
```systemverilog
功能:
- 监控内存访问
- 响应模型
- 访问记录
- 数据完整性检查

代码量: 约1000行
```

#### 6. GPIO Slave Agent (AXI4)
```systemverilog
功能:
- 监控GPIO寄存器访问
- 寄存器模型
- 状态跟踪

代码量: 约800行
```

#### 7. Timer Slave Agent (APB)
```systemverilog
功能:
- 监控Timer寄存器
- APB协议监控
- 跨协议验证支持

代码量: 约800行
```

## 🔄 系统级Environment

```systemverilog
class system_env extends uvm_env;
  // Master Agents
  cpu_axi4_master_agent   cpu_agt;
  dma_axi4_master_agent   dma_agt;
  debug_apb_master_agent  dbg_agt;
  
  // Slave Agents
  sram_axi4_slave_agent   sram_agt;
  gpio_axi4_slave_agent   gpio_agt;
  timer_apb_slave_agent   timer_agt;
  
  // Bridge Monitor
  bridge_monitor_agent    bridge_mon;
  
  // Verification Components
  fabric_scoreboard       fabric_sb;
  bridge_checker          bridge_chk;
  address_decoder_model   addr_dec;
  
  // TLM连接
  function void connect_phase(uvm_phase phase);
    // Master -> Scoreboard
    cpu_agt.mon.ap.connect(fabric_sb.cpu_export);
    dma_agt.mon.ap.connect(fabric_sb.dma_export);
    dbg_agt.mon.ap.connect(fabric_sb.dbg_export);
    
    // Slave -> Scoreboard
    sram_agt.mon.ap.connect(fabric_sb.sram_export);
    gpio_agt.mon.ap.connect(fabric_sb.gpio_export);
    timer_agt.mon.ap.connect(fabric_sb.timer_export);
    
    // Bridge -> Checker
    bridge_mon.axi_ap.connect(bridge_chk.axi_export);
    bridge_mon.apb_ap.connect(bridge_chk.apb_export);
  endfunction
endclass
```

## 📝 关键验证组件

### Fabric Scoreboard
```systemverilog
class fabric_scoreboard extends uvm_scoreboard;
  // 事务队列
  cpu_trans_queue[$];
  dma_trans_queue[$];
  
  // 地址映射表
  addr_map_t addr_map;
  
  // 仲裁跟踪
  arbiter_state_t arb_state;
  
  // 验证逻辑
  - 检查地址解码正确性
  - 验证仲裁公平性
  - 跟踪Outstanding事务
  - 检测死锁
  
  代码量: 约1500行
endclass
```

### Bridge Checker
```systemverilog
class bridge_checker extends uvm_component;
  // 协议检查
  - AXI4地址 == APB地址
  - AXI4数据 == APB数据
  - 时序符合APB规范
  - Outstanding正确串行化
  
  代码量: 约800行
endclass
```

## 🧪 测试用例示例

### 1. 并发访问测试
```systemverilog
class concurrent_access_test extends uvm_test;
  task run_phase(uvm_phase phase);
    fork
      // CPU访问SRAM
      cpu_seq.start(env.cpu_agt.sqr);
      
      // DMA访问GPIO
      dma_seq.start(env.dma_agt.sqr);
      
      // Debug访问Timer (via Bridge)
      dbg_seq.start(env.dbg_agt.sqr);
    join
  endtask
endclass
```

### 2. 仲裁测试
```systemverilog
class arbiter_test extends uvm_test;
  // 3个Master竞争同一Slave
  // 验证Round-Robin顺序
  // 检查优先级处理
  // 确认公平性
endclass
```

### 3. Bridge协议测试
```systemverilog
class bridge_test extends uvm_test;
  // AXI4 -> APB转换
  // Outstanding串行化
  // 错误响应传播
  // 时序约束验证
endclass
```

## 🎯 AutoUVM自动生成的内容

✅ **自动生成** (无需手写):
- 7个完整的Agent
- 系统级Environment连接
- 基础Scoreboard框架
- 标准测试用例
- TLM端口连接
- 配置对象

🔧 **需要定制** (根据具体需求):
- 特定的仲裁策略验证
- 复杂的Corner Case测试
- 性能测试场景
- 应用层协议检查

## 📊 代码示例: Agent完整实现

查看 `agents/` 目录获取完整的Agent代码示例。

每个Agent包含完整的:
- Driver (协议驱动)
- Monitor (事务监控)
- Sequencer (序列管理)
- Transaction (数据类型)
- Agent (组件集成)
- Coverage (功能覆盖)

## 🚀 使用方式

```bash
# 编译
make compile

# 运行并发测试
make test TEST=concurrent_access_test

# 运行仲裁测试
make test TEST=arbiter_priority_test

# 生成覆盖率报告
make coverage
```

## 📞 了解更多

- **Email**: honjun@tju.edu.cn
- **电话**: 13237089603

如需AutoUVM为您的设计生成验证环境，请联系我们！
