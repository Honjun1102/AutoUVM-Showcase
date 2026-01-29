`ifndef PWM_ENV_PKG_SV
`define PWM_ENV_PKG_SV

package pwm_env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uvm_pkg::*;
    import pwm_agent_pkg::*;

    // Analysis imp declarations for coverage
    `uvm_analysis_imp_decl(_pwm)

    // Forward declarations (if needed)

    // Includes
    `include "pwm_env_coverage.sv"
    `include "pwm_env.sv"

endpackage

`endif