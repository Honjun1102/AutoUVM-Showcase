// AutoUVM自动生成 - 系统级Environment
// 7-Agent复杂拓扑验证环境

class system_env extends uvm_env;
  `uvm_component_utils(system_env)
  
  // ========== Master Agents (Active) ==========
  cpu_axi4_master_agent   cpu_master_agt;
  dma_axi4_master_agent   dma_master_agt;
  debug_apb_master_agent  debug_master_agt;
  
  // ========== Slave Agents (Passive) ==========
  sram_axi4_slave_agent   sram_slave_agt;
  gpio_axi4_slave_agent   gpio_slave_agt;
  timer_apb_slave_agent   timer_slave_agt;
  
  // ========== Bridge Monitor ==========
  bridge_monitor_agent    bridge_mon_agt;
  
  // ========== Verification Components ==========
  fabric_scoreboard       fabric_sb;
  bridge_checker          bridge_chk;
  address_decoder_model   addr_decoder;
  arbiter_model           arbiter_mdl;
  
  // Configuration
  system_config cfg;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  // ============================================
  // Build Phase: 创建所有组件
  // ============================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // 获取配置
    if (!uvm_config_db#(system_config)::get(this, "", "cfg", cfg))
      `uvm_fatal("NOCFG", "System config not found")
    
    // 创建Master Agents
    cpu_master_agt   = cpu_axi4_master_agent::type_id::create("cpu_master_agt", this);
    dma_master_agt   = dma_axi4_master_agent::type_id::create("dma_master_agt", this);
    debug_master_agt = debug_apb_master_agent::type_id::create("debug_master_agt", this);
    
    // 创建Slave Agents  
    sram_slave_agt   = sram_axi4_slave_agent::type_id::create("sram_slave_agt", this);
    gpio_slave_agt   = gpio_axi4_slave_agent::type_id::create("gpio_slave_agt", this);
    timer_slave_agt  = timer_apb_slave_agent::type_id::create("timer_slave_agt", this);
    
    // 创建Bridge Monitor
    bridge_mon_agt   = bridge_monitor_agent::type_id::create("bridge_mon_agt", this);
    
    // 创建验证组件
    fabric_sb        = fabric_scoreboard::type_id::create("fabric_sb", this);
    bridge_chk       = bridge_checker::type_id::create("bridge_chk", this);
    addr_decoder     = address_decoder_model::type_id::create("addr_decoder", this);
    arbiter_mdl      = arbiter_model::type_id::create("arbiter_mdl", this);
    
    `uvm_info("SYS_ENV", "All components created", UVM_LOW)
  endfunction
  
  // ============================================
  // Connect Phase: 连接TLM端口
  // ============================================
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // Master -> Scoreboard 连接
    cpu_master_agt.mon.ap.connect(fabric_sb.cpu_master_export);
    dma_master_agt.mon.ap.connect(fabric_sb.dma_master_export);
    debug_master_agt.mon.ap.connect(fabric_sb.debug_master_export);
    
    // Slave -> Scoreboard 连接
    sram_slave_agt.mon.ap.connect(fabric_sb.sram_slave_export);
    gpio_slave_agt.mon.ap.connect(fabric_sb.gpio_slave_export);
    timer_slave_agt.mon.ap.connect(fabric_sb.timer_slave_export);
    
    // Bridge -> Checker 连接
    bridge_mon_agt.axi_ap.connect(bridge_chk.axi_side_export);
    bridge_mon_agt.apb_ap.connect(bridge_chk.apb_side_export);
    
    // Scoreboard -> Models 连接
    fabric_sb.addr_dec_port = addr_decoder;
    fabric_sb.arbiter_port  = arbiter_mdl;
    
    `uvm_info("SYS_ENV", "TLM connections established", UVM_LOW)
    print_topology();
  endfunction
  
  // ============================================
  // 打印拓扑信息
  // ============================================
  function void print_topology();
    `uvm_info("TOPOLOGY", "=== System Topology ===", UVM_LOW)
    `uvm_info("TOPOLOGY", "Masters:", UVM_LOW)
    `uvm_info("TOPOLOGY", "  1. CPU Master (AXI4)   - Active", UVM_LOW)
    `uvm_info("TOPOLOGY", "  2. DMA Master (AXI4)   - Active", UVM_LOW)
    `uvm_info("TOPOLOGY", "  3. Debug Master (APB)  - Active", UVM_LOW)
    `uvm_info("TOPOLOGY", "Slaves:", UVM_LOW)
    `uvm_info("TOPOLOGY", "  1. SRAM (AXI4)  - 0x0000_0000", UVM_LOW)
    `uvm_info("TOPOLOGY", "  2. GPIO (AXI4)  - 0x1000_0000", UVM_LOW)
    `uvm_info("TOPOLOGY", "  3. Timer (APB)  - 0x2000_0000 (via Bridge)", UVM_LOW)
    `uvm_info("TOPOLOGY", "Interconnect:", UVM_LOW)
    `uvm_info("TOPOLOGY", "  - AXI4 2x3 Crossbar", UVM_LOW)
    `uvm_info("TOPOLOGY", "  - AXI2APB Bridge", UVM_LOW)
    `uvm_info("TOPOLOGY", "====================", UVM_LOW)
  endfunction
  
  // ============================================
  // Run Phase: 监控系统状态
  // ============================================
  task run_phase(uvm_phase phase);
    fork
      monitor_system_health();
      print_statistics();
    join_none
  endtask
  
  task monitor_system_health();
    forever begin
      #10us;
      // 检查deadlock
      if (fabric_sb.check_deadlock())
        `uvm_error("DEADLOCK", "System deadlock detected!")
      
      // 检查outstanding超限
      if (fabric_sb.get_total_outstanding() > 16)
        `uvm_warning("HIGH_OUT", "High outstanding transactions")
    end
  endtask
  
  task print_statistics();
    forever begin
      #100us;
      `uvm_info("STATS", $sformatf("Total Transactions: %0d", 
                fabric_sb.total_trans), UVM_MEDIUM)
      `uvm_info("STATS", $sformatf("CPU: %0d, DMA: %0d, Debug: %0d", 
                fabric_sb.cpu_trans_cnt, 
                fabric_sb.dma_trans_cnt,
                fabric_sb.debug_trans_cnt), UVM_MEDIUM)
    end
  endtask
  
endclass
