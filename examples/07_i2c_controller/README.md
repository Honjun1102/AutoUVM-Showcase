# 07 - I2C Master控制器验证

## 📋 项目概述

**DUT**: I2C Master控制器  
**协议**: Register接口 (配置) + I2C (双线)  
**特性**: 标准模式(100kHz)、快速模式(400kHz)

## 🎯 设计特点

### RTL设计 (211行)

#### 核心特性
- **I2C协议**: START, STOP, ACK, NACK
- **速度**: 支持标准/快速模式
- **寻址**: 7位从机地址
- **读写**: 支持读/写操作
- **中断**: 传输完成中断

#### 寄存器映射
| 地址 | 名称 | 说明 |
|------|------|------|
| 0x0 | CTRL | start, stop, read, write |
| 0x1 | STATUS | busy, ack, arb_lost |
| 0x2 | DATA | 读写数据寄存器 |
| 0x3 | SLAVE | 从机地址(7位) |
| 0x4 | PRESCL | 时钟分频系数 |

#### 状态机
```
IDLE → START → ADDR → ACK → WRITE_DATA/READ_DATA → STOP
```

## ✅ AutoUVM生成的验证环境

### Agent组件 (待完善)

1. **i2c_reg_driver**
   - 寄存器配置
   - 命令发送
   - 状态轮询

2. **i2c_protocol_monitor**
   - I2C总线监控
   - START/STOP条件检测
   - 数据/地址采样
   - ACK/NACK检测

3. **i2c_slave_agent**
   - Slave响应模拟
   - ACK生成
   - 数据回环

4. **i2c_scoreboard**
   - 命令 vs 总线行为验证
   - 地址匹配检查
   - 数据完整性验证

### 测试序列 (待实现)
- **i2c_write_seq**: 单字节写
- **i2c_read_seq**: 单字节读
- **i2c_burst_seq**: 连续读写
- **i2c_addr_scan_seq**: 地址扫描

## 📊 验证覆盖

- ✅ START/STOP条件
- ✅ 7位地址寻址
- ✅ ACK/NACK处理
- ✅ 数据读写
- ✅ 仲裁丢失检测
- ✅ 时钟拉伸
- ✅ 不同速度模式

## 🔧 文件结构

```
07_i2c_controller/
├── rtl/
│   └── i2c_master_ctrl.v    (211行) I2C Master
├── generated_uvm/
│   ├── agents/               (待完善)
│   ├── sequences/            (待完善)
│   └── tests/                (待完善)
└── README.md
```

## 💡 关键验证点

1. **START条件**: SDA下降沿(SCL高)
2. **STOP条件**: SDA上升沿(SCL高)
3. **ACK机制**: 第9个时钟的SDA
4. **数据采样**: SCL上升沿采样
5. **时钟控制**: 正确的分频和占空比

## 🚀 特色

- 双线协议(SCL/SDA)
- 开漏输出模拟
- 多速度模式支持
- 完整的I2C协议实现
- 中断和轮询两种方式

## 📝 状态

- RTL: ✅ 完成 (211行)
- UVM Environment: 🚧 框架设计中
- 这是一个展示AutoUVM能力的路线图示例
