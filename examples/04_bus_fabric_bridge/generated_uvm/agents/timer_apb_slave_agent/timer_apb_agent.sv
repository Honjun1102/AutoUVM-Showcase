// AutoUVM自动生成 - Timer APB Slave Agent

class timer_apb_slave_agent extends uvm_agent;
  `uvm_component_utils(timer_apb_slave_agent)
  
  timer_apb_monitor mon;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    is_active = UVM_PASSIVE;
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = timer_apb_monitor::type_id::create("mon", this);
  endfunction
  
endclass
