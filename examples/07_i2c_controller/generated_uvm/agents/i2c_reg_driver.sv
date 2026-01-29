// AutoUVM生成 - I2C寄存器驱动器
class i2c_reg_driver extends uvm_driver #(reg_transaction);
  `uvm_component_utils(i2c_reg_driver)
  
  virtual reg_if vif;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual reg_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Register interface not found")
  endfunction
  
  task run_phase(uvm_phase phase);
    reg_transaction req;
    forever begin
      seq_item_port.get_next_item(req);
      drive_reg(req);
      seq_item_port.item_done();
    end
  endtask
  
  task drive_reg(reg_transaction tr);
    @(posedge vif.clk);
    vif.reg_addr  = tr.addr;
    vif.reg_wdata = tr.data;
    vif.reg_wr    = tr.write;
    vif.reg_rd    = !tr.write;
    
    wait(vif.reg_ready);
    @(posedge vif.clk);
    
    if (!tr.write) begin
      tr.data = vif.reg_rdata;
    end
    
    vif.reg_wr = 1'b0;
    vif.reg_rd = 1'b0;
    
    `uvm_info("I2C_DRV", $sformatf("%s", tr.convert2string()), UVM_HIGH)
  endtask
  
endclass
