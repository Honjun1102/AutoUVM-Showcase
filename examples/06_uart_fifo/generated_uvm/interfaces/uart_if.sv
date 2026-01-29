// AutoUVM生成 - UART接口
interface uart_if(input logic clk);
  logic uart_tx;
  
  modport dut (output uart_tx);
  modport monitor (input uart_tx);
endinterface
