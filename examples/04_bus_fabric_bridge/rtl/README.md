# RTL设计文件

本目录包含复杂拓扑验证示例的RTL设计代码。

## 📁 文件列表

| 文件 | 行数 | 说明 | 状态 |
|------|------|------|------|
| `axi4_crossbar_2x3.v` | 270+ | AXI4 2x3 Crossbar框架 | 简化实现 |
| `axi2apb_bridge.v` | 220+ | AXI-to-APB协议桥接 | 简化实现 |
| `simple_sram_axi4.v` | 100+ | AXI4 SRAM Slave (64KB) | 完整可用 |
| `simple_timer_apb.v` | 90+ | APB Timer Slave | 完整可用 |

## 🎯 系统连接

```
CPU_Master (AXI4) ────┐
                      │
DMA_Master (AXI4) ────┼──> axi4_crossbar_2x3 ────┬──> simple_sram_axi4
                      │                           │
                      │                           ├──> [GPIO Slave]
                      │                           │
                      └──────> axi2apb_bridge ────┘
                               (Protocol Convert)
                                      │
                                      └──> simple_timer_apb
```

## 📊 代码说明

### 1️⃣ axi4_crossbar_2x3.v

**功能**: 2-Master到3-Slave的AXI4总线互联

**关键特性**:
- 地址解码 (`decode_addr` function)
- Round-Robin仲裁
- Master->Slave路由逻辑

**简化之处**:
- 仅展示写地址通道路由
- 需要扩展为5通道完整实现
- Outstanding管理未完整实现

**完整实现**: 约1200-1500行

### 2️⃣ axi2apb_bridge.v

**功能**: AXI4到APB协议转换桥

**关键特性**:
- 协议转换状态机
- AXI4 Outstanding串行化
- 握手信号转换 (VALID/READY ↔ SEL/ENABLE)

**转换流程**:
```
AXI4 Write:  AWVALID/WVALID → PSEL → PENABLE → PREADY
AXI4 Read:   ARVALID → PSEL → PENABLE → PRDATA/PREADY
```

**简化之处**:
- 单事务处理（无FIFO队列）
- 不支持Burst拆分
- 简化错误处理

**完整实现**: 约800行

### 3️⃣ simple_sram_axi4.v

**功能**: 64KB AXI4 SRAM从设备

**特性**:
- ✅ 32位数据宽度
- ✅ Byte enable支持 (`wstrb`)
- ✅ 基本读写操作
- ✅ 可直接使用

**限制**:
- 只支持单次传输（无Burst）
- 简化的握手逻辑
- 无Outstanding支持

**代码**: 100行，完整可用

### 4️⃣ simple_timer_apb.v

**功能**: APB Timer从设备

**寄存器**:
- `0x00`: CTRL - 控制寄存器（使能等）
- `0x04`: COUNT - 当前计数值
- `0x08`: COMPARE - 比较阈值
- `0x0C`: STATUS - 状态寄存器（中断标志）

**特性**:
- ✅ APB规范握手
- ✅ 自动计数逻辑
- ✅ 比较匹配中断
- ✅ 完整可用

**代码**: 90行，完整可用

## 🚀 使用方式

### 编译测试

```bash
# 使用VCS编译（需要完整的testbench）
vcs -sverilog \
    axi4_crossbar_2x3.v \
    axi2apb_bridge.v \
    simple_sram_axi4.v \
    simple_timer_apb.v \
    -full64 \
    -timescale=1ns/1ps
```

### 集成到AutoUVM

```yaml
# 配置文件示例
system:
  modules:
    - name: crossbar
      rtl: axi4_crossbar_2x3.v
      type: interconnect
      
    - name: bridge
      rtl: axi2apb_bridge.v
      type: protocol_converter
      
    - name: sram
      rtl: simple_sram_axi4.v
      protocol: axi4
      
    - name: timer
      rtl: simple_timer_apb.v
      protocol: apb

  topology:
    masters: [cpu, dma]
    slaves: [sram, gpio, timer]
    bridges: [axi2apb]
```

## ⚠️ 重要说明

### 简化实现

这些RTL文件是**教学和演示用途**的简化实现，展示：
- ✅ 系统架构和连接方式
- ✅ 协议转换基本原理
- ✅ 总线互联基本逻辑

### 完整实现需要

生产级的Crossbar和Bridge需要：

1. **Crossbar完整功能**:
   - 所有5个AXI4通道的路由
   - 多Master仲裁（优先级/公平性）
   - Outstanding事务管理
   - ID重映射
   - 错误响应和超时
   - 代码量: 1200-1500行

2. **Bridge完整功能**:
   - Outstanding FIFO队列
   - Burst拆分逻辑
   - 时钟域跨越（可选）
   - 完整错误处理
   - 性能优化（pipelining）
   - 代码量: 800-1000行

3. **验证需求**:
   - UVM验证环境（AutoUVM生成）
   - 协议符合性检查（SVA）
   - 覆盖率收集
   - Corner case测试

## 📞 需要完整实现？

如果您需要生产级的Crossbar/Bridge实现：

- **Email**: honjun@tju.edu.cn
- **电话**: 13237089603

我们可以提供：
- 完整的RTL实现
- AutoUVM验证环境
- 协议检查器和覆盖率
- 技术支持

## 📊 代码统计

```
Total RTL Lines: ~680 lines
  - Crossbar framework: 270 lines
  - Bridge: 220 lines
  - SRAM Slave: 100 lines
  - Timer Slave: 90 lines

Estimated full implementation: 2500+ lines
  - Full Crossbar: 1200-1500 lines
  - Full Bridge: 800-1000 lines
  - Enhanced Slaves: 400-500 lines
```

---

<p align="center">
  <em>这些RTL展示了复杂拓扑的设计思路，<br/>
  AutoUVM可以自动生成相应的UVM验证环境</em>
</p>
