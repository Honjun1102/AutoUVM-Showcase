// AutoUVM自动生成 - APB接口定义

interface apb_if(input logic pclk, input logic presetn);
  
  // APB信号
  logic [31:0]  paddr;
  logic [2:0]   pprot;
  logic         psel;
  logic         penable;
  logic         pwrite;
  logic [31:0]  pwdata;
  logic [3:0]   pstrb;
  logic         pready;
  logic [31:0]  prdata;
  logic         pslverr;
  
  // Master Modport
  modport master (
    input  pclk, presetn,
    output paddr, pprot, psel, penable, pwrite, pwdata, pstrb,
    input  pready, prdata, pslverr
  );
  
  // Slave Modport
  modport slave (
    input  pclk, presetn,
    input  paddr, pprot, psel, penable, pwrite, pwdata, pstrb,
    output pready, prdata, pslverr
  );
  
  // Monitor Modport
  modport monitor (
    input pclk, presetn,
    input paddr, pprot, psel, penable, pwrite, pwdata, pstrb,
    input pready, prdata, pslverr
  );
  
  // Clocking Block for Driver
  clocking drv_cb @(posedge pclk);
    default input #1 output #1;
    output paddr, pprot, psel, penable, pwrite, pwdata, pstrb;
    input  pready, prdata, pslverr;
  endclocking
  
  // Clocking Block for Monitor
  clocking mon_cb @(posedge pclk);
    default input #1;
    input paddr, pprot, psel, penable, pwrite, pwdata, pstrb;
    input pready, prdata, pslverr;
  endclocking
  
  // 辅助任务
  task wait_for_reset();
    @(posedge presetn);
    @(posedge pclk);
  endtask
  
  task wait_clocks(int num);
    repeat(num) @(posedge pclk);
  endtask
  
  // APB事务完成检测
  task wait_for_transfer();
    @(posedge pclk);
    wait(psel && penable && pready);
    @(posedge pclk);
  endtask
  
endinterface

