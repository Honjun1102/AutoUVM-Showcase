// AutoUVM生成 - SPI Package
package spi_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  `include "agents/apb_transaction.sv"
  `include "agents/spi_transaction.sv"
  `include "agents/spi_apb_driver.sv"
  `include "agents/spi_apb_monitor.sv"
  `include "agents/spi_apb_agent.sv"
  `include "agents/spi_protocol_monitor.sv"
  `include "agents/spi_scoreboard.sv"
  `include "env/spi_env.sv"
  `include "sequences/spi_basic_seq.sv"
  `include "tests/spi_basic_test.sv"
endpackage
