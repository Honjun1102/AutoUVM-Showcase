`ifndef PWM_AGENT_PKG_SV
`define PWM_AGENT_PKG_SV

package pwm_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uvm_pkg::*;

    // Forward declarations (if needed)

    // Includes
    `include "pwm_seq_item.sv"
    `include "pwm_sequencer.sv"
    `include "pwm_driver.sv"
    `include "pwm_monitor.sv"
    `include "pwm_rand_seq.sv"
    `include "pwm_agent.sv"

endpackage

`endif