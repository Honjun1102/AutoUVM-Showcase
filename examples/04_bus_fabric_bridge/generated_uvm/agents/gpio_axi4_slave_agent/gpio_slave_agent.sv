// AutoUVM自动生成 - GPIO Slave Agent (Passive)

class gpio_axi4_slave_agent extends uvm_agent;
  `uvm_component_utils(gpio_axi4_slave_agent)
  
  sram_slave_monitor mon;  // 复用SRAM的Monitor
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    is_active = UVM_PASSIVE;
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = sram_slave_monitor::type_id::create("mon", this);
  endfunction
  
endclass
