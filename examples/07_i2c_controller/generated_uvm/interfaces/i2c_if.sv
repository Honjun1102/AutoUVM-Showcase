// AutoUVM生成 - I2C接口
interface i2c_if(input logic clk);
  logic scl_out;
  logic scl_oe;
  logic scl_in;
  logic sda_out;
  logic sda_oe;
  logic sda_in;
  
  // 开漏输出模拟
  assign scl_in = scl_oe ? scl_out : 1'b1;
  assign sda_in = sda_oe ? sda_out : 1'b1;
  
  modport master (
    output scl_out, scl_oe, sda_out, sda_oe,
    input  scl_in, sda_in
  );
  
  modport monitor (
    input scl_in, sda_in
  );
  
endinterface
