`ifndef SPI_AGENT_PKG_SV
`define SPI_AGENT_PKG_SV

package spi_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uvm_pkg::*;

    // Forward declarations (if needed)

    // Includes
    `include "spi_seq_item.sv"
    `include "spi_sequencer.sv"
    `include "spi_driver.sv"
    `include "spi_monitor.sv"
    `include "spi_rand_seq.sv"
    `include "spi_agent.sv"

endpackage

`endif