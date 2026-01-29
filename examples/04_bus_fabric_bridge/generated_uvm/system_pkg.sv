// AutoUVM自动生成 - System Package
// 包含所有UVM组件

package system_pkg;
  
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  // ========== Interfaces ==========
  // (接口在包外定义，在tb_top中实例化)
  
  // ========== Transactions ==========
  `include "interfaces/apb_transaction.sv"
  
  // ========== CPU Master Agent ==========
  `include "agents/cpu_axi4_master_agent/cpu_axi4_transaction.sv"
  `include "agents/cpu_axi4_master_agent/cpu_axi4_sequencer.sv"
  `include "agents/cpu_axi4_master_agent/cpu_axi4_driver.sv"
  `include "agents/cpu_axi4_master_agent/cpu_axi4_monitor.sv"
  `include "agents/cpu_axi4_master_agent/cpu_axi4_agent.sv"
  
  // ========== DMA Master Agent ==========
  `include "agents/dma_axi4_master_agent/dma_axi4_agent.sv"
  
  // ========== Debug Master Agent ==========
  `include "agents/debug_axi4_master_agent/debug_axi4_agent.sv"
  
  // ========== SRAM Slave Agent ==========
  `include "agents/sram_axi4_slave_agent/sram_slave_monitor.sv"
  `include "agents/sram_axi4_slave_agent/sram_slave_agent.sv"
  
  // ========== GPIO Slave Agent ==========
  `include "agents/gpio_axi4_slave_agent/gpio_slave_agent.sv"
  
  // ========== Timer Slave Agent ==========
  `include "agents/timer_apb_slave_agent/timer_apb_monitor.sv"
  `include "agents/timer_apb_slave_agent/timer_apb_agent.sv"
  
  // ========== Bridge Monitor Agent ==========
  `include "agents/bridge_monitor_agent/bridge_monitor.sv"
  `include "agents/bridge_monitor_agent/bridge_monitor_agent.sv"
  
  // ========== Scoreboard ==========
  `include "scoreboard/fabric_scoreboard.sv"
  
  // ========== Environment ==========
  `include "env/system_env.sv"
  
  // ========== Sequences ==========
  `include "sequences/cpu_random_seq.sv"
  `include "sequences/dma_burst_seq.sv"
  `include "sequences/debug_reg_seq.sv"
  
  // ========== Tests ==========
  `include "tests/concurrent_access_test.sv"
  
endpackage

