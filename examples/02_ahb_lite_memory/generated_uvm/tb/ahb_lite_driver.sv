//==============================================================================
// AHB-Lite Driver
//==============================================================================

class ahb_lite_driver extends uvm_driver #(ahb_lite_transaction);
    `uvm_component_utils(ahb_lite_driver)
    
    virtual ahb_lite_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual ahb_lite_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive_transaction(req);
            seq_item_port.item_done();
        end
    endtask
    
    task drive_transaction(ahb_lite_transaction trans);
        // Address phase
        @(posedge vif.HCLK);
        vif.HSEL   <= 1'b1;
        vif.HADDR  <= trans.addr;
        vif.HWRITE <= trans.write;
        vif.HSIZE  <= trans.size;
        vif.HBURST <= trans.burst_type;
        vif.HTRANS <= 2'b10;  // NONSEQ
        
        // Data phase
        @(posedge vif.HCLK);
        if (trans.write) begin
            vif.HWDATA <= trans.data;
        end
        
        // Wait for HREADY
        wait(vif.HREADY);
        @(posedge vif.HCLK);
        
        // Capture response
        trans.resp = vif.HRESP;
        if (!trans.write) begin
            trans.data = vif.HRDATA;
        end
        
        // Return to IDLE
        vif.HTRANS <= 2'b00;  // IDLE
        vif.HSEL   <= 1'b0;
    endtask
    
endclass
