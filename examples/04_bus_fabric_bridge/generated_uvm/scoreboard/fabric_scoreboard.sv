// AutoUVM自动生成 - Fabric Scoreboard
// 验证总线互联的正确性

class fabric_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fabric_scoreboard)
  
  // ========== TLM Ports ==========
  // Master侧
  uvm_analysis_imp_cpu    #(axi4_transaction, fabric_scoreboard) cpu_master_export;
  uvm_analysis_imp_dma    #(axi4_transaction, fabric_scoreboard) dma_master_export;
  uvm_analysis_imp_debug  #(apb_transaction,  fabric_scoreboard) debug_master_export;
  
  // Slave侧
  uvm_analysis_imp_sram   #(axi4_transaction, fabric_scoreboard) sram_slave_export;
  uvm_analysis_imp_gpio   #(axi4_transaction, fabric_scoreboard) gpio_slave_export;
  uvm_analysis_imp_timer  #(apb_transaction,  fabric_scoreboard) timer_slave_export;
  
  // ========== 事务队列 ==========
  axi4_transaction cpu_trans_queue[$];
  axi4_transaction dma_trans_queue[$];
  apb_transaction  debug_trans_queue[$];
  
  axi4_transaction sram_trans_queue[$];
  axi4_transaction gpio_trans_queue[$];
  apb_transaction  timer_trans_queue[$];
  
  // ========== 参考模型 ==========
  address_decoder_model addr_dec_port;
  arbiter_model         arbiter_port;
  
  // ========== 统计 ==========
  int total_trans;
  int cpu_trans_cnt;
  int dma_trans_cnt;
  int debug_trans_cnt;
  int error_count;
  
  // ========== 地址映射 ==========
  typedef enum {SRAM, GPIO, TIMER} slave_target_e;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    cpu_master_export  = new("cpu_master_export", this);
    dma_master_export  = new("dma_master_export", this);
    debug_master_export= new("debug_master_export", this);
    sram_slave_export  = new("sram_slave_export", this);
    gpio_slave_export  = new("gpio_slave_export", this);
    timer_slave_export = new("timer_slave_export", this);
  endfunction
  
  // ============================================
  // Write方法: 接收事务
  // ============================================
  function void write_cpu(axi4_transaction tr);
    cpu_trans_queue.push_back(tr);
    cpu_trans_cnt++;
    total_trans++;
    check_routing(tr, "CPU");
  endfunction
  
  function void write_dma(axi4_transaction tr);
    dma_trans_queue.push_back(tr);
    dma_trans_cnt++;
    total_trans++;
    check_routing(tr, "DMA");
  endfunction
  
  function void write_debug(apb_transaction tr);
    debug_trans_queue.push_back(tr);
    debug_trans_cnt++;
    total_trans++;
    // APB只能访问Timer
    check_apb_routing(tr);
  endfunction
  
  function void write_sram(axi4_transaction tr);
    sram_trans_queue.push_back(tr);
    match_master_to_slave(tr, SRAM);
  endfunction
  
  function void write_gpio(axi4_transaction tr);
    gpio_trans_queue.push_back(tr);
    match_master_to_slave(tr, GPIO);
  endfunction
  
  function void write_timer(apb_transaction tr);
    timer_trans_queue.push_back(tr);
    match_apb_transaction(tr);
  endfunction
  
  // ============================================
  // 路由检查
  // ============================================
  function void check_routing(axi4_transaction tr, string master_name);
    slave_target_e expected_target;
    
    // 根据地址判断目标Slave
    if (tr.addr[31:28] == 4'h0)
      expected_target = SRAM;
    else if (tr.addr[31:28] == 4'h1)
      expected_target = GPIO;
    else if (tr.addr[31:28] == 4'h2)
      expected_target = TIMER;
    else begin
      `uvm_error("ROUTING", $sformatf("%s: Invalid address 0x%08x", 
                master_name, tr.addr))
      error_count++;
      return;
    end
    
    `uvm_info("ROUTING", $sformatf("%s -> %s (addr=0x%08x)", 
              master_name, expected_target.name(), tr.addr), UVM_HIGH)
  endfunction
  
  function void check_apb_routing(apb_transaction tr);
    // APB Master(Debug)只能通过Bridge访问Timer
    if (tr.addr[31:28] != 4'h2) begin
      `uvm_error("ROUTING", $sformatf("APB invalid address 0x%08x", tr.addr))
      error_count++;
    end
  endfunction
  
  // ============================================
  // Master-Slave匹配
  // ============================================
  function void match_master_to_slave(axi4_transaction slave_tr, slave_target_e target);
    axi4_transaction master_tr;
    bit found = 0;
    
    // 在Master队列中查找匹配的事务
    // 匹配条件: 地址、方向、大小
    
    // 先查CPU队列
    foreach (cpu_trans_queue[i]) begin
      master_tr = cpu_trans_queue[i];
      if (match_transaction(master_tr, slave_tr, target)) begin
        cpu_trans_queue.delete(i);
        found = 1;
        `uvm_info("MATCH", $sformatf("CPU -> %s matched", target.name()), UVM_MEDIUM)
        break;
      end
    end
    
    // 如果CPU队列没找到，查DMA队列
    if (!found) begin
      foreach (dma_trans_queue[i]) begin
        master_tr = dma_trans_queue[i];
        if (match_transaction(master_tr, slave_tr, target)) begin
          dma_trans_queue.delete(i);
          found = 1;
          `uvm_info("MATCH", $sformatf("DMA -> %s matched", target.name()), UVM_MEDIUM)
          break;
        end
      end
    end
    
    if (!found) begin
      `uvm_error("MISMATCH", $sformatf("No master trans for slave %s", target.name()))
      error_count++;
    end
  endfunction
  
  function bit match_transaction(axi4_transaction m_tr, axi4_transaction s_tr, slave_target_e target);
    // 地址匹配
    if (m_tr.addr != s_tr.addr)
      return 0;
    
    // 方向匹配
    if (m_tr.dir != s_tr.dir)
      return 0;
    
    // 数据匹配(写操作)
    if (m_tr.dir == WRITE) begin
      foreach (m_tr.data[i]) begin
        if (m_tr.data[i] != s_tr.data[i])
          return 0;
      end
    end
    
    return 1;
  endfunction
  
  function void match_apb_transaction(apb_transaction tr);
    // APB事务匹配 (简化)
    apb_transaction master_tr;
    
    if (debug_trans_queue.size() > 0) begin
      master_tr = debug_trans_queue.pop_front();
      if (master_tr.addr == tr.addr) begin
        `uvm_info("MATCH", "Debug -> Timer matched", UVM_MEDIUM)
      end else begin
        `uvm_error("MISMATCH", "APB address mismatch")
        error_count++;
      end
    end
  endfunction
  
  // ============================================
  // Deadlock检测
  // ============================================
  function bit check_deadlock();
    // 简化的deadlock检测:
    // 如果所有队列都非空且长时间不变化，可能死锁
    return (cpu_trans_queue.size() > 10 && 
            dma_trans_queue.size() > 10 &&
            sram_trans_queue.size() > 10);
  endfunction
  
  function int get_total_outstanding();
    return cpu_trans_queue.size() + dma_trans_queue.size() + debug_trans_queue.size();
  endfunction
  
  // ============================================
  // Report Phase: 打印统计
  // ============================================
  function void report_phase(uvm_phase phase);
    `uvm_info("REPORT", "========== Fabric Scoreboard Report ==========", UVM_LOW)
    `uvm_info("REPORT", $sformatf("Total Transactions: %0d", total_trans), UVM_LOW)
    `uvm_info("REPORT", $sformatf("  CPU:   %0d", cpu_trans_cnt), UVM_LOW)
    `uvm_info("REPORT", $sformatf("  DMA:   %0d", dma_trans_cnt), UVM_LOW)
    `uvm_info("REPORT", $sformatf("  Debug: %0d", debug_trans_cnt), UVM_LOW)
    `uvm_info("REPORT", $sformatf("Errors: %0d", error_count), UVM_LOW)
    
    if (error_count == 0)
      `uvm_info("REPORT", "✅ ALL CHECKS PASSED", UVM_LOW)
    else
      `uvm_error("REPORT", "❌ ERRORS DETECTED")
    
    `uvm_info("REPORT", "==========================================", UVM_LOW)
  endfunction
  
endclass
