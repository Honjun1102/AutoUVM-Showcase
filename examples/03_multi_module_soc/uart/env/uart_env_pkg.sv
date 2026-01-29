`ifndef UART_ENV_PKG_SV
`define UART_ENV_PKG_SV

package uart_env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uvm_pkg::*;
    import uart_agent_pkg::*;

    // Analysis imp declarations for coverage
    `uvm_analysis_imp_decl(_uart)

    // Forward declarations (if needed)

    // Includes
    `include "uart_env_coverage.sv"
    `include "uart_env.sv"

endpackage

`endif