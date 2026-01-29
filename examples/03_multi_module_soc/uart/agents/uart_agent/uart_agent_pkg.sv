`ifndef UART_AGENT_PKG_SV
`define UART_AGENT_PKG_SV

package uart_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uvm_pkg::*;

    // Forward declarations (if needed)

    // Includes
    `include "uart_seq_item.sv"
    `include "uart_sequencer.sv"
    `include "uart_driver.sv"
    `include "uart_monitor.sv"
    `include "uart_rand_seq.sv"
    `include "uart_agent.sv"

endpackage

`endif