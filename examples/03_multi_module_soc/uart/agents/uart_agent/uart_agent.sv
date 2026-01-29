`ifndef UART_AGENT_SV
`define UART_AGENT_SV

/**
 * uart_agent - UVM Agent
 *
 * This agent manages interface protocol transactions.
 * It encapsulates the driver, monitor, and sequencer components
 * and provides a unified interface to the testbench.
 *
 * Components:
 *   - driver (uart_driver): Drives transactions onto the interface
 *   - monitor (uart_monitor): Observes and collects transactions
 *   - sequencer (uart_sequencer): Schedules transaction sequences
 *
 * Configuration:
 *   - Virtual interface (uart_if) must be set via config_db
 *   - Set with: uvm_config_db#(virtual uart_if)::set(null, "*", "vif", ...)
 */
class uart_agent extends uvm_agent;
    `uvm_component_utils(uart_agent)

    /// Virtual interface to the DUT signals
    virtual uart_if vif;

    // Agent sub-components
    uart_driver driver;     ///< Drives stimulus to DUT
    uart_monitor monitor;   ///< Collects transactions from DUT
    uart_sequencer sequencer; ///< Manages transaction sequences

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create driver only in active mode
        if (is_active == UVM_ACTIVE) begin
            driver = uart_driver::type_id::create("driver", this);
        end
        monitor = uart_monitor::type_id::create("monitor", this);
        if (is_active == UVM_ACTIVE) begin
            sequencer = uart_sequencer::type_id::create("sequencer", this);
        end

        // Get virtual interface from config_db
        if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NO_VIF", $sformatf("[%s] Failed to get virtual interface 'uart_if' from config_db. Check that tb_top sets config: uvm_config_db#(virtual uart_if)::set(null, '*', 'vif', ...)", get_full_name()));
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