`ifndef PWM_SEQ_ITEM_SV
`define PWM_SEQ_ITEM_SV

/**
 * pwm_seq_item - Transaction Class
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
class pwm_seq_item extends uvm_sequence_item;
    `uvm_object_utils(pwm_seq_item)

    // Randomized transaction fields
    rand bit pwm_out;
    rand bit duty_cycle;
    rand bit period;

    function new(string name = "pwm_seq_item");
        super.new(name);
    endfunction

    // LLM_BODY_START: constraints
    // Add custom protocol-specific constraints here
    // LLM_BODY_END: constraints

endclass

`endif