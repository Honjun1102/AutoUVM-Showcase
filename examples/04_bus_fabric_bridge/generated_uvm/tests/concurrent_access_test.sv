// AutoUVM自动生成 - 并发访问测试

class concurrent_access_test extends uvm_test;
  `uvm_component_utils(concurrent_access_test)
  
  system_env env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = system_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    cpu_random_seq    cpu_seq;
    dma_burst_seq     dma_seq;
    debug_reg_seq     debug_seq;
    
    phase.raise_objection(this);
    
    `uvm_info("TEST", "========================================", UVM_LOW)
    `uvm_info("TEST", "Starting Concurrent Access Test", UVM_LOW)
    `uvm_info("TEST", "========================================", UVM_LOW)
    
    // 创建序列
    cpu_seq   = cpu_random_seq::type_id::create("cpu_seq");
    dma_seq   = dma_burst_seq::type_id::create("dma_seq");
    debug_seq = debug_reg_seq::type_id::create("debug_seq");
    
    // 并发执行
    fork
      begin
        `uvm_info("TEST", "CPU: Accessing SRAM...", UVM_LOW)
        cpu_seq.start(env.cpu_master_agt.sqr);
      end
      
      begin
        #100ns;  // 延迟启动
        `uvm_info("TEST", "DMA: Burst transfer to GPIO...", UVM_LOW)
        dma_seq.start(env.dma_master_agt.sqr);
      end
      
      begin
        #200ns;  // 延迟启动
        `uvm_info("TEST", "Debug: Accessing Timer via Bridge...", UVM_LOW)
        debug_seq.start(env.debug_master_agt.sqr);
      end
    join
    
    #1us;  // 等待所有事务完成
    
    `uvm_info("TEST", "========================================", UVM_LOW)
    `uvm_info("TEST", "Concurrent Access Test Completed", UVM_LOW)
    `uvm_info("TEST", "========================================", UVM_LOW)
    
    phase.drop_objection(this);
  endtask
  
endclass
