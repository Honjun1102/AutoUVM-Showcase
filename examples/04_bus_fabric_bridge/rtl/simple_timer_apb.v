// 简化的APB Timer Slave
module simple_timer_apb #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input wire pclk,
    input wire presetn,
    
    // APB Slave Interface
    input  wire [ADDR_WIDTH-1:0] paddr,
    input  wire                  psel,
    input  wire                  penable,
    input  wire                  pwrite,
    input  wire [DATA_WIDTH-1:0] pwdata,
    input  wire [3:0]            pstrb,
    output reg  [DATA_WIDTH-1:0] prdata,
    output reg                   pready,
    output reg                   pslverr
);

    // Timer寄存器
    reg [31:0] timer_ctrl;    // 0x00: Control
    reg [31:0] timer_count;   // 0x04: Counter
    reg [31:0] timer_compare; // 0x08: Compare value
    reg [31:0] timer_status;  // 0x0C: Status
    
    wire [3:0] reg_addr = paddr[5:2];
    
    // APB读写
    always @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            timer_ctrl    <= 32'h0;
            timer_count   <= 32'h0;
            timer_compare <= 32'hFFFFFFFF;
            timer_status  <= 32'h0;
            pready        <= 1'b1;
            pslverr       <= 1'b0;
        end else begin
            if (psel && penable) begin
                if (pwrite) begin
                    // 写操作
                    case (reg_addr)
                        4'h0: timer_ctrl    <= pwdata;
                        4'h1: timer_count   <= pwdata;
                        4'h2: timer_compare <= pwdata;
                        4'h3: timer_status  <= pwdata;
                    endcase
                end else begin
                    // 读操作
                    case (reg_addr)
                        4'h0: prdata <= timer_ctrl;
                        4'h1: prdata <= timer_count;
                        4'h2: prdata <= timer_compare;
                        4'h3: prdata <= timer_status;
                        default: prdata <= 32'hDEADBEEF;
                    endcase
                end
            end
        end
    end
    
    // Timer计数逻辑 (简化)
    always @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            timer_count <= 32'h0;
        end else if (timer_ctrl[0]) begin // Enable bit
            timer_count <= timer_count + 1;
            if (timer_count >= timer_compare)
                timer_status[0] <= 1'b1; // Match interrupt
        end
    end

endmodule
