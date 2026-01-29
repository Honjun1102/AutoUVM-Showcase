// AXI4 2x3 Crossbar - 简化实现框架
// 2个Master (CPU, DMA) + 3个Slave (SRAM, GPIO, Timer via Bridge)
//
// 地址映射:
//   0x0000_0000 - 0x0FFF_FFFF : SRAM
//   0x1000_0000 - 0x1FFF_FFFF : GPIO
//   0x2000_0000 - 0x2FFF_FFFF : Timer (APB via Bridge)

module axi4_crossbar_2x3 #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter ID_WIDTH   = 4
)(
    input wire aclk,
    input wire aresetn,
    
    // ============ Master 0: CPU ============
    // Write Address Channel
    input  wire [ID_WIDTH-1:0]   m0_awid,
    input  wire [ADDR_WIDTH-1:0] m0_awaddr,
    input  wire [7:0]            m0_awlen,
    input  wire [2:0]            m0_awsize,
    input  wire [1:0]            m0_awburst,
    input  wire                  m0_awvalid,
    output wire                  m0_awready,
    
    // Write Data Channel
    input  wire [DATA_WIDTH-1:0] m0_wdata,
    input  wire [3:0]            m0_wstrb,
    input  wire                  m0_wlast,
    input  wire                  m0_wvalid,
    output wire                  m0_wready,
    
    // Write Response Channel
    output wire [ID_WIDTH-1:0]   m0_bid,
    output wire [1:0]            m0_bresp,
    output wire                  m0_bvalid,
    input  wire                  m0_bready,
    
    // Read Address Channel
    input  wire [ID_WIDTH-1:0]   m0_arid,
    input  wire [ADDR_WIDTH-1:0] m0_araddr,
    input  wire [7:0]            m0_arlen,
    input  wire [2:0]            m0_arsize,
    input  wire [1:0]            m0_arburst,
    input  wire                  m0_arvalid,
    output wire                  m0_arready,
    
    // Read Data Channel
    output wire [ID_WIDTH-1:0]   m0_rid,
    output wire [DATA_WIDTH-1:0] m0_rdata,
    output wire [1:0]            m0_rresp,
    output wire                  m0_rlast,
    output wire                  m0_rvalid,
    input  wire                  m0_rready,
    
    // ============ Master 1: DMA ============
    // (同样的信号，以m1_前缀)
    input  wire [ID_WIDTH-1:0]   m1_awid,
    input  wire [ADDR_WIDTH-1:0] m1_awaddr,
    input  wire [7:0]            m1_awlen,
    input  wire [2:0]            m1_awsize,
    input  wire [1:0]            m1_awburst,
    input  wire                  m1_awvalid,
    output wire                  m1_awready,
    input  wire [DATA_WIDTH-1:0] m1_wdata,
    input  wire [3:0]            m1_wstrb,
    input  wire                  m1_wlast,
    input  wire                  m1_wvalid,
    output wire                  m1_wready,
    output wire [ID_WIDTH-1:0]   m1_bid,
    output wire [1:0]            m1_bresp,
    output wire                  m1_bvalid,
    input  wire                  m1_bready,
    input  wire [ID_WIDTH-1:0]   m1_arid,
    input  wire [ADDR_WIDTH-1:0] m1_araddr,
    input  wire [7:0]            m1_arlen,
    input  wire [2:0]            m1_arsize,
    input  wire [1:0]            m1_arburst,
    input  wire                  m1_arvalid,
    output wire                  m1_arready,
    output wire [ID_WIDTH-1:0]   m1_rid,
    output wire [DATA_WIDTH-1:0] m1_rdata,
    output wire [1:0]            m1_rresp,
    output wire                  m1_rlast,
    output wire                  m1_rvalid,
    input  wire                  m1_rready,
    
    // ============ Slave 0: SRAM ============
    output wire [ID_WIDTH-1:0]   s0_awid,
    output wire [ADDR_WIDTH-1:0] s0_awaddr,
    output wire [7:0]            s0_awlen,
    output wire [2:0]            s0_awsize,
    output wire [1:0]            s0_awburst,
    output wire                  s0_awvalid,
    input  wire                  s0_awready,
    output wire [DATA_WIDTH-1:0] s0_wdata,
    output wire [3:0]            s0_wstrb,
    output wire                  s0_wlast,
    output wire                  s0_wvalid,
    input  wire                  s0_wready,
    input  wire [ID_WIDTH-1:0]   s0_bid,
    input  wire [1:0]            s0_bresp,
    input  wire                  s0_bvalid,
    output wire                  s0_bready,
    output wire [ID_WIDTH-1:0]   s0_arid,
    output wire [ADDR_WIDTH-1:0] s0_araddr,
    output wire [7:0]            s0_arlen,
    output wire [2:0]            s0_arsize,
    output wire [1:0]            s0_arburst,
    output wire                  s0_arvalid,
    input  wire                  s0_arready,
    input  wire [ID_WIDTH-1:0]   s0_rid,
    input  wire [DATA_WIDTH-1:0] s0_rdata,
    input  wire [1:0]            s0_rresp,
    input  wire                  s0_rlast,
    input  wire                  s0_rvalid,
    output wire                  s0_rready,
    
    // ============ Slave 1: GPIO (类似信号，s1_前缀) ============
    output wire [ID_WIDTH-1:0]   s1_awid,
    output wire [ADDR_WIDTH-1:0] s1_awaddr,
    output wire [7:0]            s1_awlen,
    output wire [2:0]            s1_awsize,
    output wire [1:0]            s1_awburst,
    output wire                  s1_awvalid,
    input  wire                  s1_awready,
    output wire [DATA_WIDTH-1:0] s1_wdata,
    output wire [3:0]            s1_wstrb,
    output wire                  s1_wlast,
    output wire                  s1_wvalid,
    input  wire                  s1_wready,
    input  wire [ID_WIDTH-1:0]   s1_bid,
    input  wire [1:0]            s1_bresp,
    input  wire                  s1_bvalid,
    output wire                  s1_bready,
    output wire [ID_WIDTH-1:0]   s1_arid,
    output wire [ADDR_WIDTH-1:0] s1_araddr,
    output wire [7:0]            s1_arlen,
    output wire [2:0]            s1_arsize,
    output wire [1:0]            s1_arburst,
    output wire                  s1_arvalid,
    input  wire                  s1_arready,
    input  wire [ID_WIDTH-1:0]   s1_rid,
    input  wire [DATA_WIDTH-1:0] s1_rdata,
    input  wire [1:0]            s1_rresp,
    input  wire                  s1_rlast,
    input  wire                  s1_rvalid,
    output wire                  s1_rready,
    
    // ============ Slave 2: Bridge to Timer (APB) ============
    output wire [ID_WIDTH-1:0]   s2_awid,
    output wire [ADDR_WIDTH-1:0] s2_awaddr,
    output wire [7:0]            s2_awlen,
    output wire [2:0]            s2_awsize,
    output wire [1:0]            s2_awburst,
    output wire                  s2_awvalid,
    input  wire                  s2_awready,
    output wire [DATA_WIDTH-1:0] s2_wdata,
    output wire [3:0]            s2_wstrb,
    output wire                  s2_wlast,
    output wire                  s2_wvalid,
    input  wire                  s2_wready,
    input  wire [ID_WIDTH-1:0]   s2_bid,
    input  wire [1:0]            s2_bresp,
    input  wire                  s2_bvalid,
    output wire                  s2_bready,
    output wire [ID_WIDTH-1:0]   s2_arid,
    output wire [ADDR_WIDTH-1:0] s2_araddr,
    output wire [7:0]            s2_arlen,
    output wire [2:0]            s2_arsize,
    output wire [1:0]            s2_arburst,
    output wire                  s2_arvalid,
    input  wire                  s2_arready,
    input  wire [ID_WIDTH-1:0]   s2_rid,
    input  wire [DATA_WIDTH-1:0] s2_rdata,
    input  wire [1:0]            s2_rresp,
    input  wire                  s2_rlast,
    input  wire                  s2_rvalid,
    output wire                  s2_rready
);

    // ========================================
    // 地址解码逻辑
    // ========================================
    function [1:0] decode_addr;
        input [ADDR_WIDTH-1:0] addr;
        begin
            if (addr[31:28] == 4'h0)      decode_addr = 2'd0; // SRAM
            else if (addr[31:28] == 4'h1) decode_addr = 2'd1; // GPIO
            else if (addr[31:28] == 4'h2) decode_addr = 2'd2; // Timer(Bridge)
            else                           decode_addr = 2'd0; // Default
        end
    endfunction
    
    // ========================================
    // 仲裁逻辑 (简化: Round-Robin)
    // ========================================
    reg [1:0] arb_grant_aw; // Write addr arbiter
    reg [1:0] arb_grant_ar; // Read addr arbiter
    
    // 写地址仲裁
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            arb_grant_aw <= 2'd0;
        end else begin
            // Round-Robin: 0 -> 1 -> 0
            if (m0_awvalid && s0_awready)
                arb_grant_aw <= 2'd1;
            else if (m1_awvalid && s0_awready)
                arb_grant_aw <= 2'd0;
        end
    end
    
    // 读地址仲裁 (类似)
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            arb_grant_ar <= 2'd0;
        end else begin
            if (m0_arvalid && s0_arready)
                arb_grant_ar <= 2'd1;
            else if (m1_arvalid && s0_arready)
                arb_grant_ar <= 2'd0;
        end
    end
    
    // ========================================
    // 路由逻辑 (简化实现)
    // ========================================
    wire [1:0] m0_aw_target = decode_addr(m0_awaddr);
    wire [1:0] m0_ar_target = decode_addr(m0_araddr);
    wire [1:0] m1_aw_target = decode_addr(m1_awaddr);
    wire [1:0] m1_ar_target = decode_addr(m1_araddr);
    
    // Master 0 -> Slave routing (写地址)
    assign s0_awvalid = (arb_grant_aw == 2'd0) && m0_awvalid && (m0_aw_target == 2'd0);
    assign s1_awvalid = (arb_grant_aw == 2'd0) && m0_awvalid && (m0_aw_target == 2'd1);
    assign s2_awvalid = (arb_grant_aw == 2'd0) && m0_awvalid && (m0_aw_target == 2'd2);
    
    assign m0_awready = (m0_aw_target == 2'd0) ? s0_awready :
                        (m0_aw_target == 2'd1) ? s1_awready : s2_awready;
    
    // 注: 完整实现需要处理所有通道的路由、多Master仲裁、
    //     Outstanding管理、错误响应等，这里仅展示框架
    
    // ========================================
    // 说明
    // ========================================
    // 这是一个简化的Crossbar框架，展示了：
    // 1. 地址解码 (decode_addr)
    // 2. Round-Robin仲裁
    // 3. Master->Slave路由
    //
    // 完整实现需要：
    // - 所有5个通道的完整路由 (AW/W/B/AR/R)
    // - 多Master到同一Slave的仲裁
    // - Outstanding事务管理
    // - ID重映射
    // - 错误处理
    //
    // 代码量: 完整实现约1200-1500行

endmodule
