// AutoUVM自动生成 - DMA AXI4 Master Agent
// 复用AXI4组件，针对DMA特性优化

class dma_axi4_master_agent extends uvm_agent;
  `uvm_component_utils(dma_axi4_master_agent)
  
  cpu_axi4_driver     drv;   // 复用Driver
  cpu_axi4_monitor    mon;   // 复用Monitor
  cpu_axi4_sequencer  sqr;   // 复用Sequencer
  
  bit is_active = 1;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = cpu_axi4_monitor::type_id::create("mon", this);
    if (is_active == UVM_ACTIVE) begin
      drv = cpu_axi4_driver::type_id::create("drv", this);
      sqr = cpu_axi4_sequencer::type_id::create("sqr", this);
    end
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end
  endfunction
  
endclass
