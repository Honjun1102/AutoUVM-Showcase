// AutoUVM自动生成 - Testbench Top

module tb_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  // 时钟和复位
  logic aclk;
  logic aresetn;
  logic pclk;
  logic presetn;
  
  // 接口实例
  axi4_if cpu_axi_if(aclk, aresetn);
  axi4_if dma_axi_if(aclk, aresetn);
  axi4_if sram_axi_if(aclk, aresetn);
  apb_if  timer_apb_if(pclk, presetn);
  
  // DUT实例
  axi4_crossbar_2x3 u_crossbar (
    .aclk(aclk),
    .aresetn(aresetn),
    // Master 0: CPU (连接到接口)
    .m0_awid(cpu_axi_if.awid),
    .m0_awaddr(cpu_axi_if.awaddr),
    // ... 其他信号连接
    // Slave 0: SRAM (连接到接口)
    .s0_awid(sram_axi_if.awid),
    .s0_awaddr(sram_axi_if.awaddr)
    // ... 其他信号连接
  );
  
  // Bridge实例
  axi2apb_bridge u_bridge (
    .aclk(aclk),
    .aresetn(aresetn),
    // AXI4侧连接到Crossbar
    // APB侧连接到Timer
    .paddr(timer_apb_if.paddr),
    .pwrite(timer_apb_if.pwrite)
    // ... 其他信号连接
  );
  
  // SRAM实例
  simple_sram_axi4 u_sram (
    .aclk(aclk),
    .aresetn(aresetn),
    .awid(sram_axi_if.awid),
    .awaddr(sram_axi_if.awaddr)
    // ... 其他信号连接
  );
  
  // Timer实例
  simple_timer_apb u_timer (
    .pclk(pclk),
    .presetn(presetn),
    .paddr(timer_apb_if.paddr),
    .pwrite(timer_apb_if.pwrite)
    // ... 其他信号连接
  );
  
  // 时钟生成
  initial begin
    aclk = 0;
    forever #5ns aclk = ~aclk;  // 100MHz
  end
  
  initial begin
    pclk = 0;
    forever #10ns pclk = ~pclk;  // 50MHz
  end
  
  // 复位
  initial begin
    aresetn = 0;
    presetn = 0;
    #100ns;
    aresetn = 1;
    presetn = 1;
  end
  
  // UVM初始化
  initial begin
    // 将接口传递给UVM
    uvm_config_db#(virtual axi4_if)::set(null, "uvm_test_top.env.cpu_master_agt*", "vif", cpu_axi_if);
    uvm_config_db#(virtual axi4_if)::set(null, "uvm_test_top.env.dma_master_agt*", "vif", dma_axi_if);
    uvm_config_db#(virtual axi4_if)::set(null, "uvm_test_top.env.sram_slave_agt*", "vif", sram_axi_if);
    uvm_config_db#(virtual apb_if)::set(null, "uvm_test_top.env.timer_slave_agt*", "vif", timer_apb_if);
    
    // 运行测试
    run_test();
  end
  
  // 波形dump
  initial begin
    $fsdbDumpfile("waves.fsdb");
    $fsdbDumpvars(0, tb_top);
  end
  
endmodule
