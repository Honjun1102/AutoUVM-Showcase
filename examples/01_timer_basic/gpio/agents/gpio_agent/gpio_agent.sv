`ifndef GPIO_AGENT_SV
`define GPIO_AGENT_SV

/**
 * gpio_agent - UVM Agent
 *
 * This agent manages interface protocol transactions.
 * It encapsulates the driver, monitor, and sequencer components
 * and provides a unified interface to the testbench.
 *
 * Components:
 *   - driver (gpio_driver): Drives transactions onto the interface
 *   - monitor (gpio_monitor): Observes and collects transactions
 *   - sequencer (gpio_sequencer): Schedules transaction sequences
 *
 * Configuration:
 *   - Virtual interface (gpio_if) must be set via config_db
 *   - Set with: uvm_config_db#(virtual gpio_if)::set(null, "*", "vif", ...)
 */
class gpio_agent extends uvm_agent;
    `uvm_component_utils(gpio_agent)

    /// Virtual interface to the DUT signals
    virtual gpio_if vif;

    // Agent sub-components
    gpio_driver driver;     ///< Drives stimulus to DUT
    gpio_monitor monitor;   ///< Collects transactions from DUT
    gpio_sequencer sequencer; ///< Manages transaction sequences

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create driver only in active mode
        if (is_active == UVM_ACTIVE) begin
            driver = gpio_driver::type_id::create("driver", this);
        end
        monitor = gpio_monitor::type_id::create("monitor", this);
        if (is_active == UVM_ACTIVE) begin
            sequencer = gpio_sequencer::type_id::create("sequencer", this);
        end

        // Get virtual interface from config_db
        if (!uvm_config_db#(virtual gpio_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NO_VIF", $sformatf("[%s] Failed to get virtual interface 'gpio_if' from config_db. Check that tb_top sets config: uvm_config_db#(virtual gpio_if)::set(null, '*', 'vif', ...)", get_full_name()));
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