`ifndef I2C_MONITOR_SV
`define I2C_MONITOR_SV

class i2c_monitor extends uvm_monitor;
    `uvm_component_utils(i2c_monitor)

    uvm_analysis_port #(i2c_seq_item) ap;
    virtual i2c_if vif;
    virtual autouvm_clk_rst_if clk_rst_vif;

    // Configuration parameters (can be overridden via agent config)
    bit enable_checkpoints = 1;  ///< Enable protocol checks
    int max_stall_cycles = 32;  ///< Max cycles to wait for ready/valid
    bit self_tb_mode = 1;  ///< Self-testbench mode flag

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual i2c_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", {"[Monitor] Failed to get virtual interface 'i2c_if' for: ", get_full_name(), ".vif. ",
                                   "Check tb_top config_db setup."});
        end
        if (!uvm_config_db#(virtual autouvm_clk_rst_if)::get(this, "", "clk_rst_vif", clk_rst_vif)) begin
            `uvm_fatal("NOCLK", {"[Monitor] Failed to get clk_rst_vif for: ", get_full_name(), ". ",
                                   "Check that tb_top sets: uvm_config_db#(virtual autouvm_clk_rst_if)::set(...)"});
        end
    endfunction

    extern virtual task run_phase(uvm_phase phase);
    extern virtual task collect_transfer();

endclass

task i2c_monitor::run_phase(uvm_phase phase);
    fork
        begin : collect_loop
            forever begin
                collect_transfer();
            end
        end

        begin : checkpoint_loop
            // I2C collect_transfer
            // Protocol not recognized for checkpoints (I2C)
            forever begin
                @(posedge clk_rst_vif.clk);
            end
        end
    join
endtask

task i2c_monitor::collect_transfer();
    i2c_seq_item tr;
    @(posedge clk_rst_vif.clk);
    if ((clk_rst_vif.rst !== 1'b1)) return;
    if (!self_tb_mode) return;
    tr = i2c_seq_item::type_id::create("tr");
    // No cover fields
    ap.write(tr);
    return;
endtask

`endif