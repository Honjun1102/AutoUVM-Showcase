# 05 - SPI Master控制器验证

## 📋 项目概述

**DUT**: SPI Master控制器  
**协议**: APB (配置接口) + SPI (串行接口)  
**特性**: 支持4种SPI模式 (CPOL/CPHA配置)

## 🎯 设计特点

### RTL设计 (193行)
- **SPI模式**: 支持Mode 0/1/2/3
- **可配置**: 时钟分频、片选
- **中断**: 传输完成中断
- **寄存器**: 控制、状态、数据、分频

### 寄存器映射
| 地址 | 名称 | 说明 |
|------|------|------|
| 0x00 | CTRL | enable, cpol, cpha, cs_id |
| 0x04 | STATUS | busy, done |
| 0x08 | DATA | TX/RX数据寄存器 |
| 0x0C | DIV | 时钟分频系数 |

## ✅ AutoUVM生成的验证环境 (278行)

### Agent组件
1. **spi_apb_driver** (59行)
   - APB总线驱动
   - 寄存器读写
   - 握手协议

2. **spi_apb_monitor** (41行)
   - APB事务监控
   - 数据捕获

3. **spi_protocol_monitor** (48行)
   - SPI协议级监控
   - MOSI/MISO数据采样
   - 时序验证

4. **spi_scoreboard** (60行)
   - APB写入 vs SPI发送对比
   - 自动匹配验证
   - 统计报告

### 测试序列
- **spi_basic_seq** (45行)
  - 配置分频系数
  - 发送随机数据
  - 读取接收数据
  - 验证回环

## 📊 验证覆盖

- ✅ 4种SPI模式 (CPOL=0/1, CPHA=0/1)
- ✅ 不同时钟分频
- ✅ 连续传输
- ✅ 中断功能

## 🔧 文件结构

```
05_spi_master/
├── rtl/
│   ├── spi_master.v         (157行) SPI Master
│   └── spi_slave_model.v    (36行)  测试用Slave
├── generated_uvm/
│   ├── agents/
│   │   ├── spi_apb_driver.sv
│   │   ├── spi_apb_monitor.sv
│   │   ├── spi_protocol_monitor.sv
│   │   ├── spi_transaction.sv
│   │   └── spi_scoreboard.sv
│   └── sequences/
│       └── spi_basic_seq.sv
└── README.md
```

## 💡 关键验证点

1. **协议正确性**: SPI时序符合标准
2. **模式切换**: 4种模式都能正常工作
3. **数据完整性**: 发送和接收数据匹配
4. **握手机制**: APB和SPI握手正确
5. **中断时序**: 传输完成后中断产生

## 🚀 特色

- 多协议验证 (APB + SPI)
- 协议级和事务级双重监控
- 自动化Scoreboard
- 支持不同SPI模式
