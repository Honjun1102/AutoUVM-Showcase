// AutoUVM自动生成 - Bridge Monitor Agent

class bridge_monitor_agent extends uvm_agent;
  `uvm_component_utils(bridge_monitor_agent)
  
  bridge_monitor mon;
  
  // 对外暴露的Analysis Ports
  uvm_analysis_port #(axi4_transaction) axi_ap;
  uvm_analysis_port #(apb_transaction)  apb_ap;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    is_active = UVM_PASSIVE;
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = bridge_monitor::type_id::create("mon", this);
    axi_ap = new("axi_ap", this);
    apb_ap = new("apb_ap", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // 转发Monitor的端口
    mon.axi_ap.connect(axi_ap);
    mon.apb_ap.connect(apb_ap);
  endfunction
  
endclass
