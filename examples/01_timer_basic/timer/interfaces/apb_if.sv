`ifndef APB_IF_SV
`define APB_IF_SV

interface apb_if (
    input logic clk_i,
    input logic rst_ni
);

    // Signals

    // APB canonical aliases (compat)
    wire PSELx;
    wire PENABLE;
    wire PWRITE;
    wire PADDR;
    wire PWDATA;
    wire PRDATA;
    wire PREADY;
    // No pready signal detected; assume always-ready for smoke runs.
    assign PREADY = 1'b1;

endinterface

`endif