`ifndef FIFO_ENV_PKG_SV
`define FIFO_ENV_PKG_SV

package fifo_env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uvm_pkg::*;
    import fifo_agent_pkg::*;

    // Analysis imp declarations for coverage
    `uvm_analysis_imp_decl(_fifo)

    // Forward declarations (if needed)

    // Includes
    `include "fifo_env_coverage.sv"
    `include "fifo_env.sv"

endpackage

`endif