`ifndef I2C_SEQ_ITEM_SV
`define I2C_SEQ_ITEM_SV

/**
 * i2c_seq_item - Transaction Class
 *
 * Represents a single transaction on the interface.
 * This class encapsulates all signals required for a complete
 * bus transaction, with intelligent constraints for valid randomization.
 *
 * Field Categories:
 *   - Randomized: Transaction data (addresses, data, control signals)
 *   - Non-randomized: Environment control (clocks, resets, flags)
 *
 * Usage:
 *   - Sequences generate instances of this class
 *   - Driver converts to pin wiggles
 *   - Monitor reconstructs from observed signals
 */
class i2c_seq_item extends uvm_sequence_item;
    `uvm_object_utils(i2c_seq_item)

    // Randomized transaction fields
    rand bit scl;
    rand bit sda;

    function new(string name = "i2c_seq_item");
        super.new(name);
    endfunction

    // LLM_BODY_START: constraints
    // Add custom protocol-specific constraints here
    // LLM_BODY_END: constraints

endclass

`endif