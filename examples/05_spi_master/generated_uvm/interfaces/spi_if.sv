// AutoUVM生成 - SPI接口
interface spi_if(input logic clk);
  logic       spi_sclk;
  logic       spi_mosi;
  logic       spi_miso;
  logic       spi_cs_n;
  
  modport master (
    output spi_sclk, spi_mosi, spi_cs_n,
    input  spi_miso
  );
  
  modport slave (
    input  spi_sclk, spi_mosi, spi_cs_n,
    output spi_miso
  );
  
  modport monitor (
    input spi_sclk, spi_mosi, spi_miso, spi_cs_n
  );
  
endinterface
