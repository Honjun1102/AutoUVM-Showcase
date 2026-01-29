`ifndef GPIO_ENV_PKG_SV
`define GPIO_ENV_PKG_SV

package gpio_env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uvm_pkg::*;
    import gpio_agent_pkg::*;

    // Analysis imp declarations for coverage
    `uvm_analysis_imp_decl(_gpio)

    // Forward declarations (if needed)

    // Includes
    `include "gpio_env_coverage.sv"
    `include "gpio_env.sv"

endpackage

`endif