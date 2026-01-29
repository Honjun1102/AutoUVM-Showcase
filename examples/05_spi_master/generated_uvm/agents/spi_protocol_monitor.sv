// AutoUVM自动生成 - SPI协议监视器
class spi_protocol_monitor extends uvm_monitor;
  `uvm_component_utils(spi_protocol_monitor)
  
  virtual spi_if vif;
  uvm_analysis_port #(spi_transaction) ap;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "SPI interface not found")
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      monitor_spi_transaction();
    end
  endtask
  
  task monitor_spi_transaction();
    spi_transaction tr;
    bit [7:0] mosi_data, miso_data;
    
    // 等待CS拉低
    @(negedge vif.spi_cs_n);
    
    tr = spi_transaction::type_id::create("spi_tr");
    tr.timestamp = $time;
    
    // 采样8位数据
    for (int i = 0; i < 8; i++) begin
      @(posedge vif.spi_sclk);
      mosi_data[7-i] = vif.spi_mosi;
      miso_data[7-i] = vif.spi_miso;
    end
    
    tr.mosi_data = mosi_data;
    tr.miso_data = miso_data;
    tr.cs_id = 0;
    
    // 等待CS拉高
    @(posedge vif.spi_cs_n);
    tr.duration = $time - tr.timestamp;
    
    ap.write(tr);
    `uvm_info("SPI_PROT_MON", $sformatf("MOSI=0x%02x MISO=0x%02x", 
              mosi_data, miso_data), UVM_MEDIUM)
  endtask
  
endclass
