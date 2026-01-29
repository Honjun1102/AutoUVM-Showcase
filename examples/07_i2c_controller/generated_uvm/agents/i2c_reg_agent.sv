// AutoUVM生成 - I2C寄存器Agent
class i2c_reg_agent extends uvm_agent;
  `uvm_component_utils(i2c_reg_agent)
  
  i2c_reg_driver drv;
  uvm_sequencer #(reg_transaction) sqr;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      drv = i2c_reg_driver::type_id::create("drv", this);
      sqr = uvm_sequencer#(reg_transaction)::type_id::create("sqr", this);
    end
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end
  endfunction
endclass
