`ifndef APB_AGENT_PKG_SV
`define APB_AGENT_PKG_SV

package apb_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uvm_pkg::*;

    // Forward declarations (if needed)

    // Includes
    `include "apb_seq_item.sv"
    `include "apb_sequencer.sv"
    `include "apb_driver.sv"
    `include "apb_monitor.sv"
    `include "apb_rand_seq.sv"
    `include "apb_agent.sv"

endpackage

`endif