// UART TX顶层 - FIFO + Transmitter
module uart_tx_top (
    input  wire       clk,
    input  wire       rst_n,
    
    // AXI-Stream输入
    input  wire [7:0] s_axis_tdata,
    input  wire       s_axis_tvalid,
    output wire       s_axis_tready,
    
    // UART输出
    output wire       uart_tx,
    
    // 状态
    output wire       fifo_full,
    output wire       fifo_empty,
    output wire [4:0] fifo_count
);

    wire [7:0] fifo_tx_data;
    wire       fifo_tx_valid;
    wire       fifo_tx_ready;
    
    uart_tx_fifo u_fifo (
        .clk           (clk),
        .rst_n         (rst_n),
        .s_axis_tdata  (s_axis_tdata),
        .s_axis_tvalid (s_axis_tvalid),
        .s_axis_tready (s_axis_tready),
        .tx_data       (fifo_tx_data),
        .tx_valid      (fifo_tx_valid),
        .tx_ready      (fifo_tx_ready),
        .full          (fifo_full),
        .empty         (fifo_empty),
        .count         (fifo_count)
    );
    
    uart_transmitter #(
        .CLOCK_FREQ(50_000_000),
        .BAUD_RATE(115200)
    ) u_tx (
        .clk      (clk),
        .rst_n    (rst_n),
        .tx_data  (fifo_tx_data),
        .tx_valid (fifo_tx_valid),
        .tx_ready (fifo_tx_ready),
        .uart_tx  (uart_tx)
    );

endmodule
