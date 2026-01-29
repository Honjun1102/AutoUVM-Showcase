// AXI4-to-APB Protocol Bridge
// 将AXI4协议转换为APB协议

module axi2apb_bridge #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter ID_WIDTH   = 4
)(
    input wire aclk,
    input wire aresetn,
    
    // ============ AXI4 Slave Interface ============
    // Write Address Channel
    input  wire [ID_WIDTH-1:0]   s_awid,
    input  wire [ADDR_WIDTH-1:0] s_awaddr,
    input  wire [7:0]            s_awlen,
    input  wire [2:0]            s_awsize,
    input  wire [1:0]            s_awburst,
    input  wire                  s_awvalid,
    output reg                   s_awready,
    
    // Write Data Channel
    input  wire [DATA_WIDTH-1:0] s_wdata,
    input  wire [3:0]            s_wstrb,
    input  wire                  s_wlast,
    input  wire                  s_wvalid,
    output reg                   s_wready,
    
    // Write Response Channel
    output reg  [ID_WIDTH-1:0]   s_bid,
    output reg  [1:0]            s_bresp,
    output reg                   s_bvalid,
    input  wire                  s_bready,
    
    // Read Address Channel
    input  wire [ID_WIDTH-1:0]   s_arid,
    input  wire [ADDR_WIDTH-1:0] s_araddr,
    input  wire [7:0]            s_arlen,
    input  wire [2:0]            s_arsize,
    input  wire [1:0]            s_arburst,
    input  wire                  s_arvalid,
    output reg                   s_arready,
    
    // Read Data Channel
    output reg  [ID_WIDTH-1:0]   s_rid,
    output reg  [DATA_WIDTH-1:0] s_rdata,
    output reg  [1:0]            s_rresp,
    output reg                   s_rlast,
    output reg                   s_rvalid,
    input  wire                  s_rready,
    
    // ============ APB Master Interface ============
    output reg  [ADDR_WIDTH-1:0] paddr,
    output reg                   psel,
    output reg                   penable,
    output reg                   pwrite,
    output reg  [DATA_WIDTH-1:0] pwdata,
    output reg  [3:0]            pstrb,
    input  wire [DATA_WIDTH-1:0] prdata,
    input  wire                  pready,
    input  wire                  pslverr
);

    // ========================================
    // 状态机定义
    // ========================================
    localparam IDLE        = 3'd0;
    localparam WRITE_SETUP = 3'd1;
    localparam WRITE_ACC   = 3'd2;
    localparam WRITE_RESP  = 3'd3;
    localparam READ_SETUP  = 3'd4;
    localparam READ_ACC    = 3'd5;
    localparam READ_RESP   = 3'd6;
    
    reg [2:0] state, next_state;
    
    // ========================================
    // 事务缓存 (Outstanding支持)
    // ========================================
    reg [ID_WIDTH-1:0]   trans_id;
    reg [ADDR_WIDTH-1:0] trans_addr;
    reg [DATA_WIDTH-1:0] trans_wdata;
    reg [3:0]            trans_wstrb;
    
    // ========================================
    // 状态机 - 当前状态
    // ========================================
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    // ========================================
    // 状态机 - 下一状态逻辑
    // ========================================
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (s_awvalid && s_wvalid)
                    next_state = WRITE_SETUP;
                else if (s_arvalid)
                    next_state = READ_SETUP;
            end
            
            WRITE_SETUP: begin
                next_state = WRITE_ACC;
            end
            
            WRITE_ACC: begin
                if (pready)
                    next_state = WRITE_RESP;
            end
            
            WRITE_RESP: begin
                if (s_bready)
                    next_state = IDLE;
            end
            
            READ_SETUP: begin
                next_state = READ_ACC;
            end
            
            READ_ACC: begin
                if (pready)
                    next_state = READ_RESP;
            end
            
            READ_RESP: begin
                if (s_rready)
                    next_state = IDLE;
            end
        endcase
    end
    
    // ========================================
    // 输出逻辑
    // ========================================
    
    // AXI4侧
    always @(*) begin
        // 默认值
        s_awready = 1'b0;
        s_wready  = 1'b0;
        s_bvalid  = 1'b0;
        s_arready = 1'b0;
        s_rvalid  = 1'b0;
        
        case (state)
            IDLE: begin
                s_awready = s_wvalid;
                s_wready  = s_awvalid;
                s_arready = ~s_awvalid;
            end
            WRITE_RESP: begin
                s_bvalid = 1'b1;
            end
            READ_RESP: begin
                s_rvalid = 1'b1;
            end
        endcase
    end
    
    // APB侧
    always @(*) begin
        psel    = (state == WRITE_SETUP) || (state == WRITE_ACC) ||
                  (state == READ_SETUP)  || (state == READ_ACC);
        penable = (state == WRITE_ACC)   || (state == READ_ACC);
        pwrite  = (state == WRITE_SETUP) || (state == WRITE_ACC);
    end
    
    // ========================================
    // 事务寄存
    // ========================================
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            trans_id    <= '0;
            trans_addr  <= '0;
            trans_wdata <= '0;
            trans_wstrb <= '0;
        end else begin
            if (state == IDLE) begin
                if (s_awvalid && s_wvalid) begin
                    trans_id    <= s_awid;
                    trans_addr  <= s_awaddr;
                    trans_wdata <= s_wdata;
                    trans_wstrb <= s_wstrb;
                end else if (s_arvalid) begin
                    trans_id   <= s_arid;
                    trans_addr <= s_araddr;
                end
            end
        end
    end
    
    // ========================================
    // APB接口赋值
    // ========================================
    always @(posedge aclk) begin
        paddr  <= trans_addr;
        pwdata <= trans_wdata;
        pstrb  <= trans_wstrb;
    end
    
    // ========================================
    // AXI4响应
    // ========================================
    always @(posedge aclk) begin
        s_bid   <= trans_id;
        s_bresp <= {1'b0, pslverr}; // OKAY or SLVERR
        
        s_rid   <= trans_id;
        s_rdata <= prdata;
        s_rresp <= {1'b0, pslverr};
        s_rlast <= 1'b1; // Bridge不支持burst，总是single
    end
    
    // ========================================
    // 说明
    // ========================================
    // 这个Bridge展示了:
    // 1. AXI4 -> APB协议转换
    // 2. Outstanding事务串行化
    // 3. 握手转换 (VALID/READY -> SEL/ENABLE)
    // 4. Burst拆分 (AXI burst -> APB single)
    //
    // 简化之处:
    // - 只处理single transfer
    // - 不支持真正的Outstanding (FIFO队列)
    // - 简化的错误处理
    //
    // 完整实现约800行

endmodule
