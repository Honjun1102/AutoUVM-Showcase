# AutoUVM - 自动化UVM验证环境生成工具

<p align="center">
  <img src="https://img.shields.io/badge/版本-v1.6.0-orange?style=for-the-badge" alt="Version"/>
  <img src="https://img.shields.io/badge/状态-生产就绪-green?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/协议-商业授权-blue?style=for-the-badge" alt="License"/>
</p>

<p align="center">
  <strong>🚀 5分钟生成工业级UVM验证环境 | 支持8种协议(AXI4/AHB-Lite/APB等) | 20+ SVA断言</strong>
</p>

<p align="center">
  <a href="#-快速演示">快速演示</a> •
  <a href="#-核心特性">核心特性</a> •
  <a href="#-支持的协议">支持的协议</a> •
  <a href="#-应用场景">应用场景</a> •
  <a href="#-获取试用">获取试用</a>
</p>

---

## 📺 快速演示

### 🎯 完整示例代码（可直接查看）

本仓库包含完整的**实际运行**代码：

- 📁 [`examples/`](./examples/) - 多个完整验证环境示例
  - [`01_timer_basic/`](./examples/01_timer_basic/) - Timer验证（单Agent，AXI-Lite）✅
  - [`02_ahb_lite_memory/`](./examples/02_ahb_lite_memory/) - AHB-Lite内存控制器（单Agent）✅
  - [`03_multi_module_soc/`](./examples/03_multi_module_soc/) - **多模块SoC（3个Agents）**⭐ ✅
  - [`04_bus_fabric_bridge/`](./examples/04_bus_fabric_bridge/) - **总线互联+桥接（7 Agents拓扑）**📋 规划
- 📊 [`test_reports/`](./test_reports/) - 真实测试覆盖率报告
  - [`verification_report.html`](./test_reports/verification_report.html) - 多模块SoC验证报告

### 视频演示（即将上线）
- 🎬 Timer快速入门 (5分钟)
- 🎬 AXI4 DMA控制器验证 (8分钟)
- 🎬 覆盖率驱动验证 (6分钟)
- 🎬 AHB-Lite完整流程 (7分钟)

### GIF演示

```bash
# 一条命令，生成完整验证环境
$ python3 -m autouvm generate --rtl-dir timer --output timer_tb

✓ 分析RTL结构...
✓ 检测到APB协议
✓ 提取5个寄存器
✓ 生成Driver/Monitor/Sequencer...
✓ 生成RAL模型和测试用例...

完成！生成了45个文件，12,000行代码

# 编译并仿真
$ cd timer_tb && make sim

UVM_INFO: All tests PASSED
Coverage: 93.5% (Line), 89.2% (Functional)
```

### 📖 查看示例代码

**立即浏览**完整的生成代码：

```bash
# Clone展示仓库
git clone https://github.com/Honjun1102/AutoUVM-Showcase.git
cd AutoUVM-Showcase

# 查看Timer示例
cd examples/01_timer_basic
cat README.md              # 详细说明
ls -R agents/ env/ tests/  # 查看生成的UVM代码

# 查看测试报告
firefox ../test_reports/verification_report.html
```

---

## 🎯 核心特性

### 1️⃣ 完全自动化生成
- ✅ **5分钟生成完整环境** - 从RTL到可运行的testbench
- ✅ **12,000+行代码** - 手写需要2-3周
- ✅ **工业级质量** - 遵循UVM最佳实践
- ✅ **零手工编码** - 开箱即用

### 2️⃣ 强大的协议支持 (8种协议)
- 🔥 **AXI4 Full** - 5通道并行监控，ID-based追踪 (v1.5)
- 🔥 **AHB-Lite** - ARM高性能总线，流水线架构 (v1.6)
- ✅ **AXI4-Lite** - 简化版高速接口
- ✅ **APB** - 低功耗外设总线
- ✅ **UART** - 串口通信
- ✅ **I2C** - 两线串行总线
- ✅ **SPI** - 高速串行外设接口
- ✅ **Wishbone** - 开源总线标准

### 3️⃣ 完整的验证功能
- 📊 **自动覆盖率模型** - 代码+功能覆盖率
- 🛡️ **20+ SVA协议检查** - 实时协议违规检测
- 🎯 **寄存器验证** - 自动RAL生成和测试
- 🔄 **Coverage Loop** - 智能定向测试生成
- 📈 **HTML报告** - 可视化覆盖率分析

### 4️⃣ AHB-Lite完整实现（v1.6新增）🔥
- ⚡ **流水线架构** - 地址和数据相位正确分离
- 🎯 **8种Burst类型** - SINGLE/INCR/WRAP4/INCR4/WRAP8/INCR8/WRAP16/INCR16
- 💪 **Transfer Type状态机** - IDLE/BUSY/NONSEQ/SEQ完整支持
- 🛡️ **20+ SVA断言** - 握手/burst/transfer type/超时检查
- ⏱️ **Timeout保护** - 防止仿真挂起
- 📏 **全参数化** - ADDR/DATA宽度可配置
- 📝 **完整文档** - 详细使用指南和示例

### 5️⃣ AXI4 Full完整实现（v1.5）
- ⚡ **5通道并行监控** - AW/W/B/AR/R独立处理
- 🎯 **ID-based事务追踪** - 支持Outstanding transactions
- 💪 **完整Burst支持** - FIXED/INCR/WRAP三种模式
- 🛡️ **26+ SVA断言** - 握手/稳定性/burst/超时检查
- ⏱️ **Timeout保护** - 防止仿真挂起
- 📏 **全参数化** - ADDR/DATA/ID宽度可配置

---

## 🔌 支持的协议

<table>
<tr>
<td width="50%">

### 高速总线协议
- **AXI4 Full** ⭐ v1.5
  - 5通道完整实现
  - 26+ SVA协议检查
  - Outstanding支持
- **AHB-Lite** ⭐ NEW in v1.6
  - 流水线架构
  - 20+ SVA协议检查
  - 8种burst类型
- **AXI4-Lite**
  - 简化版实现
  - 快速集成
- **AHB-Lite** (开发中)
  - ARM高性能总线

</td>
<td width="50%">

### 外设接口协议
- **APB**
  - 低功耗外设总线
  - 完整的寄存器访问
- **UART**
  - 串口通信
  - 波特率可配置
- **I2C**
  - 主/从模式
  - 多设备支持
- **SPI**
  - 4种工作模式
  - 可配置时钟

</td>
</tr>
</table>

---

## 💼 应用场景

### 🎯 芯片设计公司
| 应用 | 节省时间 | 覆盖率提升 |
|-----|---------|----------|
| **DMA控制器验证** | 85% | 20-30% |
| **内存控制器 (DDR/LPDDR)** | 80% | 25-35% |
| **处理器接口** | 90% | 15-25% |
| **SoC子系统集成** | 75% | 20-30% |

### 🔬 FPGA/IP开发
- ✅ IP核快速验证
- ✅ 接口协议测试
- ✅ 系统集成验证
- ✅ 回归测试自动化

### 🎓 高校/研究机构
- ✅ 验证方法学教学
- ✅ 芯片设计课程实践
- ✅ 科研项目验证
- ✅ 学生项目快速启动

---

## 📊 验证效果对比

### 传统手写 vs AutoUVM

| 指标 | 手写UVM | AutoUVM | 提升 |
|-----|---------|---------|------|
| **开发时间** | 2-3周 | 5分钟 | **99.7%** ⬇️ |
| **代码质量** | 依赖经验 | 工业标准 | **一致性** ✓ |
| **协议正确性** | 手动检查 | 26+ SVA | **自动化** ✓ |
| **覆盖率** | 60-80% | 90-95% | **15-35%** ⬆️ |
| **维护成本** | 持续投入 | 自动更新 | **80%** ⬇️ |

### 实际案例

#### 案例1: Timer模块验证
- **手写**: 3天开发 + 2天调试 = **5天**
- **AutoUVM**: **5分钟**生成 + 30分钟定制 = **35分钟**
- **覆盖率**: 手写 72% → AutoUVM **93.5%**

#### 案例2: AXI4 DMA控制器
- **手写**: 2周开发 + 1周调试 = **3周**
- **AutoUVM**: **10分钟**生成 + 2小时定制 = **半天**
- **协议检查**: 手写 0个SVA → AutoUVM **26个SVA**

#### 案例3: SoC外设验证 (19个模块)
- **手写**: 估计 **6-8个月**
- **AutoUVM**: **2小时**生成 + 1周定制 = **1周**
- **代码量**: 200,000+行，100% UVM规范

---

## 🏆 技术亮点

### AXI4 Full实现（行业领先）

```systemverilog
// 自动生成的5通道并行监控
fork
    monitor_write_addr_channel();   // AW通道
    monitor_write_data_channel();   // W通道
    monitor_write_resp_channel();   // B通道
    monitor_read_addr_channel();    // AR通道
    monitor_read_data_channel();    // R通道
join_none

// ID-based事务追踪
bit [ID_WIDTH-1:0] awid_queue[$];
bit [ID_WIDTH-1:0] arid_queue[$];

// 完整Burst支持
case (burst_type)
    FIXED: addr = base_addr;
    INCR:  addr = base_addr + beat * burst_size;
    WRAP:  addr = calculate_wrap_address(...);
endcase
```

### 26+ SVA协议断言

```systemverilog
// 握手稳定性检查
property awvalid_stable;
    @(posedge aclk) disable iff (!aresetn)
    (awvalid && !awready) |=> $stable(awaddr);
endproperty

// Burst规则检查
property wlast_on_final_beat;
    @(posedge aclk) disable iff (!aresetn)
    (wvalid && wready && beat_count == awlen) |-> wlast;
endproperty

// 超时保护
property timeout_check;
    @(posedge aclk) disable iff (!aresetn)
    awvalid |-> ##[0:MAX_TIMEOUT] awready;
endproperty
```

---

## 📈 市场定位升级

### v1.0: 简单外设工具
- Timer, GPIO, UART等简单IP
- 市场容量: ~$50K-100K

### v1.5: 高性能SoC验证平台 🔥
- DMA, 内存控制器, 高速处理器接口
- PCIe endpoint, 网络控制器, 视频处理器
- **市场容量: ~$500K-1M** (扩大10倍！)

---

## 🚀 快速开始

### 环境要求
- **EDA工具**: VCS 2020+, Verdi, URG
- **Python**: 3.7+
- **操作系统**: Linux (RHEL/CentOS/Ubuntu)

### 安装和使用

```bash
# 1. 获取软件包（需要授权）
# 请联系我们获取试用版或商业许可

# 2. 生成验证环境
python3 -m autouvm generate \
  --rtl-dir your_design \
  --output tb_output

# 3. 编译和仿真
cd tb_output
make compile
make sim

# 4. 查看覆盖率
make coverage
firefox coverage_report/index.html
```

---

## 💰 商业合作

### 授权模式

#### 1. 试用版（免费）
- ✅ 单个模块验证
- ✅ 完整功能体验
- ✅ 14天试用期
- ✅ 技术支持（邮件）

#### 2. 专业版
- ✅ 不限模块数量
- ✅ 所有协议支持
- ✅ 1年更新和支持
- ✅ 邮件+远程技术支持
- 💰 **价格**: 联系商务

#### 3. 企业版
- ✅ 专业版所有功能
- ✅ 定制协议支持
- ✅ 现场培训和部署
- ✅ 优先技术支持
- ✅ 源码授权（可选）
- 💰 **价格**: 联系商务

### 学术授权
- 高校和研究机构享受特殊优惠
- 教学使用免费授权（需申请）
- 科研项目合作（可协商）

---

## 📞 获取试用

### 联系方式

- **📧 邮箱**: honjun@tju.edu.cn
- **📱 电话**: 13237089603
- **🌐 官网**: https://honjun1102.github.io/AutoUVM-Showcase/

### 商务咨询

请提供以下信息：
1. 公司/机构名称
2. 验证需求（模块类型、协议）
3. 团队规模
4. 预期使用场景

我们将在24小时内回复，并安排：
- ✅ 在线演示
- ✅ 技术答疑
- ✅ 试用版下载
- ✅ 报价方案

---

## 🎯 路线图

### v1.6 ✅ (当前版本)
- ✅ AHB-Lite协议完整支持
- ✅ 流水线架构实现
- ✅ 20+ SVA协议检查器
- ✅ 8种Burst类型支持
- ✅ 多Agent系统级验证

### v1.5 ✅
- ✅ AXI4 Full完整支持
- ✅ 26+ SVA协议检查
- ✅ 覆盖率驱动验证

### v2.0 (规划中) 📋
- 📋 复杂拓扑支持（多Master-多Slave）
- 📋 协议桥接（AXI↔APB自动转换）
- 📋 总线互联自动生成
- 📋 PCIe/CHI高级协议
- 📋 片上网络(NoC)验证
- 📋 形式化验证集成
- 📋 AI辅助测试生成

---

## 🏅 为什么选择AutoUVM？

### ✅ 节省时间和成本
- 95%+开发时间节省
- 降低验证工程师门槛
- 加快产品上市时间

### ✅ 提升质量
- 一致的工业级代码
- 完整的协议检查
- 更高的覆盖率

### ✅ 降低风险
- 自动化减少人为错误
- 标准化验证流程
- 完整的追溯性

### ✅ 持续支持
- 定期功能更新
- 专业技术支持
- 活跃的用户社区

---

## 📄 法律声明

- **版权所有**: © 2026 AutoUVM Team
- **商业软件**: 需要授权使用
- **专利保护**: 核心技术已申请专利
- **保密协议**: 试用需签署NDA

---

<p align="center">
  <strong>🚀 让UVM验证更简单、更高效、更可靠 🚀</strong>
</p>

<p align="center">
  <a href="#-获取试用">立即试用</a> |
  <a href="#-商业合作">商务合作</a> |
  <a href="#-联系方式">联系我们</a>
</p>
