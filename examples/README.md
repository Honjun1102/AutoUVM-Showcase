# AutoUVM 生成示例展示

本目录包含多个使用AutoUVM生成的完整UVM验证环境示例。

## 📁 目录结构

```
examples/
├── 01_timer_basic/          # 基础定时器验证（单Agent，AXI-Lite）
├── 02_ahb_lite_memory/      # AHB-Lite内存控制器（单Agent）
├── 03_multi_module_soc/     # 多模块SoC验证（3个Agents）⭐
├── 04_bus_fabric_bridge/    # 总线互联+协议桥接（规划示例）📋
└── README.md               # 本文件
```

## 🎯 示例说明

### 1️⃣ Timer基础示例
- **协议**: AXI-Lite  
- **Agent数**: 1个（AXI-Lite Agent）
- **功能**: 32位定时器，带中断
- **生成时间**: < 3分钟
- **代码量**: 2000+ 行UVM代码

### 2️⃣ AHB-Lite内存控制器
- **协议**: AHB-Lite
- **Agent数**: 1个（AHB-Lite Agent）
- **功能**: 64KB内存，支持突发传输
- **特性**: 流水线操作，协议检查器
- **生成时间**: < 4分钟

### 3️⃣ 多模块SoC验证 ⭐ **推荐**
- **模块**: Timer + UART + SPI
- **Agent数**: 3个（APB + UART + SPI）
- **协议**: 多种协议混合
- **特性**: 系统级验证，跨模块测试
- **生成时间**: < 12分钟
- **代码量**: 6000+ 行UVM代码
- **展示**: 真实的多Agent系统级验证能力

### 4️⃣ 总线互联+协议桥接 📋 **Roadmap展示**
- **架构**: 3 Master + 3 Slave + Bridge
- **Agent数**: 7个（层次化拓扑）
- **Master**: CPU(AXI4) + DMA(AXI4) + Debug(APB)
- **Slave**: SRAM + GPIO + Timer
- **特性**: 总线仲裁、协议转换、Outstanding管理
- **状态**: 规划中 (v1.7-v1.8)
- **展示**: AutoUVM支持复杂拓扑的设计能力
- **注**: 当前为架构设计文档，演示目标能力

## 🚀 每个示例包含

- ✅ 原始RTL设计 (`rtl/`)
- ✅ 完整UVM环境 (`generated_uvm/`)
- ✅ 测试序列 (`tests/`)
- ✅ 覆盖率报告 (`reports/`)
- ✅ 使用说明 (`README.md`)

## 📊 生成统计

| 示例 | RTL行数 | 生成UVM行数 | Agent数 | 覆盖率 | 生成时间 | 状态 |
|------|---------|-------------|---------|--------|----------|------|
| Timer | 200 | 2,000+ | 1 | 95%+ | 3分钟 | ✅ 已完成 |
| AHB Memory | 150 | 2,500+ | 1 | 98%+ | 4分钟 | ✅ 已完成 |
| Multi-SoC ⭐ | 800 | 6,000+ | 3 | 90%+ | 12分钟 | ✅ 已完成 |
| Bus Fabric 📋 | 2,500 | 15,000+ | 7 | 85%+ | 30分钟 | 📋 规划中 |

## 🎓 如何使用

每个示例都可以独立编译和运行：

```bash
cd 01_timer_basic/
make compile    # 编译
make run        # 运行仿真
make cov        # 生成覆盖率报告
```

## 📞 联系我们

- **Email**: honjun@tju.edu.cn
- **电话**: 13237089603
- **GitHub**: https://github.com/Honjun1102/AutoUVM
