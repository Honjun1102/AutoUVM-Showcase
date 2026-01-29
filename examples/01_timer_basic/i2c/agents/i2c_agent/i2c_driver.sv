`ifndef I2C_DRIVER_SV
`define I2C_DRIVER_SV

class i2c_driver extends uvm_driver #(i2c_seq_item);
    `uvm_component_utils(i2c_driver)

    virtual i2c_if vif;
    virtual autouvm_clk_rst_if clk_rst_vif;

    // Configuration parameters (can be overridden via agent config)
    int max_stall_cycles = 32;  ///< Max cycles to wait for ready/valid
    bit self_tb_mode = 1;  ///< Self-testbench mode flag

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual i2c_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", {"[Driver] Failed to get virtual interface 'i2c_if' for: ", get_full_name(), ".vif. ",
                                   "Check tb_top config_db setup."});
        end
        if (!uvm_config_db#(virtual autouvm_clk_rst_if)::get(this, "", "clk_rst_vif", clk_rst_vif)) begin
            `uvm_fatal("NOCLK", {"[Driver] Failed to get clk_rst_vif for: ", get_full_name(), ". ",
                                   "Check that tb_top sets: uvm_config_db#(virtual autouvm_clk_rst_if)::set(...)"});
        end
    endfunction

    extern virtual task run_phase(uvm_phase phase);
    extern virtual task drive_item(i2c_seq_item tr);

endclass

task i2c_driver::run_phase(uvm_phase phase);
    i2c_seq_item req;
    forever begin
        seq_item_port.get_next_item(req);
        drive_item(req);
        seq_item_port.item_done();
    end
endtask

task i2c_driver::drive_item(i2c_seq_item tr);
    // I2C drive_item
    // Generic protocol: not implemented
    // LLM_BODY_START: drive_item
    // Implement protocol-specific driving logic here
    // LLM_BODY_END: drive_item
endtask

`endif