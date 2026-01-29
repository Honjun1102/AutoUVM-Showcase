// AutoUVM生成 - FIFO状态接口
interface fifo_status_if(input logic clk);
  logic       full;
  logic       empty;
  logic [4:0] count;
  
  modport monitor (input full, empty, count);
endinterface
