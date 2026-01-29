// AutoUVM生成 - Testbench Top
module tb_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  logic clk;
  logic rst_n;
  
  // 接口实例
  axis_if axis_vif(clk, rst_n);
  uart_if uart_vif(clk);
  fifo_status_if fifo_vif(clk);
  
  // DUT实例
  uart_tx_top dut (
    .clk(clk),
    .rst_n(rst_n),
    .s_axis_tdata(axis_vif.tdata),
    .s_axis_tvalid(axis_vif.tvalid),
    .s_axis_tready(axis_vif.tready),
    .uart_tx(uart_vif.uart_tx),
    .fifo_full(fifo_vif.full),
    .fifo_empty(fifo_vif.empty),
    .fifo_count(fifo_vif.count)
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
    uvm_config_db#(virtual axis_if)::set(null, "uvm_test_top.env.axis_agt*", "vif", axis_vif);
    uvm_config_db#(virtual uart_if)::set(null, "uvm_test_top.env.uart_mon*", "vif", uart_vif);
    uvm_config_db#(virtual fifo_status_if)::set(null, "uvm_test_top.env.fifo_mon*", "vif", fifo_vif);
    run_test();
  end
  
endmodule
