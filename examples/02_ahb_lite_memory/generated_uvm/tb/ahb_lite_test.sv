//==============================================================================
// AHB-Lite Test
//==============================================================================

class ahb_lite_test extends uvm_test;
    `uvm_component_utils(ahb_lite_test)
    
    ahb_lite_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = ahb_lite_env::type_id::create("env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        ahb_lite_transaction trans;
        
        phase.raise_objection(this);
        
        `uvm_info("TEST", "Starting AHB-Lite Memory Test", UVM_LOW)
        
        // Run 10 random transactions
        repeat(10) begin
            trans = ahb_lite_transaction::type_id::create("trans");
            assert(trans.randomize());
            env.agent.sequencer.execute_item(trans);
        end
        
        #1000ns;
        
        `uvm_info("TEST", "Test Completed", UVM_LOW)
        phase.drop_objection(this);
    endtask
    
endclass
