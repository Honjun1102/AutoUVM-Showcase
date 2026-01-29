# 多模块SoC验证示例（多Agent系统）

这是AutoUVM生成的**复杂多模块SoC**验证环境，展示了**多个Agent协同工作**的完整案例。

## 🎯 项目特点

### ⭐ 多Agent架构
- **3个独立模块**: Timer + UART + SPI
- **3个UVM Agent**: APB Agent + UART Agent + SPI Agent
- **系统级验证**: 跨模块交互测试
- **总线仲裁**: APB总线多主机支持

### 📊 复杂度对比

| 指标 | 单模块示例 | 本示例（多模块SoC） | 提升 |
|------|-----------|-------------------|------|
| **模块数** | 1 | 3 | 3倍 |
| **Agent数** | 1 | 3 | 3倍 |
| **RTL代码** | 200行 | 800+行 | 4倍 |
| **生成UVM代码** | 2000行 | 6000+行 | 3倍 |
| **测试场景** | 5个 | 15+个 | 3倍 |
| **生成时间** | 3分钟 | 12分钟 | - |

## 📁 目录结构

```
03_multi_module_soc/
├── README.md                      # 本文件
├── verification_report.html       # 系统级覆盖率报告
│
├── timer/                         # Timer模块 (APB接口)
│   ├── agents/
│   │   └── apb_agent/            # APB Agent
│   │       ├── apb_driver.sv     # APB协议驱动
│   │       ├── apb_monitor.sv    # APB事务监控
│   │       ├── apb_sequencer.sv
│   │       └── ...
│   ├── ral/                       # 寄存器抽象层
│   │   ├── timer_regs_ral_pkg.sv
│   │   └── timer_regs_apb_adapter.sv
│   ├── env/                       # Timer验证环境
│   ├── tests/                     # Timer测试用例
│   ├── interfaces/
│   ├── tb_top.sv
│   └── Makefile
│
├── uart/                          # UART模块（串口接口）
│   ├── agents/
│   │   └── uart_agent/           # UART Agent
│   │       ├── uart_driver.sv    # 串口协议驱动
│   │       ├── uart_monitor.sv   # 串口事务监控
│   │       └── ...
│   ├── env/                       # UART验证环境
│   ├── tests/                     # UART测试用例
│   ├── interfaces/
│   ├── tb_top.sv
│   └── Makefile
│
└── spi/                           # SPI模块（SPI接口）
    ├── agents/
    │   └── spi_agent/            # SPI Agent
    │       ├── spi_driver.sv     # SPI协议驱动
    │       ├── spi_monitor.sv    # SPI事务监控
    │       └── ...
    ├── env/                       # SPI验证环境
    ├── tests/                     # SPI测试用例
    ├── interfaces/
    ├── tb_top.sv
    └── Makefile
```

## 🎯 验证的DUT

### 1️⃣ Timer模块
- **接口**: APB (Advanced Peripheral Bus)
- **功能**: 32位定时器，中断生成
- **寄存器**: CTRL, COUNT, COMPARE, STATUS
- **Agent**: APB Agent (7个文件，1000+行)

### 2️⃣ UART模块
- **接口**: UART串口
- **功能**: 异步串行通信
- **特性**: 可配置波特率、奇偶校验、停止位
- **Agent**: UART Agent (7个文件，800+行)

### 3️⃣ SPI模块
- **接口**: SPI (Serial Peripheral Interface)
- **功能**: 同步串行通信
- **特性**: 主/从模式，4种工作模式
- **Agent**: SPI Agent (7个文件，900+行)

## 🚀 多Agent协同工作

### Agent协作架构

```
┌─────────────────────────────────────────────────┐
│            Top-Level Environment                │
│  ┌───────────┐  ┌────────────┐  ┌───────────┐ │
│  │ Timer Env │  │  UART Env  │  │  SPI Env  │ │
│  │           │  │            │  │           │ │
│  │ ┌───────┐ │  │ ┌────────┐ │  │ ┌───────┐ │ │
│  │ │APB Agt│ │  │ │UART Agt│ │  │ │SPI Agt│ │ │
│  │ └───────┘ │  │ └────────┘ │  │ └───────┘ │ │
│  └─────┬─────┘  └──────┬─────┘  └─────┬─────┘ │
└────────┼────────────────┼──────────────┼───────┘
         │                │              │
         ▼                ▼              ▼
    ┌────────┐       ┌────────┐     ┌───────┐
    │ Timer  │       │  UART  │     │  SPI  │
    │  DUT   │       │  DUT   │     │  DUT  │
    └────────┘       └────────┘     └───────┘
```

### 测试场景示例

1. **独立模块测试**
   - Timer基本功能测试
   - UART数据传输测试
   - SPI读写测试

2. **跨模块交互测试**
   - Timer中断触发 → UART发送数据
   - SPI接收配置 → 写入Timer寄存器
   - 并发操作压力测试

3. **系统级场景**
   - 总线仲裁测试
   - 中断优先级测试
   - 多主机并发访问

## 📊 覆盖率结果

查看 `verification_report.html`:

| 模块 | 代码覆盖 | 功能覆盖 | Agent文件数 | 生成时间 |
|------|----------|----------|------------|----------|
| Timer | 95% | 92% | 7 (APB) | 4分钟 |
| UART | 88% | 85% | 7 (UART) | 4分钟 |
| SPI | 92% | 90% | 7 (SPI) | 4分钟 |
| **系统级** | **90%** | **88%** | **21** | **12分钟** |

## 🎓 技术亮点

### 1. 自动Agent生成
每个模块自动生成完整的Agent：
```
spi_agent/
├── spi_agent.sv          # Agent顶层
├── spi_driver.sv         # 驱动器（协议实现）
├── spi_monitor.sv        # 监视器（事务捕获）
├── spi_sequencer.sv      # 序列器
├── spi_seq_item.sv       # 事务类型
├── spi_rand_seq.sv       # 随机序列
└── spi_agent_pkg.sv      # Package封装
```

### 2. 协议自适应
- **APB Agent** - 自动生成APB协议驱动
- **UART Agent** - 自动生成串口协议驱动
- **SPI Agent** - 自动生成SPI协议驱动
- 所有协议细节自动处理

### 3. 系统级连接
- 自动生成顶层Environment
- 自动连接多个Agent
- 自动生成跨模块测试
- 自动集成覆盖率收集

## 🔄 从零生成这个环境

如果你有AutoUVM：

```bash
# 1. 准备多模块设计
cat > soc_config.yaml << 'YAML'
modules:
  - name: timer
    rtl: timer.v
    protocol: apb
  - name: uart
    rtl: uart.v
    protocol: uart
  - name: spi
    rtl: spi.v
    protocol: spi
system:
  bus: apb
  integration: true
YAML

# 2. 一键生成
autouvm generate --config soc_config.yaml --output soc_tb

# 3. 编译运行
cd soc_tb && make all
```

**总耗时**: < 15分钟生成完整的多模块验证环境！

## 🎯 这个示例展示了什么？

### ✅ 不仅仅是简单外设
- ❌ 不是只有一个Agent的简单Demo
- ✅ 是真实的多模块SoC验证
- ✅ 展示了系统级验证能力
- ✅ 证明了工具的可扩展性

### ✅ 工业级验证能力
- 多Agent协同工作
- 跨模块交互测试
- 系统级覆盖率收集
- 完整的验证方法学

### ✅ 真实世界应用
- SoC芯片验证
- 多IP集成测试
- 总线互联验证
- 企业级验证需求

## 📈 复杂度对比

### 传统手写 vs AutoUVM（多模块）

| 任务 | 手写方式 | AutoUVM | 节省 |
|------|----------|---------|------|
| Agent开发 | 3周 × 3 = 9周 | 12分钟 | **99.9%** |
| 环境集成 | 2周 | 自动 | **100%** |
| 测试用例 | 1周 | 自动生成 | **95%** |
| 调试时间 | 2-3周 | < 1天 | **95%** |
| **总计** | **14-16周** | **< 1周** | **93%** |

## 📞 技术支持

- **Email**: honjun@tju.edu.cn
- **电话**: 13237089603
- **项目主页**: https://github.com/Honjun1102/AutoUVM

---

<p align="center">
  <strong>🚀 这才是真正的系统级验证能力展示 🚀</strong>
</p>
