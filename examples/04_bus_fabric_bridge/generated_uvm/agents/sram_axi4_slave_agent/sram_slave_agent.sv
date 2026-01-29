// AutoUVM自动生成 - SRAM Slave Agent (Passive)

class sram_axi4_slave_agent extends uvm_agent;
  `uvm_component_utils(sram_axi4_slave_agent)
  
  sram_slave_monitor mon;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    is_active = UVM_PASSIVE;  // Slave只监控，不驱动
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = sram_slave_monitor::type_id::create("mon", this);
  endfunction
  
endclass
