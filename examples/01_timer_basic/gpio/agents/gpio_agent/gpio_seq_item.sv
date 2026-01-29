`ifndef GPIO_SEQ_ITEM_SV
`define GPIO_SEQ_ITEM_SV

/**
 * gpio_seq_item - Transaction Class
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
class gpio_seq_item extends uvm_sequence_item;
    `uvm_object_utils(gpio_seq_item)

    // Randomized transaction fields
    rand bit gpio_in;
    rand bit gpio_out;
    rand bit gpio_dir;

    function new(string name = "gpio_seq_item");
        super.new(name);
    endfunction

    // LLM_BODY_START: constraints
    // Add custom protocol-specific constraints here
    // LLM_BODY_END: constraints

endclass

`endif