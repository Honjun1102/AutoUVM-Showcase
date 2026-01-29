// AutoUVM生成 - 寄存器接口
interface reg_if(input logic clk, input logic rst_n);
  logic       reg_wr;
  logic       reg_rd;
  logic [3:0] reg_addr;
  logic [7:0] reg_wdata;
  logic [7:0] reg_rdata;
  logic       reg_ready;
  
  modport master (
    output reg_wr, reg_rd, reg_addr, reg_wdata,
    input  reg_rdata, reg_ready
  );
  
  modport slave (
    input  reg_wr, reg_rd, reg_addr, reg_wdata,
    output reg_rdata, reg_ready
  );
  
endinterface
