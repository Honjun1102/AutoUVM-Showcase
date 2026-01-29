// AutoUVM自动生成 - Bridge Monitor
// 同时监控AXI4侧和APB侧，验证协议转换

class bridge_monitor extends uvm_monitor;
  `uvm_component_utils(bridge_monitor)
  
  virtual axi4_if axi_vif;
  virtual apb_if  apb_vif;
  
  // 两个Analysis Ports
  uvm_analysis_port #(axi4_transaction) axi_ap;
  uvm_analysis_port #(apb_transaction)  apb_ap;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    axi_ap = new("axi_ap", this);
    apb_ap = new("apb_ap", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi4_if)::get(this, "", "axi_vif", axi_vif))
      `uvm_fatal("NOVIF", "AXI4 interface not found")
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "apb_vif", apb_vif))
      `uvm_fatal("NOVIF", "APB interface not found")
  endfunction
  
  task run_phase(uvm_phase phase);
    fork
      monitor_axi4_side();
      monitor_apb_side();
    join
  endtask
  
  // 监控AXI4侧
  task monitor_axi4_side();
    axi4_transaction tr;
    forever begin
      @(posedge axi_vif.aclk);
      
      // 监控写事务
      if (axi_vif.awvalid && axi_vif.awready) begin
        tr = axi4_transaction::type_id::create("axi_wr");
        tr.dir = WRITE;
        tr.addr = axi_vif.awaddr;
        tr.timestamp = $time;
        
        // 等待完成
        @(posedge axi_vif.aclk iff (axi_vif.bvalid && axi_vif.bready));
        
        axi_ap.write(tr);
        `uvm_info("BRIDGE_MON", "AXI4 Write captured", UVM_HIGH)
      end
      
      // 监控读事务
      if (axi_vif.arvalid && axi_vif.arready) begin
        tr = axi4_transaction::type_id::create("axi_rd");
        tr.dir = READ;
        tr.addr = axi_vif.araddr;
        tr.timestamp = $time;
        
        @(posedge axi_vif.aclk iff (axi_vif.rvalid && axi_vif.rready && axi_vif.rlast));
        
        axi_ap.write(tr);
        `uvm_info("BRIDGE_MON", "AXI4 Read captured", UVM_HIGH)
      end
    end
  endtask
  
  // 监控APB侧
  task monitor_apb_side();
    apb_transaction tr;
    forever begin
      @(posedge apb_vif.pclk);
      
      if (apb_vif.psel && apb_vif.penable && apb_vif.pready) begin
        tr = apb_transaction::type_id::create("apb_tr");
        tr.addr = apb_vif.paddr;
        tr.write = apb_vif.pwrite;
        tr.data = apb_vif.pwrite ? apb_vif.pwdata : apb_vif.prdata;
        tr.timestamp = $time;
        
        apb_ap.write(tr);
        
        `uvm_info("BRIDGE_MON", $sformatf("APB %s: addr=0x%08x", 
                  tr.write ? "Write" : "Read", tr.addr), UVM_HIGH)
      end
    end
  endtask
  
endclass
