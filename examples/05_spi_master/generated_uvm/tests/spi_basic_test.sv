// AutoUVM生成 - SPI基础测试
class spi_basic_test extends uvm_test;
  `uvm_component_utils(spi_basic_test)
  
  spi_env env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = spi_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    spi_basic_seq seq;
    
    phase.raise_objection(this);
    `uvm_info("TEST", "Starting SPI Basic Test", UVM_LOW)
    
    seq = spi_basic_seq::type_id::create("seq");
    seq.num_trans = 10;
    seq.start(env.apb_agt.sqr);
    
    #5us;
    `uvm_info("TEST", "SPI Basic Test Completed", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass
