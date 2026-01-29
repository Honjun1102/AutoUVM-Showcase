`ifndef TIMER_ENV_PKG_SV
`define TIMER_ENV_PKG_SV

package timer_env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uvm_pkg::*;
    import apb_agent_pkg::*;

    // Analysis imp declarations for coverage
    `uvm_analysis_imp_decl(_apb)

    // Forward declarations (if needed)

    // Includes
    `include "timer_env_coverage.sv"
    `include "timer_env.sv"

endpackage

`endif