// UART发送FIFO - 带流控的16x8 FIFO
module uart_tx_fifo (
    input  wire       clk,
    input  wire       rst_n,
    
    // 写接口 (AXI-Stream)
    input  wire [7:0] s_axis_tdata,
    input  wire       s_axis_tvalid,
    output wire       s_axis_tready,
    
    // 读接口 (UART TX)
    output wire [7:0] tx_data,
    output wire       tx_valid,
    input  wire       tx_ready,
    
    // 状态
    output wire       full,
    output wire       empty,
    output wire [4:0] count
);

    // FIFO存储
    reg [7:0] fifo_mem [15:0];
    reg [3:0] wr_ptr;
    reg [3:0] rd_ptr;
    reg [4:0] fifo_count;
    
    assign count = fifo_count;
    assign full  = (fifo_count == 5'd16);
    assign empty = (fifo_count == 5'd0);
    
    assign s_axis_tready = !full;
    assign tx_valid = !empty;
    assign tx_data = fifo_mem[rd_ptr];
    
    // 写入FIFO
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 4'h0;
        end else if (s_axis_tvalid && s_axis_tready) begin
            fifo_mem[wr_ptr] <= s_axis_tdata;
            wr_ptr <= wr_ptr + 1'b1;
        end
    end
    
    // 读出FIFO
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 4'h0;
        end else if (tx_valid && tx_ready) begin
            rd_ptr <= rd_ptr + 1'b1;
        end
    end
    
    // 计数器
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fifo_count <= 5'h0;
        end else begin
            case ({s_axis_tvalid && s_axis_tready, tx_valid && tx_ready})
                2'b10: fifo_count <= fifo_count + 1'b1;  // 只写
                2'b01: fifo_count <= fifo_count - 1'b1;  // 只读
                2'b11: fifo_count <= fifo_count;         // 同时读写
                default: fifo_count <= fifo_count;
            endcase
        end
    end

endmodule
