// AutoUVM生成 - Testbench Top
module tb_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  logic clk;
  logic rst_n;
  
  // 接口实例
  apb_if apb_vif(clk, rst_n);
  spi_if spi_vif(clk);
  
  // DUT实例
  spi_master dut (
    .clk(clk),
    .rst_n(rst_n),
    .psel(apb_vif.psel),
    .penable(apb_vif.penable),
    .pwrite(apb_vif.pwrite),
    .paddr(apb_vif.paddr),
    .pwdata(apb_vif.pwdata),
    .prdata(apb_vif.prdata),
    .pready(apb_vif.pready),
    .spi_sclk(spi_vif.spi_sclk),
    .spi_mosi(spi_vif.spi_mosi),
    .spi_miso(spi_vif.spi_miso),
    .spi_cs_n(spi_vif.spi_cs_n),
    .irq()
  );
  
  // Slave模型
  spi_slave_model slave (
    .spi_sclk(spi_vif.spi_sclk),
    .spi_mosi(spi_vif.spi_mosi),
    .spi_miso(spi_vif.spi_miso),
    .spi_cs_n(spi_vif.spi_cs_n)
  );
  
  // 时钟生成
  initial begin
    clk = 0;
    forever #5ns clk = ~clk;
  end
  
  // 复位
  initial begin
    rst_n = 0;
    #100ns;
    rst_n = 1;
  end
  
  // UVM配置
  initial begin
    uvm_config_db#(virtual apb_if)::set(null, "uvm_test_top.env.apb_agt*", "vif", apb_vif);
    uvm_config_db#(virtual spi_if)::set(null, "uvm_test_top.env.spi_mon*", "vif", spi_vif);
    run_test();
  end
  
endmodule
