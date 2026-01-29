// AutoUVM自动生成 - 地址解码测试

class address_decode_test extends uvm_test;
  `uvm_component_utils(address_decode_test)
  
  system_env env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = system_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    address_sweep_seq cpu_seq;
    
    phase.raise_objection(this);
    
    `uvm_info("TEST", "========================================", UVM_LOW)
    `uvm_info("TEST", "Address Decode Test", UVM_LOW)
    `uvm_info("TEST", "========================================", UVM_LOW)
    
    // 扫描SRAM地址空间
    `uvm_info("TEST", "Sweeping SRAM address space...", UVM_LOW)
    cpu_seq = address_sweep_seq::type_id::create("sram_sweep");
    cpu_seq.start_addr = 32'h0000_0000;
    cpu_seq.end_addr   = 32'h0000_1000;
    cpu_seq.step       = 4;
    cpu_seq.start(env.cpu_master_agt.sqr);
    
    #200ns;
    
    // 扫描GPIO地址空间
    `uvm_info("TEST", "Sweeping GPIO address space...", UVM_LOW)
    cpu_seq = address_sweep_seq::type_id::create("gpio_sweep");
    cpu_seq.start_addr = 32'h1000_0000;
    cpu_seq.end_addr   = 32'h1000_0100;
    cpu_seq.step       = 4;
    cpu_seq.start(env.cpu_master_agt.sqr);
    
    #200ns;
    
    // 扫描Timer地址空间
    `uvm_info("TEST", "Sweeping Timer address space...", UVM_LOW)
    cpu_seq = address_sweep_seq::type_id::create("timer_sweep");
    cpu_seq.start_addr = 32'h2000_0000;
    cpu_seq.end_addr   = 32'h2000_0040;
    cpu_seq.step       = 4;
    cpu_seq.start(env.cpu_master_agt.sqr);
    
    #500ns;
    
    `uvm_info("TEST", "Address Decode Test Completed", UVM_LOW)
    phase.drop_objection(this);
  endtask
  
endclass
