`ifndef APB_SEQ_ITEM_SV
`define APB_SEQ_ITEM_SV

/**
 * apb_seq_item - Transaction Class
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
class apb_seq_item extends uvm_sequence_item;
    `uvm_object_utils(apb_seq_item)

    // Randomized transaction fields
    rand bit paddr;
    rand bit psel;
    rand bit pwrite;
    rand bit pwdata;
    rand bit prdata;
    rand bit pready;
    rand bit pslverr;

    // Non-randomized control/status fields (set by driver/environment)
    bit penable;

    function new(string name = "apb_seq_item");
        super.new(name);
    endfunction

    // LLM_BODY_START: constraints
    // Add custom protocol-specific constraints here
    // LLM_BODY_END: constraints

endclass

`endif