`ifndef GPIO_AGENT_PKG_SV
`define GPIO_AGENT_PKG_SV

package gpio_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uvm_pkg::*;

    // Forward declarations (if needed)

    // Includes
    `include "gpio_seq_item.sv"
    `include "gpio_sequencer.sv"
    `include "gpio_driver.sv"
    `include "gpio_monitor.sv"
    `include "gpio_rand_seq.sv"
    `include "gpio_agent.sv"

endpackage

`endif