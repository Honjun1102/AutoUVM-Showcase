# AHB-Lite Memory Controller Example

这是一个完整的AHB-Lite验证环境示例，展示了如何使用AutoUVM生成和运行AHB-Lite协议的UVM testbench。

## 📋 目录结构

```
ahb_lite_memory/
├── rtl/
│   └── ahb_lite_memory.v          # AHB-Lite memory controller RTL
├── tb/
│   └── ahb_lite_memory_test_seq.sv # 测试序列
├── README.md                       # 本文档
└── run_verification.sh             # 运行脚本 (待生成)
```

## 🎯 DUT特性

`ahb_lite_memory.v` 实现了一个简单的AHB-Lite从机memory controller：

- **地址空间**: 64KB (16-bit地址)
- **数据宽度**: 32-bit
- **支持的操作**:
  - ✅ Byte (8-bit) 读写
  - ✅ Halfword (16-bit) 读写
  - ✅ Word (32-bit) 读写
  - ✅ 所有burst类型 (SINGLE, INCR, INCR4/8/16, WRAP4/8/16)
- **特性**:
  - 流水线架构 (地址和数据相位分离)
  - 单周期操作
  - ERROR响应 (对越界访问和非法size)
  - 完整的AHB-Lite协议实现

## 🚀 快速开始

### 1. 使用AutoUVM生成验证环境

```bash
# 使用AutoUVM CLI生成UVM环境
cd /home/yian/桌面/AutoUVM

# 方式1: 从RTL自动生成
autouvm generate \
    --input examples/ahb_lite_memory/rtl/ahb_lite_memory.v \
    --output examples/ahb_lite_memory/generated \
    --protocol ahb_lite \
    --top-module ahb_lite_memory

# 方式2: 使用Python API
python3 << 'EOF'
from autouvm3.cli import generate_uvm_from_rtl

generate_uvm_from_rtl(
    rtl_file="examples/ahb_lite_memory/rtl/ahb_lite_memory.v",
    output_dir="examples/ahb_lite_memory/generated",
    top_module="ahb_lite_memory",
    protocol="ahb_lite"
)
EOF
```

### 2. 查看生成的文件

```bash
cd examples/ahb_lite_memory/generated
tree .

# 你会看到:
# .
# ├── sim/
# │   ├── Makefile
# │   └── run.do
# ├── tb/
# │   ├── ahb_lite_memory_agent.sv
# │   ├── ahb_lite_memory_driver.sv      # AHB-Lite driver (自动生成)
# │   ├── ahb_lite_memory_monitor.sv     # AHB-Lite monitor (自动生成)
# │   ├── ahb_lite_memory_sequencer.sv
# │   ├── ahb_lite_memory_env.sv
# │   ├── ahb_lite_memory_test.sv
# │   └── ahb_lite_memory_pkg.sv
# ├── checkers/
# │   └── ahb_lite_checker.sv            # 20+ SVA assertions
# └── README.md
```

### 3. 编译和运行

使用VCS编译和运行：

```bash
cd examples/ahb_lite_memory/generated/sim

# 编译
vcs -full64 -sverilog \
    -ntb_opts uvm-1.2 \
    +incdir+../tb \
    ../tb/ahb_lite_memory_pkg.sv \
    ../tb/tb_top.sv \
    ../../rtl/ahb_lite_memory.v \
    -debug_access+all \
    -l compile.log

# 运行
./simv +UVM_TESTNAME=ahb_lite_memory_test \
       +UVM_VERBOSITY=UVM_LOW \
       -l simv.log

# 查看结果
cat simv.log | grep "Test.*Completed"
```

或使用Makefile：

```bash
make compile
make run
make coverage
```

### 4. 使用自定义测试序列

将提供的测试序列集成到环境中：

```bash
# 复制测试序列到生成的testbench
cp ../tb/ahb_lite_memory_test_seq.sv generated/tb/

# 在test文件中导入
# (generated/tb/ahb_lite_memory_test.sv)
```

```systemverilog
class ahb_lite_memory_test extends base_test;
    `uvm_component_utils(ahb_lite_memory_test)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        ahb_lite_memory_test_seq seq;
        
        phase.raise_objection(this);
        
        seq = ahb_lite_memory_test_seq::type_id::create("seq");
        seq.start(env.agent.sequencer);
        
        phase.drop_objection(this);
    endtask
endclass
```

## 📊 测试覆盖

测试序列 (`ahb_lite_memory_test_seq.sv`) 包含7个测试场景：

1. **Test 1: Single Word Write/Read**
   - 基本的单次word写入和读回
   - 验证数据完整性

2. **Test 2: Byte Operations**
   - 字节级别的读写
   - 验证byte lane选择

3. **Test 3: INCR4 Burst Write**
   - 4-beat递增burst写
   - 验证burst地址生成

4. **Test 4: INCR4 Burst Read**
   - 4-beat递增burst读
   - 验证burst数据完整性

5. **Test 5: Halfword Operations**
   - 半字(16-bit)读写
   - 验证对齐和数据正确性

6. **Test 6: Walking 1s Pattern**
   - 32位walking 1s测试
   - 验证所有数据位

7. **Test 7: Random Operations**
   - 100个随机事务
   - 压力测试和corner cases

## 🎯 Protocol Checker

生成的`ahb_lite_checker.sv`包含20+个SVA断言：

### 断言分类

| 类别 | 断言数量 | 覆盖内容 |
|------|----------|----------|
| 握手协议 | 4 | HREADY行为, 信号稳定性 |
| Transfer Type | 3 | 状态转换规则 |
| Burst规则 | 3 | SINGLE/burst一致性 |
| HSIZE有效性 | 2 | 范围和总线宽度检查 |
| Response | 2 | ERROR响应, SEQ规则 |
| Timeout | 1 | HREADY超时保护 |
| X/Z检测 | 5 | 关键信号X/Z检测 |

### 示例断言

```systemverilog
// 握手协议: HREADY=0时地址必须稳定
property addr_stable_when_not_ready;
    @(posedge HCLK) disable iff (!HRESETn)
    (!HREADY && $past(HTRANS) inside {NONSEQ, SEQ}) |=>
    (HADDR === $past(HADDR));
endproperty
assert_addr_stable: assert property(addr_stable_when_not_ready)
    else $error("Address changed while HREADY low");

// Burst规则: SEQ的HBURST必须与NONSEQ匹配
property seq_same_burst;
    @(posedge HCLK) disable iff (!HRESETn)
    (HTRANS == SEQ && $past(HTRANS) inside {NONSEQ, SEQ}) |->
    (HBURST == $past(HBURST));
endproperty
assert_seq_burst: assert property(seq_same_burst)
    else $error("HBURST changed within burst");

// Timeout: HREADY必须在超时周期内拉高
property hready_timeout;
    @(posedge HCLK) disable iff (!HRESETn)
    (HTRANS inside {NONSEQ, SEQ}) |->
    strong(##[0:TIMEOUT_CYCLES] HREADY);
endproperty
assert_hready_timeout: assert property(hready_timeout)
    else $error("HREADY timeout");
```

## 📈 Coverage Points

自动生成的coverage groups：

```systemverilog
covergroup ahb_protocol_cov @(posedge HCLK);
    // Transfer types (4 bins)
    trans_type: coverpoint HTRANS {
        bins idle   = {2'b00};
        bins busy   = {2'b01};
        bins nonseq = {2'b10};
        bins seq    = {2'b11};
    }
    
    // Burst types (8 bins)
    burst_type: coverpoint HBURST {
        bins single = {3'b000};
        bins incr   = {3'b001};
        bins wrap4  = {3'b010};
        bins incr4  = {3'b011};
        bins wrap8  = {3'b100};
        bins incr8  = {3'b101};
        bins wrap16 = {3'b110};
        bins incr16 = {3'b111};
    }
    
    // Cross coverage
    burst_x_size: cross burst_type, trans_size;
    trans_x_dir: cross trans_type, direction;
endgroup
```

## 🔍 调试技巧

### 1. 查看波形

```bash
# 使用DVE查看波形
dve -vpd vcdplus.vpd &

# 关注信号:
# - HCLK, HRESETn
# - HADDR, HWRITE, HSIZE, HBURST, HTRANS
# - HWDATA, HRDATA
# - HREADY, HRESP
```

### 2. UVM日志分析

```bash
# 筛选特定组件的日志
grep "DRIVER" simv.log
grep "MONITOR" simv.log
grep "SCOREBOARD" simv.log

# 查看assertion failures
grep "Error" simv.log
grep "assert" simv.log
```

### 3. Coverage分析

```bash
# 生成coverage报告
urg -dir simv.vdb -format both

# 打开HTML报告
firefox urgReport/index.html
```

## 💡 扩展建议

### 1. 添加Scoreboard

```systemverilog
class ahb_lite_scoreboard extends uvm_scoreboard;
    // 存储写操作
    bit [31:0] memory_model [bit[31:0]];
    
    function void write(ahb_lite_transaction trans);
        if (trans.write) begin
            memory_model[trans.addr] = trans.data;
        end else begin
            if (!memory_model.exists(trans.addr)) begin
                `uvm_error("SCB", "Read from uninitialized address")
            end else if (memory_model[trans.addr] != trans.data) begin
                `uvm_error("SCB", $sformatf(
                    "Data mismatch: addr=0x%h, expected=0x%h, got=0x%h",
                    trans.addr, memory_model[trans.addr], trans.data))
            end
        end
    endfunction
endclass
```

### 2. 添加ERROR测试

```systemverilog
// 测试越界访问
trans.randomize() with {
    addr >= 32'h0001_0000;  // 超出64KB范围
};
// 期望HRESP = ERROR

// 测试非法HSIZE
trans.randomize() with {
    size == 3'b011;  // Double word (64-bit), 超出32-bit总线
};
// 期望HRESP = ERROR
```

### 3. 添加性能检查

```systemverilog
// 监控HREADY延迟
class performance_monitor extends uvm_monitor;
    int ready_delay_histogram[int];
    
    task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.HCLK);
            if (vif.HTRANS inside {NONSEQ, SEQ}) begin
                int delay = 0;
                while (!vif.HREADY) begin
                    delay++;
                    @(posedge vif.HCLK);
                end
                ready_delay_histogram[delay]++;
            end
        end
    endtask
endclass
```

## 📚 参考资料

- AutoUVM文档: [docs/protocols/ahb_lite.md](../../docs/protocols/ahb_lite.md)
- ARM AMBA Specification: [ARM IHI0033B](https://developer.arm.com/documentation/ihi0033/latest/)
- UVM 1.2 User Guide: [Accellera UVM](https://www.accellera.org/downloads/standards/uvm)

## 🎓 学习路径

1. **初学者**: 
   - 运行basic test
   - 理解driver和monitor的作用
   - 查看transaction flow

2. **中级**: 
   - 添加自定义sequence
   - 实现scoreboard
   - 分析coverage gaps

3. **高级**: 
   - 添加constrained random testing
   - 实现functional coverage
   - 集成protocol checker

## 🐛 常见问题

### Q: 为什么需要地址对齐？
**A**: AHB-Lite协议要求地址必须按传输大小对齐。例如word (32-bit)传输要求地址低2位为0。

### Q: WRAP burst如何工作？
**A**: WRAP burst在固定边界内循环。例如WRAP4 word从0x1004开始会访问: 0x1004, 0x1008, 0x100C, 0x1000 (回到边界)。

### Q: 如何处理ERROR响应？
**A**: ERROR响应总是两周期: 第一周期HREADY=0且HRESP=1, 第二周期HREADY=1且HRESP=1。

### Q: BUSY transfer是什么？
**A**: BUSY用于在burst中插入等待周期，保持burst序列而不实际传输数据。

## 📞 获取帮助

- GitHub Issues: [https://github.com/Honjun1102/AutoUVM/issues](https://github.com/Honjun1102/AutoUVM/issues)
- Documentation: [https://github.com/Honjun1102/AutoUVM/docs](https://github.com/Honjun1102/AutoUVM/docs)
- Email: honjun1102@gmail.com

---

**祝验证愉快！🎉**
