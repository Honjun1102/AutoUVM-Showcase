// AutoUVM生成 - SPI APB Agent
class spi_apb_agent extends uvm_agent;
  `uvm_component_utils(spi_apb_agent)
  
  spi_apb_driver   drv;
  spi_apb_monitor  mon;
  uvm_sequencer #(apb_transaction) sqr;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = spi_apb_monitor::type_id::create("mon", this);
    if (is_active == UVM_ACTIVE) begin
      drv = spi_apb_driver::type_id::create("drv", this);
      sqr = uvm_sequencer#(apb_transaction)::type_id::create("sqr", this);
    end
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end
  endfunction
endclass
