`ifndef I2C_IF_SV
`define I2C_IF_SV

interface i2c_if (
    input logic clk,
    input logic rst_n
);

    // Signals
    logic  scl;
    logic  sda;

endinterface

`endif