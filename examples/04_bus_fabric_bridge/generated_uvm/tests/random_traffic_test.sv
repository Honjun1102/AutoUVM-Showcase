// AutoUVM自动生成 - 随机流量测试

class random_traffic_test extends uvm_test;
  `uvm_component_utils(random_traffic_test)
  
  system_env env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = system_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    random_delay_seq cpu_seq, dma_seq, debug_seq;
    
    phase.raise_objection(this);
    
    `uvm_info("TEST", "========================================", UVM_LOW)
    `uvm_info("TEST", "Random Traffic Test", UVM_LOW)
    `uvm_info("TEST", "========================================", UVM_LOW)
    
    cpu_seq   = random_delay_seq::type_id::create("cpu_seq");
    dma_seq   = random_delay_seq::type_id::create("dma_seq");
    debug_seq = random_delay_seq::type_id::create("debug_seq");
    
    fork
      begin
        cpu_seq.num_trans = 50;
        cpu_seq.min_delay = 5;
        cpu_seq.max_delay = 50;
        cpu_seq.start(env.cpu_master_agt.sqr);
      end
      
      begin
        #100ns;
        dma_seq.num_trans = 40;
        dma_seq.min_delay = 10;
        dma_seq.max_delay = 100;
        dma_seq.start(env.dma_master_agt.sqr);
      end
      
      begin
        #250ns;
        debug_seq.num_trans = 30;
        debug_seq.min_delay = 20;
        debug_seq.max_delay = 150;
        debug_seq.start(env.debug_master_agt.sqr);
      end
    join
    
    #2us;
    
    `uvm_info("TEST", "Random Traffic Test Completed", UVM_LOW)
    phase.drop_objection(this);
  endtask
  
endclass
