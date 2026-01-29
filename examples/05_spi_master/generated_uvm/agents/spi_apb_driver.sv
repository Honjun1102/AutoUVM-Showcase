// AutoUVM自动生成 - SPI APB Driver
class spi_apb_driver extends uvm_driver #(apb_transaction);
  `uvm_component_utils(spi_apb_driver)
  
  virtual apb_if vif;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "APB interface not found")
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_transaction req;
    forever begin
      seq_item_port.get_next_item(req);
      drive_apb(req);
      seq_item_port.item_done();
    end
  endtask
  
  task drive_apb(apb_transaction tr);
    @(posedge vif.pclk);
    vif.psel    = 1'b1;
    vif.paddr   = tr.addr;
    vif.pwrite  = tr.write;
    vif.pwdata  = tr.data;
    
    @(posedge vif.pclk);
    vif.penable = 1'b1;
    
    wait(vif.pready);
    @(posedge vif.pclk);
    
    if (!tr.write) begin
      tr.data = vif.prdata;
    end
    
    vif.psel    = 1'b0;
    vif.penable = 1'b0;
    
    `uvm_info("SPI_DRV", $sformatf("%s addr=0x%02x data=0x%08x", 
              tr.write ? "Write" : "Read", tr.addr, tr.data), UVM_HIGH)
  endtask
  
endclass
