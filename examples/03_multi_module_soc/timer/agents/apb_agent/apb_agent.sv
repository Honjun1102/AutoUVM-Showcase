`ifndef APB_AGENT_SV
`define APB_AGENT_SV

/**
 * apb_agent - UVM Agent
 *
 * This agent manages APB protocol transactions.
 * It encapsulates the driver, monitor, and sequencer components
 * and provides a unified interface to the testbench.
 *
 * Components:
 *   - driver (apb_driver): Drives transactions onto the interface
 *   - monitor (apb_monitor): Observes and collects transactions
 *   - sequencer (apb_sequencer): Schedules transaction sequences
 *
 * Configuration:
 *   - Virtual interface (apb_if) must be set via config_db
 *   - Set with: uvm_config_db#(virtual apb_if)::set(null, "*", "vif", ...)
 */
class apb_agent extends uvm_agent;
    `uvm_component_utils(apb_agent)

    /// Virtual interface to the DUT signals
    virtual apb_if vif;

    // Agent sub-components
    apb_driver driver;     ///< Drives stimulus to DUT
    apb_monitor monitor;   ///< Collects transactions from DUT
    apb_sequencer sequencer; ///< Manages transaction sequences

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create driver only in active mode
        if (is_active == UVM_ACTIVE) begin
            driver = apb_driver::type_id::create("driver", this);
        end
        monitor = apb_monitor::type_id::create("monitor", this);
        if (is_active == UVM_ACTIVE) begin
            sequencer = apb_sequencer::type_id::create("sequencer", this);
        end

        // Get virtual interface from config_db
        if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NO_VIF", $sformatf("[%s] Failed to get virtual interface 'apb_if' from config_db. Check that tb_top sets config: uvm_config_db#(virtual apb_if)::set(null, '*', 'vif', ...)", get_full_name()));
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