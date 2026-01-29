`ifndef SPI_IF_SV
`define SPI_IF_SV

interface spi_if (
    input logic clk,
    input logic rst_n
);

    // Signals
    logic  sclk;
    logic  mosi;
    logic  miso;
    logic  cs_n;

endinterface

`endif