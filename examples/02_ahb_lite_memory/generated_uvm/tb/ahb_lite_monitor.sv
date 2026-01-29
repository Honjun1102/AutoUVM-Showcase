//==============================================================================
// AHB-Lite Monitor
//==============================================================================

class ahb_lite_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_lite_monitor)
    
    virtual ahb_lite_if vif;
    uvm_analysis_port #(ahb_lite_transaction) analysis_port;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual ahb_lite_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not found")
    endfunction
    
    task run_phase(uvm_phase phase);
        ahb_lite_transaction trans;
        forever begin
            @(posedge vif.HCLK);
            if (vif.HSEL && vif.HTRANS inside {2'b10, 2'b11}) begin
                trans = ahb_lite_transaction::type_id::create("trans");
                // Capture address phase
                trans.addr = vif.HADDR;
                trans.write = vif.HWRITE;
                trans.size = vif.HSIZE;
                trans.burst_type = vif.HBURST;
                trans.trans_type = vif.HTRANS;
                
                // Wait for data phase
                @(posedge vif.HCLK);
                wait(vif.HREADY);
                
                // Capture data phase
                if (trans.write) begin
                    trans.data = vif.HWDATA;
                end else begin
                    trans.data = vif.HRDATA;
                end
                trans.resp = vif.HRESP;
                
                // Broadcast
                analysis_port.write(trans);
            end
        end
    endtask
    
endclass
