`ifndef SPI_AGENT_SV
`define SPI_AGENT_SV

/**
 * spi_agent - UVM Agent
 *
 * This agent manages interface protocol transactions.
 * It encapsulates the driver, monitor, and sequencer components
 * and provides a unified interface to the testbench.
 *
 * Components:
 *   - driver (spi_driver): Drives transactions onto the interface
 *   - monitor (spi_monitor): Observes and collects transactions
 *   - sequencer (spi_sequencer): Schedules transaction sequences
 *
 * Configuration:
 *   - Virtual interface (spi_if) must be set via config_db
 *   - Set with: uvm_config_db#(virtual spi_if)::set(null, "*", "vif", ...)
 */
class spi_agent extends uvm_agent;
    `uvm_component_utils(spi_agent)

    /// Virtual interface to the DUT signals
    virtual spi_if vif;

    // Agent sub-components
    spi_driver driver;     ///< Drives stimulus to DUT
    spi_monitor monitor;   ///< Collects transactions from DUT
    spi_sequencer sequencer; ///< Manages transaction sequences

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create driver only in active mode
        if (is_active == UVM_ACTIVE) begin
            driver = spi_driver::type_id::create("driver", this);
        end
        monitor = spi_monitor::type_id::create("monitor", this);
        if (is_active == UVM_ACTIVE) begin
            sequencer = spi_sequencer::type_id::create("sequencer", this);
        end

        // Get virtual interface from config_db
        if (!uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NO_VIF", $sformatf("[%s] Failed to get virtual interface 'spi_if' from config_db. Check that tb_top sets config: uvm_config_db#(virtual spi_if)::set(null, '*', 'vif', ...)", get_full_name()));
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (is_active == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction

endclass

`endif