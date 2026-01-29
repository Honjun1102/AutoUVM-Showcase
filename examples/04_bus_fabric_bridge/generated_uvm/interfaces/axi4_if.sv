// AutoUVM自动生成 - AXI4接口定义

interface axi4_if(input logic aclk, input logic aresetn);
  
  // Write Address Channel
  logic [3:0]   awid;
  logic [31:0]  awaddr;
  logic [7:0]   awlen;
  logic [2:0]   awsize;
  logic [1:0]   awburst;
  logic         awlock;
  logic [3:0]   awcache;
  logic [2:0]   awprot;
  logic [3:0]   awqos;
  logic [3:0]   awregion;
  logic         awvalid;
  logic         awready;
  
  // Write Data Channel
  logic [31:0]  wdata;
  logic [3:0]   wstrb;
  logic         wlast;
  logic         wvalid;
  logic         wready;
  
  // Write Response Channel
  logic [3:0]   bid;
  logic [1:0]   bresp;
  logic         bvalid;
  logic         bready;
  
  // Read Address Channel
  logic [3:0]   arid;
  logic [31:0]  araddr;
  logic [7:0]   arlen;
  logic [2:0]   arsize;
  logic [1:0]   arburst;
  logic         arlock;
  logic [3:0]   arcache;
  logic [2:0]   arprot;
  logic [3:0]   arqos;
  logic [3:0]   arregion;
  logic         arvalid;
  logic         arready;
  
  // Read Data Channel
  logic [3:0]   rid;
  logic [31:0]  rdata;
  logic [1:0]   rresp;
  logic         rlast;
  logic         rvalid;
  logic         rready;
  
  // Master Modport
  modport master (
    input  aclk, aresetn,
    output awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot, awqos, awregion, awvalid,
    input  awready,
    output wdata, wstrb, wlast, wvalid,
    input  wready,
    input  bid, bresp, bvalid,
    output bready,
    output arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot, arqos, arregion, arvalid,
    input  arready,
    input  rid, rdata, rresp, rlast, rvalid,
    output rready
  );
  
  // Slave Modport
  modport slave (
    input  aclk, aresetn,
    input  awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot, awqos, awregion, awvalid,
    output awready,
    input  wdata, wstrb, wlast, wvalid,
    output wready,
    output bid, bresp, bvalid,
    input  bready,
    input  arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot, arqos, arregion, arvalid,
    output arready,
    output rid, rdata, rresp, rlast, rvalid,
    input  rready
  );
  
  // Monitor Modport (只读)
  modport monitor (
    input aclk, aresetn,
    input awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot, awqos, awregion, awvalid, awready,
    input wdata, wstrb, wlast, wvalid, wready,
    input bid, bresp, bvalid, bready,
    input arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot, arqos, arregion, arvalid, arready,
    input rid, rdata, rresp, rlast, rvalid, rready
  );
  
  // Clocking Block for Driver
  clocking drv_cb @(posedge aclk);
    default input #1 output #1;
    output awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot, awqos, awregion, awvalid;
    input  awready;
    output wdata, wstrb, wlast, wvalid;
    input  wready;
    input  bid, bresp, bvalid;
    output bready;
    output arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot, arqos, arregion, arvalid;
    input  arready;
    input  rid, rdata, rresp, rlast, rvalid;
    output rready;
  endclocking
  
  // Clocking Block for Monitor
  clocking mon_cb @(posedge aclk);
    default input #1;
    input awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot, awqos, awregion, awvalid, awready;
    input wdata, wstrb, wlast, wvalid, wready;
    input bid, bresp, bvalid, bready;
    input arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot, arqos, arregion, arvalid, arready;
    input rid, rdata, rresp, rlast, rvalid, rready;
  endclocking
  
  // 辅助任务: 等待复位释放
  task wait_for_reset();
    @(posedge aresetn);
    @(posedge aclk);
  endtask
  
  // 辅助任务: 等待N个时钟
  task wait_clocks(int num);
    repeat(num) @(posedge aclk);
  endtask
  
endinterface

