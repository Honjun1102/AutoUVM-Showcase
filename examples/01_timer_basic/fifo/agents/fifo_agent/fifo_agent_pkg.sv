`ifndef FIFO_AGENT_PKG_SV
`define FIFO_AGENT_PKG_SV

package fifo_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uvm_pkg::*;

    // Forward declarations (if needed)

    // Includes
    `include "fifo_seq_item.sv"
    `include "fifo_sequencer.sv"
    `include "fifo_driver.sv"
    `include "fifo_monitor.sv"
    `include "fifo_rand_seq.sv"
    `include "fifo_agent.sv"

endpackage

`endif