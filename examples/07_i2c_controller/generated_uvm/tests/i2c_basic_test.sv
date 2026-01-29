// AutoUVM生成 - I2C基础测试
class i2c_basic_test extends uvm_test;
  `uvm_component_utils(i2c_basic_test)
  
  i2c_env env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = i2c_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    i2c_write_seq wr_seq;
    i2c_read_seq  rd_seq;
    
    phase.raise_objection(this);
    `uvm_info("TEST", "Starting I2C Basic Test", UVM_LOW)
    
    // 写测试
    wr_seq = i2c_write_seq::type_id::create("wr_seq");
    wr_seq.slave_addr = 7'h50;
    wr_seq.data_bytes = new[5];
    foreach (wr_seq.data_bytes[i])
      wr_seq.data_bytes[i] = i * 10;
    wr_seq.start(env.reg_agt.sqr);
    
    #10us;
    
    // 读测试
    rd_seq = i2c_read_seq::type_id::create("rd_seq");
    rd_seq.slave_addr = 7'h50;
    rd_seq.num_bytes = 5;
    rd_seq.start(env.reg_agt.sqr);
    
    #20us;
    `uvm_info("TEST", "I2C Basic Test Completed", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass
