// AutoUVM自动生成 - 压力测试

class stress_test extends uvm_test;
  `uvm_component_utils(stress_test)
  
  system_env env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = system_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    stress_burst_seq  cpu_seq;
    stress_burst_seq  dma_seq;
    
    phase.raise_objection(this);
    
    `uvm_info("TEST", "========================================", UVM_LOW)
    `uvm_info("TEST", "Stress Test - High Load Scenario", UVM_LOW)
    `uvm_info("TEST", "========================================", UVM_LOW)
    
    cpu_seq = stress_burst_seq::type_id::create("cpu_seq");
    dma_seq = stress_burst_seq::type_id::create("dma_seq");
    
    // 两个Master同时高负载
    fork
      begin
        cpu_seq.num_trans = 200;
        cpu_seq.start(env.cpu_master_agt.sqr);
      end
      
      begin
        dma_seq.num_trans = 200;
        dma_seq.start(env.dma_master_agt.sqr);
      end
    join
    
    #2us;
    
    `uvm_info("TEST", "Stress Test Completed", UVM_LOW)
    phase.drop_objection(this);
  endtask
  
endclass
