`ifndef FIFO_SEQ_ITEM_SV
`define FIFO_SEQ_ITEM_SV

/**
 * fifo_seq_item - Transaction Class
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
class fifo_seq_item extends uvm_sequence_item;
    `uvm_object_utils(fifo_seq_item)

    // Randomized transaction fields
    rand bit wr_data;
    rand bit rd_data;
    rand bit full;
    rand bit empty;

    // Non-randomized control/status fields (set by driver/environment)
    bit wr_en;
    bit rd_en;

    function new(string name = "fifo_seq_item");
        super.new(name);
    endfunction

    // LLM_BODY_START: constraints
    // Add custom protocol-specific constraints here
    // LLM_BODY_END: constraints

endclass

`endif