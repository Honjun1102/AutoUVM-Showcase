// AutoUVM自动生成 - Outstanding事务测试

class outstanding_test extends uvm_test;
  `uvm_component_utils(outstanding_test)
  
  system_env env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = system_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    outstanding_seq cpu_seq, dma_seq;
    
    phase.raise_objection(this);
    
    `uvm_info("TEST", "========================================", UVM_LOW)
    `uvm_info("TEST", "Outstanding Transactions Test", UVM_LOW)
    `uvm_info("TEST", "========================================", UVM_LOW)
    
    cpu_seq = outstanding_seq::type_id::create("cpu_seq");
    dma_seq = outstanding_seq::type_id::create("dma_seq");
    
    fork
      begin
        cpu_seq.num_outstanding = 8;
        cpu_seq.num_rounds = 10;
        cpu_seq.start(env.cpu_master_agt.sqr);
      end
      
      begin
        #200ns;
        dma_seq.num_outstanding = 6;
        dma_seq.num_rounds = 8;
        dma_seq.start(env.dma_master_agt.sqr);
      end
    join
    
    #1us;
    
    `uvm_info("TEST", "Outstanding Test Completed", UVM_LOW)
    phase.drop_objection(this);
  endtask
  
endclass
