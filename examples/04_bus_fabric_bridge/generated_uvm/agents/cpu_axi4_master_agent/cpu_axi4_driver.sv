// AutoUVM自动生成 - CPU Master Driver
// 支持AXI4完整协议，包括Outstanding事务

class cpu_axi4_driver extends uvm_driver #(axi4_transaction);
  `uvm_component_utils(cpu_axi4_driver)
  
  virtual axi4_if vif;
  
  // Outstanding事务跟踪
  axi4_transaction outstanding_write_addr[$];
  axi4_transaction outstanding_write_data[$];
  axi4_transaction outstanding_read_addr[$];
  
  // 配置
  int max_outstanding = 8;
  int wr_timeout_cycles = 1000;
  int rd_timeout_cycles = 1000;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi4_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not found")
  endfunction
  
  task run_phase(uvm_phase phase);
    fork
      drive_write_addr_channel();
      drive_write_data_channel();
      collect_write_response();
      drive_read_addr_channel();
      collect_read_data();
    join
  endtask
  
  // ============================================
  // 写地址通道驱动
  // ============================================
  task drive_write_addr_channel();
    axi4_transaction tr;
    forever begin
      seq_item_port.get_next_item(tr);
      
      if (tr.dir == WRITE) begin
        // 等待total outstanding不超过限制
        wait_for_outstanding_space();
        
        // 驱动AW通道
        @(posedge vif.aclk);
        vif.awid    <= tr.id;
        vif.awaddr  <= tr.addr;
        vif.awlen   <= tr.len;
        vif.awsize  <= tr.size;
        vif.awburst <= tr.burst;
        vif.awvalid <= 1'b1;
        
        // 等待握手
        @(posedge vif.aclk iff vif.awready);
        vif.awvalid <= 1'b0;
        
        // 记录Outstanding
        outstanding_write_addr.push_back(tr);
        
        `uvm_info("CPU_DRV", $sformatf("AW: id=%0d addr=0x%08x len=%0d", 
                  tr.id, tr.addr, tr.len), UVM_MEDIUM)
      end
      
      seq_item_port.item_done();
    end
  endtask
  
  // ============================================
  // 写数据通道驱动
  // ============================================
  task drive_write_data_channel();
    axi4_transaction tr;
    int beat;
    forever begin
      // 从队列获取
      wait(outstanding_write_addr.size() > 0);
      tr = outstanding_write_addr.pop_front();
      
      // 驱动所有beat
      for (beat = 0; beat <= tr.len; beat++) begin
        @(posedge vif.aclk);
        vif.wdata  <= tr.data[beat];
        vif.wstrb  <= tr.strb[beat];
        vif.wlast  <= (beat == tr.len);
        vif.wvalid <= 1'b1;
        
        // 等待握手
        @(posedge vif.aclk iff vif.wready);
      end
      
      vif.wvalid <= 1'b0;
      outstanding_write_data.push_back(tr);
      
      `uvm_info("CPU_DRV", $sformatf("W: id=%0d beats=%0d", 
                tr.id, beat), UVM_MEDIUM)
    end
  endtask
  
  // ============================================
  // 写响应收集
  // ============================================
  task collect_write_response();
    axi4_transaction tr;
    int timeout_cnt;
    
    forever begin
      @(posedge vif.aclk);
      
      if (vif.bvalid && vif.bready) begin
        // 找到对应的事务
        foreach (outstanding_write_data[i]) begin
          if (outstanding_write_data[i].id == vif.bid) begin
            tr = outstanding_write_data[i];
            tr.resp = vif.bresp;
            outstanding_write_data.delete(i);
            
            `uvm_info("CPU_DRV", $sformatf("B: id=%0d resp=%0d", 
                      vif.bid, vif.bresp), UVM_MEDIUM)
            break;
          end
        end
      end
      
      // Timeout检测
      if (outstanding_write_data.size() > 0) begin
        timeout_cnt++;
        if (timeout_cnt > wr_timeout_cycles)
          `uvm_error("TIMEOUT", "Write response timeout")
      end else
        timeout_cnt = 0;
    end
  endtask
  
  // ============================================
  // 读地址通道驱动
  // ============================================
  task drive_read_addr_channel();
    axi4_transaction tr;
    forever begin
      seq_item_port.get_next_item(tr);
      
      if (tr.dir == READ) begin
        wait_for_outstanding_space();
        
        @(posedge vif.aclk);
        vif.arid    <= tr.id;
        vif.araddr  <= tr.addr;
        vif.arlen   <= tr.len;
        vif.arsize  <= tr.size;
        vif.arburst <= tr.burst;
        vif.arvalid <= 1'b1;
        
        @(posedge vif.aclk iff vif.arready);
        vif.arvalid <= 1'b0;
        
        outstanding_read_addr.push_back(tr);
        
        `uvm_info("CPU_DRV", $sformatf("AR: id=%0d addr=0x%08x len=%0d", 
                  tr.id, tr.addr, tr.len), UVM_MEDIUM)
      end
      
      seq_item_port.item_done();
    end
  endtask
  
  // ============================================
  // 读数据收集
  // ============================================
  task collect_read_data();
    axi4_transaction tr;
    int beat;
    int timeout_cnt;
    
    forever begin
      @(posedge vif.aclk);
      
      if (vif.rvalid && vif.rready) begin
        // 找到对应事务
        foreach (outstanding_read_addr[i]) begin
          if (outstanding_read_addr[i].id == vif.rid) begin
            tr = outstanding_read_addr[i];
            tr.data[beat] = vif.rdata;
            tr.resp = vif.rresp;
            
            if (vif.rlast) begin
              outstanding_read_addr.delete(i);
              beat = 0;
              `uvm_info("CPU_DRV", $sformatf("R Complete: id=%0d", 
                        vif.rid), UVM_MEDIUM)
            end else
              beat++;
            
            break;
          end
        end
      end
      
      // Timeout检测
      if (outstanding_read_addr.size() > 0) begin
        timeout_cnt++;
        if (timeout_cnt > rd_timeout_cycles)
          `uvm_error("TIMEOUT", "Read data timeout")
      end else
        timeout_cnt = 0;
    end
  endtask
  
  // ============================================
  // 辅助函数
  // ============================================
  task wait_for_outstanding_space();
    wait((outstanding_write_addr.size() + outstanding_read_addr.size()) 
         < max_outstanding);
  endtask
  
endclass
