// AutoUVM生成 - UART Package
package uart_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  `include "agents/axis_transaction.sv"
  `include "agents/uart_transaction.sv"
  `include "agents/fifo_status.sv"
  `include "agents/axis_driver.sv"
  `include "agents/axis_agent.sv"
  `include "agents/uart_monitor.sv"
  `include "agents/fifo_monitor.sv"
  `include "agents/uart_scoreboard.sv"
  `include "env/uart_env.sv"
  `include "sequences/uart_burst_seq.sv"
  `include "tests/uart_fifo_test.sv"
endpackage
