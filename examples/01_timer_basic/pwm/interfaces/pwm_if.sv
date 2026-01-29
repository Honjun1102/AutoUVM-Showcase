`ifndef PWM_IF_SV
`define PWM_IF_SV

interface pwm_if (
    input logic clk,
    input logic rst_n
);

    // Signals
    logic [3:0] pwm_out;
    logic [7:0] duty_cycle;
    logic [15:0] period;

endinterface

`endif