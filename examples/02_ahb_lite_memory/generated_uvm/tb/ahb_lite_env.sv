//==============================================================================
// AHB-Lite Environment
//==============================================================================

class ahb_lite_env extends uvm_env;
    `uvm_component_utils(ahb_lite_env)
    
    ahb_lite_agent agent;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = ahb_lite_agent::type_id::create("agent", this);
    endfunction
    
endclass
