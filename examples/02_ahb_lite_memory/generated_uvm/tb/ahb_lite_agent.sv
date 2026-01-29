//==============================================================================
// AHB-Lite Agent
//==============================================================================

class ahb_lite_agent extends uvm_agent;
    `uvm_component_utils(ahb_lite_agent)
    
    ahb_lite_driver    driver;
    ahb_lite_monitor   monitor;
    ahb_lite_sequencer sequencer;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = ahb_lite_monitor::type_id::create("monitor", this);
        if (get_is_active() == UVM_ACTIVE) begin
            driver = ahb_lite_driver::type_id::create("driver", this);
            sequencer = ahb_lite_sequencer::type_id::create("sequencer", this);
        end
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (get_is_active() == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction
    
endclass
