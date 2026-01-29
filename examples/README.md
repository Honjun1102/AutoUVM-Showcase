# AutoUVM 生成示例展示

本目录包含多个使用AutoUVM生成的完整UVM验证环境示例。

## 📁 目录结构

```
examples/
├── 01_timer_basic/          # 基础定时器验证（AXI-Lite）
├── 02_ahb_lite_memory/      # AHB-Lite内存控制器
├── 03_axi4_dma/            # AXI4全功能DMA
├── 04_multi_module_soc/    # 多模块SoC验证
└── README.md               # 本文件
```

## 🎯 示例说明

### 1️⃣ Timer基础示例
- **协议**: AXI-Lite  
- **功能**: 32位定时器，带中断
- **生成时间**: < 5分钟
- **代码量**: 2000+ 行UVM代码

### 2️⃣ AHB-Lite内存控制器
- **协议**: AHB-Lite
- **功能**: 64KB内存，支持突发传输
- **特性**: 流水线操作，协议检查器
- **生成时间**: < 5分钟

### 3️⃣ AXI4 DMA控制器
- **协议**: AXI4 Full
- **功能**: DMA传输，突发优化
- **特性**: 多通道，仲裁逻辑
- **生成时间**: < 10分钟

### 4️⃣ 多模块SoC验证
- **模块**: Timer + UART + GPIO + Interrupt Controller
- **协议**: AXI-Lite总线互联
- **特性**: 跨模块测试，系统级验证
- **生成时间**: < 15分钟

## 🚀 每个示例包含

- ✅ 原始RTL设计 (`rtl/`)
- ✅ 完整UVM环境 (`generated_uvm/`)
- ✅ 测试序列 (`tests/`)
- ✅ 覆盖率报告 (`reports/`)
- ✅ 使用说明 (`README.md`)

## 📊 生成统计

| 示例 | RTL行数 | 生成UVM行数 | 覆盖率 | 生成时间 |
|------|---------|-------------|--------|----------|
| Timer | 200 | 2,000+ | 95%+ | 3分钟 |
| AHB Memory | 150 | 2,500+ | 98%+ | 4分钟 |
| AXI4 DMA | 500 | 3,500+ | 92%+ | 8分钟 |
| Multi-SoC | 1,200 | 8,000+ | 90%+ | 12分钟 |

## 🎓 如何使用

每个示例都可以独立编译和运行：

```bash
cd 01_timer_basic/
make compile    # 编译
make run        # 运行仿真
make cov        # 生成覆盖率报告
```

## 📞 联系我们

- **Email**: honjun1102@gmail.com
- **GitHub**: https://github.com/Honjun1102/AutoUVM
