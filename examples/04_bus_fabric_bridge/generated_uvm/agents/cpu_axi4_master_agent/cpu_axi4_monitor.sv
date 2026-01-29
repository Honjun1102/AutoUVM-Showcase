// AutoUVM自动生成 - CPU Master Monitor

class cpu_axi4_monitor extends uvm_monitor;
  `uvm_component_utils(cpu_axi4_monitor)
  
  virtual axi4_if vif;
  uvm_analysis_port #(axi4_transaction) ap;
  
  // 事务跟踪
  axi4_transaction write_addr_trans[int];  // Key: awid
  axi4_transaction read_addr_trans[int];   // Key: arid
  
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
      monitor_write_addr();
      monitor_write_data();
      monitor_write_resp();
      monitor_read_addr();
      monitor_read_data();
    join
  endtask
  
  // 监控写地址通道
  task monitor_write_addr();
    axi4_transaction tr;
    forever begin
      @(posedge vif.aclk);
      if (vif.awvalid && vif.awready) begin
        tr = axi4_transaction::type_id::create("wr_tr");
        tr.id    = vif.awid;
        tr.addr  = vif.awaddr;
        tr.len   = vif.awlen;
        tr.size  = vif.awsize;
        tr.burst = vif.awburst;
        tr.dir   = WRITE;
        tr.timestamp = $time;
        
        write_addr_trans[vif.awid] = tr;
        
        `uvm_info("CPU_MON", $sformatf("Captured AW: id=%0d addr=0x%08x", 
                  vif.awid, vif.awaddr), UVM_HIGH)
      end
    end
  endtask
  
  // 监控写数据通道
  task monitor_write_data();
    int beat_count[int];  // Key: wid (implicit)
    
    forever begin
      @(posedge vif.aclk);
      if (vif.wvalid && vif.wready) begin
        // 假设按顺序匹配（简化）
        // 完整实现需要WID匹配
        
        if (vif.wlast) begin
          `uvm_info("CPU_MON", "Captured W complete", UVM_HIGH)
        end
      end
    end
  endtask
  
  // 监控写响应
  task monitor_write_resp();
    axi4_transaction tr;
    forever begin
      @(posedge vif.aclk);
      if (vif.bvalid && vif.bready) begin
        if (write_addr_trans.exists(vif.bid)) begin
          tr = write_addr_trans[vif.bid];
          tr.resp = vif.bresp;
          tr.latency = ($time - tr.timestamp) / 1ns;
          
          // 发送到Analysis Port
          ap.write(tr);
          
          write_addr_trans.delete(vif.bid);
          
          `uvm_info("CPU_MON", $sformatf("Write Complete: id=%0d resp=%0d latency=%0d", 
                    vif.bid, vif.bresp, tr.latency), UVM_MEDIUM)
        end
      end
    end
  endtask
  
  // 监控读地址通道
  task monitor_read_addr();
    axi4_transaction tr;
    forever begin
      @(posedge vif.aclk);
      if (vif.arvalid && vif.arready) begin
        tr = axi4_transaction::type_id::create("rd_tr");
        tr.id    = vif.arid;
        tr.addr  = vif.araddr;
        tr.len   = vif.arlen;
        tr.size  = vif.arsize;
        tr.burst = vif.arburst;
        tr.dir   = READ;
        tr.timestamp = $time;
        
        read_addr_trans[vif.arid] = tr;
        
        `uvm_info("CPU_MON", $sformatf("Captured AR: id=%0d addr=0x%08x", 
                  vif.arid, vif.araddr), UVM_HIGH)
      end
    end
  endtask
  
  // 监控读数据
  task monitor_read_data();
    axi4_transaction tr;
    int beat;
    
    forever begin
      @(posedge vif.aclk);
      if (vif.rvalid && vif.rready) begin
        if (read_addr_trans.exists(vif.rid)) begin
          tr = read_addr_trans[vif.rid];
          tr.data[beat] = vif.rdata;
          tr.resp = vif.rresp;
          
          if (vif.rlast) begin
            tr.latency = ($time - tr.timestamp) / 1ns;
            ap.write(tr);
            read_addr_trans.delete(vif.rid);
            beat = 0;
            
            `uvm_info("CPU_MON", $sformatf("Read Complete: id=%0d latency=%0d", 
                      vif.rid, tr.latency), UVM_MEDIUM)
          end else
            beat++;
        end
      end
    end
  endtask
  
endclass
