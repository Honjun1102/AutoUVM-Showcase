# Timer 基础验证示例

这是使用AutoUVM自动生成的Timer IP验证环境完整示例。

## 📊 项目统计

- **RTL代码**: 200行 Verilog
- **生成UVM代码**: 2,000+ 行 SystemVerilog
- **生成时间**: < 3分钟
- **覆盖率**: 95%+
- **协议**: AXI-Lite

## 🎯 DUT特性

### Timer寄存器
- `CTRL` (0x00): 控制寄存器 (enable, mode, prescaler)
- `COUNT` (0x04): 当前计数值
- `COMPARE` (0x08): 比较阈值
- `STATUS` (0x0C): 状态寄存器 (overflow, match)

### 功能
- 32位向上/向下计数
- 可配置预分频器
- 比较匹配中断
- 溢出中断

## 📁 目录结构

```
01_timer_basic/
├── README.md              # 本文件
├── rtl/                   # RTL源码
│   └── timer.v
├── agents/                # 生成的UVM Agents
│   ├── axil_agent.sv
│   ├── axil_driver.sv
│   ├── axil_monitor.sv
│   └── ...
├── env/                   # 验证环境
│   └── timer_env.sv
├── tests/                 # 测试用例
│   ├── timer_ral_test.sv
│   └── ...
├── ral/                   # 寄存器抽象层
│   └── timer_ral.sv
├── interfaces/            # 接口定义
│   └── axil_if.sv
├── tb_top.sv             # Testbench顶层
├── Makefile              # VCS编译脚本
└── verification_report.html  # 覆盖率报告
```

## 🚀 快速开始

### 1. 查看RTL
```bash
cat rtl/timer.v
```

### 2. 查看生成的UVM环境
```bash
ls -R agents/ env/ tests/ ral/
```

### 3. 编译和运行（需要VCS）
```bash
make compile
make run
make cov_report
```

## 📈 测试场景

自动生成的测试包括：

1. **RAL Reset Test** - 寄存器复位值测试
2. **RAL RW Test** - 读写基本测试
3. **RAL Bit Bash** - 位级别压力测试
4. **RAL Access** - 访问模式测试
5. **Functional Test** - 功能性测试
   - Timer计数功能
   - 比较匹配
   - 溢出检测
   - 中断生成

## 📊 覆盖率结果

查看 `verification_report.html` 获取详细覆盖率：

- **寄存器覆盖**: 100%
- **功能覆盖**: 95%+
- **代码覆盖**: 90%+

## 🎓 学习要点

这个示例展示了AutoUVM如何：

1. ✅ **自动提取寄存器** - 从RTL自动识别寄存器定义
2. ✅ **生成RAL模型** - 创建完整的UVM RAL层
3. ✅ **协议自适应** - 自动适配AXI-Lite总线协议
4. ✅ **智能测试生成** - 自动创建多种测试场景
5. ✅ **覆盖率驱动** - 自动生成功能覆盖点

## 🔄 从零开始生成这个环境

如果你有AutoUVM工具，只需：

```bash
# 1. 准备RTL文件
cat > timer.v << 'RTL'
module timer(...);
  // 你的RTL代码
endmodule
RTL

# 2. 运行AutoUVM
autouvm generate --rtl timer.v --protocol axil

# 3. 编译运行
cd generated_uvm/
make all
```

**总耗时**: < 5分钟！

## 📞 技术支持

- **Email**: honjun@tju.edu.cn
- **项目主页**: https://github.com/Honjun1102/AutoUVM
