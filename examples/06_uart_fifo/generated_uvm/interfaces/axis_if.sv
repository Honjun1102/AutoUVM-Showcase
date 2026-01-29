// AutoUVM生成 - AXI-Stream接口
interface axis_if(input logic aclk, input logic aresetn);
  logic [7:0] tdata;
  logic       tvalid;
  logic       tready;
  
  modport master (
    output tdata, tvalid,
    input  tready
  );
  
  modport slave (
    input  tdata, tvalid,
    output tready
  );
endinterface
