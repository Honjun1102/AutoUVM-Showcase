`ifndef FIFO_IF_SV
`define FIFO_IF_SV

interface fifo_if (
    input logic clk,
    input logic rst_n
);

    // Signals
    logic  wr_en;
    logic [31:0] wr_data;
    logic  rd_en;
    logic [31:0] rd_data;
    logic  full;
    logic  empty;

endinterface

`endif