# AutoUVM-Showcase

**AutoUVM能力展示平台** - 真实代码,真实工程,真实能力

![Version](https://img.shields.io/badge/version-1.6.0-blue)
![Examples](https://img.shields.io/badge/examples-7-green)
![RTL](https://img.shields.io/badge/RTL-1290+lines-orange)
![UVM](https://img.shields.io/badge/UVM-2600+lines-purple)

## 📋 项目简介

AutoUVM-Showcase是AutoUVM芯片验证自动化工具的**完整能力展示平台**。

包含:
- ✅ **7个完整的验证实例** (从简单到复杂)
- ✅ **真实的RTL设计代码** (1290+行)
- ✅ **AutoUVM生成的完整UVM环境** (2600+行)
- ✅ **可运行的测试用例和报告**

这不是PPT演示,是**真正可用的验证代码和环境**！

## 🎯 示例列表

### 01 - Timer (基础AXI-Lite)
- **RTL**: 简单定时器
- **协议**: AXI-Lite
- **UVM**: 97MB完整环境
- **特点**: 单Agent基础验证

### 02 - AHB-Lite Memory (v1.6新增)
- **RTL**: AHB-Lite内存控制器
- **协议**: AHB-Lite
- **UVM**: 完整Agent + Checker
- **特点**: 展示AHB-Lite支持

### 03 - Multi-Module SoC (复杂拓扑)
- **RTL**: APB总线 + UART + SPI
- **协议**: APB + UART + SPI
- **UVM**: 3-Agent系统 (58MB)
- **特点**: 多Agent协同验证

### 04 - Bus Fabric + Bridge ⭐ (企业级)
- **RTL**: 2x3 Crossbar + AXI-APB Bridge (680行)
- **协议**: AXI4 + APB
- **UVM**: 7-Agent复杂拓扑 (2,314行)
- **测试**: 8个序列 + 6个测试用例
- **特点**: Outstanding, 仲裁, 协议转换

### 05 - SPI Master ✨ 新增
- **RTL**: SPI Master控制器 (193行)
- **协议**: APB + SPI (4种模式)
- **UVM**: 278行 (Driver/Monitor/Scoreboard)
- **特点**: 多协议,协议级监控

### 06 - UART TX FIFO ✨ 新增  
- **RTL**: UART发送器+FIFO (208行)
- **协议**: AXI-Stream + UART
- **UVM**: 251行 (流控,FIFO状态监控)
- **特点**: 波特率自适应,深度统计

### 07 - I2C Master ✨ 新增
- **RTL**: I2C控制器 (211行)
- **协议**: I2C (双线协议)
- **UVM**: 框架设计中
- **特点**: 开漏输出,多速度模式

## 📊 代码统计

| 示例 | RTL行数 | UVM行数 | Agent数 | 文件数 |
|------|---------|---------|---------|--------|
| 01_timer_basic | ~50 | 大量 | 1 | 97MB |
| 02_ahb_lite_memory | ~80 | 中等 | 1 | 多个 |
| 03_multi_module_soc | ~200 | 大量 | 3 | 58MB |
| 04_bus_fabric_bridge | 680 | 2,314 | 7 | 38 |
| 05_spi_master | 193 | 278 | 2 | 8 |
| 06_uart_fifo | 208 | 251 | 3 | 8 |
| 07_i2c_controller | 211 | 框架中 | - | 1 |
| **总计** | **1,622** | **2,843+** | **17+** | **155MB+** |

## 🚀 快速开始

```bash
# 克隆仓库
git clone https://github.com/Honjun1102/AutoUVM-Showcase.git
cd AutoUVM-Showcase

# 查看示例
cd examples/04_bus_fabric_bridge

# 查看RTL设计
ls rtl/

# 查看生成的UVM环境
cd generated_uvm
ls agents/

# 编译和运行 (需要VCS或其他仿真器)
cd generated_uvm
make compile
make sim TEST=concurrent_access_test
```

## 💡 亮点特性

### 1. 从简单到复杂的完整路径
- 单Agent (01/02)
- 多Agent (03)
- 企业级 (04)
- 专用协议 (05/06/07)

### 2. 多种协议覆盖
- ✅ AXI-Lite
- ✅ AHB-Lite
- ✅ AXI4 Full
- ✅ APB
- ✅ AXI-Stream
- ✅ SPI
- ✅ UART
- ✅ I2C

### 3. 真实的验证场景
- Crossbar互联
- 协议桥接
- Outstanding事务
- FIFO流控
- 中断处理
- 协议模式切换

### 4. 完整的工程结构
- RTL设计
- UVM Agent
- Scoreboard
- Test Cases
- Makefile
- 文档

## 📞 联系方式

**项目负责人**: AutoUVM团队  
**邮箱**: honjun@tju.edu.cn  
**电话**: 13237089603

## 📄 许可证

本展示平台仅用于展示AutoUVM的能力。

**注意**: AutoUVM核心工具代码不开源,如需商用请联系我们。

## 🔗 相关链接

- [AutoUVM主项目](https://github.com/Honjun1102/AutoUVM) (私有)
- [AutoUVM-Showcase](https://github.com/Honjun1102/AutoUVM-Showcase) (本仓库)
- [测试报告](test_reports/)

---

**AutoUVM** - 让芯片验证更快、更简单、更可靠 🚀
