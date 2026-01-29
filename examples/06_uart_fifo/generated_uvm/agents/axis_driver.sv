// AutoUVM自动生成 - AXI-Stream Driver
class axis_driver extends uvm_driver #(axis_transaction);
  `uvm_component_utils(axis_driver)
  
  virtual axis_if vif;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axis_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "AXIS interface not found")
  endfunction
  
  task run_phase(uvm_phase phase);
    axis_transaction req;
    forever begin
      seq_item_port.get_next_item(req);
      drive_axis(req);
      seq_item_port.item_done();
    end
  endtask
  
  task drive_axis(axis_transaction tr);
    @(posedge vif.aclk);
    vif.tdata  <= tr.data;
    vif.tvalid <= 1'b1;
    
    // 等待tready
    do begin
      @(posedge vif.aclk);
    end while (!vif.tready);
    
    vif.tvalid <= 1'b0;
    
    // 随机延迟
    if (tr.delay > 0) begin
      repeat(tr.delay) @(posedge vif.aclk);
    end
    
    `uvm_info("AXIS_DRV", $sformatf("Sent: data=0x%02x", tr.data), UVM_HIGH)
  endtask
  
endclass
