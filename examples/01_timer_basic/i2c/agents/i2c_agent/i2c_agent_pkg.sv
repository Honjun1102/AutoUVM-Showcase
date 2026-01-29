`ifndef I2C_AGENT_PKG_SV
`define I2C_AGENT_PKG_SV

package i2c_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uvm_pkg::*;

    // Forward declarations (if needed)

    // Includes
    `include "i2c_seq_item.sv"
    `include "i2c_sequencer.sv"
    `include "i2c_driver.sv"
    `include "i2c_monitor.sv"
    `include "i2c_rand_seq.sv"
    `include "i2c_agent.sv"

endpackage

`endif