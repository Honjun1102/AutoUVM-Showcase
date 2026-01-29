// AutoUVM自动生成 - SRAM Slave Monitor
// Passive监控，不驱动信号

class sram_slave_monitor extends uvm_monitor;
  `uvm_component_utils(sram_slave_monitor)
  
  virtual axi4_if vif;
  uvm_analysis_port #(axi4_transaction) ap;
  
  // 事务收集
  axi4_transaction trans_queue[$];
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi4_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not found")
  endfunction
  
  task run_phase(uvm_phase phase);
    fork
      monitor_write_transactions();
      monitor_read_transactions();
    join
  endtask
  
  // 监控写事务
  task monitor_write_transactions();
    axi4_transaction tr;
    forever begin
      @(posedge vif.aclk);
      if (vif.awvalid && vif.awready) begin
        tr = axi4_transaction::type_id::create("wr_tr");
        tr.dir = WRITE;
        tr.addr = vif.awaddr;
        tr.id = vif.awid;
        
        // 等待数据和响应完成
        wait_for_write_complete(tr);
        
        // 发送到Scoreboard
        ap.write(tr);
        
        `uvm_info("SRAM_MON", $sformatf("Write: addr=0x%08x", tr.addr), UVM_MEDIUM)
      end
    end
  endtask
  
  task wait_for_write_complete(axi4_transaction tr);
    // 简化: 等待BVALID
    @(posedge vif.aclk iff (vif.bvalid && vif.bready));
    tr.resp = vif.bresp;
  endtask
  
  // 监控读事务
  task monitor_read_transactions();
    axi4_transaction tr;
    forever begin
      @(posedge vif.aclk);
      if (vif.arvalid && vif.arready) begin
        tr = axi4_transaction::type_id::create("rd_tr");
        tr.dir = READ;
        tr.addr = vif.araddr;
        tr.id = vif.arid;
        
        wait_for_read_complete(tr);
        ap.write(tr);
        
        `uvm_info("SRAM_MON", $sformatf("Read: addr=0x%08x", tr.addr), UVM_MEDIUM)
      end
    end
  endtask
  
  task wait_for_read_complete(axi4_transaction tr);
    int beat = 0;
    forever begin
      @(posedge vif.aclk);
      if (vif.rvalid && vif.rready && vif.rid == tr.id) begin
        tr.data[beat] = vif.rdata;
        if (vif.rlast) break;
        beat++;
      end
    end
  endtask
  
endclass
