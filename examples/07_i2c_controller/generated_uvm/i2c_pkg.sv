// AutoUVM生成 - I2C Package
package i2c_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  `include "agents/reg_transaction.sv"
  `include "agents/i2c_transaction.sv"
  `include "agents/i2c_reg_driver.sv"
  `include "agents/i2c_reg_agent.sv"
  `include "agents/i2c_protocol_monitor.sv"
  `include "agents/i2c_scoreboard.sv"
  `include "env/i2c_env.sv"
  `include "sequences/i2c_write_seq.sv"
  `include "sequences/i2c_read_seq.sv"
  `include "tests/i2c_basic_test.sv"
endpackage
