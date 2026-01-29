`ifndef SPI_ENV_PKG_SV
`define SPI_ENV_PKG_SV

package spi_env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uvm_pkg::*;
    import spi_agent_pkg::*;

    // Analysis imp declarations for coverage
    `uvm_analysis_imp_decl(_spi)

    // Forward declarations (if needed)

    // Includes
    `include "spi_env_coverage.sv"
    `include "spi_env.sv"

endpackage

`endif