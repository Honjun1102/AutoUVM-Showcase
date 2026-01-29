// AutoUVM生成 - I2C Environment
class i2c_env extends uvm_env;
  `uvm_component_utils(i2c_env)
  
  i2c_reg_agent       reg_agt;
  i2c_protocol_monitor i2c_mon;
  i2c_scoreboard      sb;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    reg_agt = i2c_reg_agent::type_id::create("reg_agt", this);
    reg_agt.is_active = UVM_ACTIVE;
    i2c_mon = i2c_protocol_monitor::type_id::create("i2c_mon", this);
    sb = i2c_scoreboard::type_id::create("sb", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    i2c_mon.ap.connect(sb.i2c_export);
  endfunction
endclass
