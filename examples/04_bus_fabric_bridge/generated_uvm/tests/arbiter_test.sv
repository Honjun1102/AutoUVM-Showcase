// AutoUVM自动生成 - 仲裁器优先级测试

class arbiter_test extends uvm_test;
  `uvm_component_utils(arbiter_test)
  
  system_env env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = system_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    back2back_seq cpu_seq, dma_seq, debug_seq;
    
    phase.raise_objection(this);
    
    `uvm_info("TEST", "========================================", UVM_LOW)
    `uvm_info("TEST", "Arbiter Priority Test", UVM_LOW)
    `uvm_info("TEST", "========================================", UVM_LOW)
    
    cpu_seq   = back2back_seq::type_id::create("cpu_seq");
    dma_seq   = back2back_seq::type_id::create("dma_seq");
    debug_seq = back2back_seq::type_id::create("debug_seq");
    
    // 三个Master同时竞争，测试仲裁
    fork
      begin
        cpu_seq.num_trans = 100;
        cpu_seq.base_addr = 32'h0000_0000;  // 访问SRAM
        cpu_seq.start(env.cpu_master_agt.sqr);
      end
      
      begin
        dma_seq.num_trans = 100;
        dma_seq.base_addr = 32'h1000_0000;  // 访问GPIO
        dma_seq.start(env.dma_master_agt.sqr);
      end
      
      begin
        debug_seq.num_trans = 50;
        debug_seq.base_addr = 32'h2000_0000;  // 访问Timer
        debug_seq.start(env.debug_master_agt.sqr);
      end
    join
    
    #1us;
    
    `uvm_info("TEST", "Arbiter Test Completed", UVM_LOW)
    phase.drop_objection(this);
  endtask
  
endclass
