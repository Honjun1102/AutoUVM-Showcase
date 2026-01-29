`ifndef UART_IF_SV
`define UART_IF_SV

interface uart_if (
    input logic clk,
    input logic rst_n
);

    // Signals
    logic  tx;
    logic  rx;

    // ========================================
    // UART Protocol Assertions for uart_if
    // ========================================

    // UART-A1: TX line must be high when idle
    // (检查在空闲状态下 TX 线为高)
    // Note: 具体的波特率和帧格式检查需要参数化


endinterface

`endif