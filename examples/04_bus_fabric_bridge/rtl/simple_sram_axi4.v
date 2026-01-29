// 简化的AXI4 SRAM Slave - 64KB
module simple_sram_axi4 #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter ID_WIDTH   = 4,
    parameter MEM_SIZE   = 16384  // 64KB / 4 bytes = 16K words
)(
    input wire aclk,
    input wire aresetn,
    
    // AXI4 Slave Interface (简化版，仅核心信号)
    input  wire [ID_WIDTH-1:0]   awid,
    input  wire [ADDR_WIDTH-1:0] awaddr,
    input  wire                  awvalid,
    output reg                   awready,
    
    input  wire [DATA_WIDTH-1:0] wdata,
    input  wire [3:0]            wstrb,
    input  wire                  wlast,
    input  wire                  wvalid,
    output reg                   wready,
    
    output reg  [ID_WIDTH-1:0]   bid,
    output reg  [1:0]            bresp,
    output reg                   bvalid,
    input  wire                  bready,
    
    input  wire [ID_WIDTH-1:0]   arid,
    input  wire [ADDR_WIDTH-1:0] araddr,
    input  wire                  arvalid,
    output reg                   arready,
    
    output reg  [ID_WIDTH-1:0]   rid,
    output reg  [DATA_WIDTH-1:0] rdata,
    output reg  [1:0]            rresp,
    output reg                   rlast,
    output reg                   rvalid,
    input  wire                  rready
);

    // SRAM存储
    reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];
    
    // 地址转换 (byte addr -> word addr)
    wire [15:0] wr_word_addr = awaddr[17:2];
    wire [15:0] rd_word_addr = araddr[17:2];
    
    // 写操作
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            awready <= 1'b0;
            wready  <= 1'b0;
            bvalid  <= 1'b0;
        end else begin
            // 简化握手
            awready <= awvalid;
            wready  <= wvalid;
            
            if (wvalid && wready) begin
                // 写入内存 (支持byte enable)
                if (wstrb[0]) mem[wr_word_addr][ 7: 0] <= wdata[ 7: 0];
                if (wstrb[1]) mem[wr_word_addr][15: 8] <= wdata[15: 8];
                if (wstrb[2]) mem[wr_word_addr][23:16] <= wdata[23:16];
                if (wstrb[3]) mem[wr_word_addr][31:24] <= wdata[31:24];
                
                bid    <= awid;
                bresp  <= 2'b00; // OKAY
                bvalid <= 1'b1;
            end
            
            if (bvalid && bready)
                bvalid <= 1'b0;
        end
    end
    
    // 读操作
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            arready <= 1'b0;
            rvalid  <= 1'b0;
        end else begin
            arready <= arvalid;
            
            if (arvalid && arready) begin
                rid    <= arid;
                rdata  <= mem[rd_word_addr];
                rresp  <= 2'b00; // OKAY
                rlast  <= 1'b1;  // Single transfer
                rvalid <= 1'b1;
            end
            
            if (rvalid && rready)
                rvalid <= 1'b0;
        end
    end

endmodule
