// AutoUVM自动生成 - CPU AXI4 Master Agent
// 集成Driver, Monitor, Sequencer

class cpu_axi4_master_agent extends uvm_agent;
  `uvm_component_utils(cpu_axi4_master_agent)
  
  // Agent组件
  cpu_axi4_driver     drv;
  cpu_axi4_monitor    mon;
  cpu_axi4_sequencer  sqr;
  
  // Configuration
  bit is_active = 1;  // Active agent (has driver)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // 创建Monitor (always)
    mon = cpu_axi4_monitor::type_id::create("mon", this);
    
    // 创建Driver和Sequencer (if active)
    if (is_active == UVM_ACTIVE) begin
      drv = cpu_axi4_driver::type_id::create("drv", this);
      sqr = cpu_axi4_sequencer::type_id::create("sqr", this);
    end
    
    `uvm_info("CPU_AGT", "Agent components created", UVM_MEDIUM)
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    if (is_active == UVM_ACTIVE) begin
      // 连接Driver和Sequencer
      drv.seq_item_port.connect(sqr.seq_item_export);
      `uvm_info("CPU_AGT", "Driver-Sequencer connected", UVM_MEDIUM)
    end
  endfunction
  
  function void report_phase(uvm_phase phase);
    `uvm_info("CPU_AGT", $sformatf("CPU Master Agent %s", 
              is_active ? "Active" : "Passive"), UVM_LOW)
  endfunction
  
endclass
