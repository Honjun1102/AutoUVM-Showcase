`ifndef I2C_ENV_PKG_SV
`define I2C_ENV_PKG_SV

package i2c_env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uvm_pkg::*;
    import i2c_agent_pkg::*;

    // Analysis imp declarations for coverage
    `uvm_analysis_imp_decl(_i2c)

    // Forward declarations (if needed)

    // Includes
    `include "i2c_env_coverage.sv"
    `include "i2c_env.sv"

endpackage

`endif