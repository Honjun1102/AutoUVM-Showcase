// AutoUVM生成 - APB接口
interface apb_if(input logic pclk, input logic presetn);
  logic        psel;
  logic        penable;
  logic        pwrite;
  logic [7:0]  paddr;
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic        pready;
  
  modport master (
    output psel, penable, pwrite, paddr, pwdata,
    input  prdata, pready
  );
  
  modport slave (
    input  psel, penable, pwrite, paddr, pwdata,
    output prdata, pready
  );
  
endinterface
