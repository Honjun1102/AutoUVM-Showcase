// AutoUVM生成 - Testbench Top
module tb_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  logic clk;
  logic rst_n;
  
  // 接口实例
  reg_if reg_vif(clk, rst_n);
  i2c_if i2c_vif(clk);
  
  // DUT实例
  i2c_master_ctrl dut (
    .clk(clk),
    .rst_n(rst_n),
    .reg_wr(reg_vif.reg_wr),
    .reg_rd(reg_vif.reg_rd),
    .reg_addr(reg_vif.reg_addr),
    .reg_wdata(reg_vif.reg_wdata),
    .reg_rdata(reg_vif.reg_rdata),
    .reg_ready(reg_vif.reg_ready),
    .scl_out(i2c_vif.scl_out),
    .scl_oe(i2c_vif.scl_oe),
    .scl_in(i2c_vif.scl_in),
    .sda_out(i2c_vif.sda_out),
    .sda_oe(i2c_vif.sda_oe),
    .sda_in(i2c_vif.sda_in),
    .irq()
  );
  
  // 时钟生成 (50MHz)
  initial begin
    clk = 0;
    forever #10ns clk = ~clk;
  end
  
  // 复位
  initial begin
    rst_n = 0;
    #100ns;
    rst_n = 1;
  end
  
  // UVM配置
  initial begin
    uvm_config_db#(virtual reg_if)::set(null, "uvm_test_top.env.reg_agt*", "vif", reg_vif);
    uvm_config_db#(virtual i2c_if)::set(null, "uvm_test_top.env.i2c_mon*", "vif", i2c_vif);
    run_test();
  end
  
endmodule
