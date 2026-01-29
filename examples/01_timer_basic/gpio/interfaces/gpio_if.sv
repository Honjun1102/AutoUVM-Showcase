`ifndef GPIO_IF_SV
`define GPIO_IF_SV

interface gpio_if (
    input logic clk,
    input logic rst_n
);

    // Signals
    logic [7:0] gpio_in;
    logic [7:0] gpio_out;
    logic [7:0] gpio_dir;

endinterface

`endif