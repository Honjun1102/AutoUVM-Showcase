`ifndef SPI_SEQ_ITEM_SV
`define SPI_SEQ_ITEM_SV

/**
 * spi_seq_item - Transaction Class
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
class spi_seq_item extends uvm_sequence_item;
    `uvm_object_utils(spi_seq_item)

    // Randomized transaction fields
    rand bit mosi;
    rand bit miso;
    rand bit cs_n;

    // Non-randomized control/status fields (set by driver/environment)
    bit sclk;

    function new(string name = "spi_seq_item");
        super.new(name);
    endfunction

    // LLM_BODY_START: constraints
    // Add custom protocol-specific constraints here
    // LLM_BODY_END: constraints

endclass

`endif