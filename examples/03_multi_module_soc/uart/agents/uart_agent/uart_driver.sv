`ifndef UART_DRIVER_SV
`define UART_DRIVER_SV

class uart_driver extends uvm_driver #(uart_seq_item);
    `uvm_component_utils(uart_driver)

    virtual uart_if vif;
    virtual autouvm_clk_rst_if clk_rst_vif;

    // Configuration parameters (can be overridden via agent config)
    int max_stall_cycles = 32;  ///< Max cycles to wait for ready/valid
    bit self_tb_mode = 1;  ///< Self-testbench mode flag

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", {"[Driver] Failed to get virtual interface 'uart_if' for: ", get_full_name(), ".vif. ",
                                   "Check tb_top config_db setup."});
        end
        if (!uvm_config_db#(virtual autouvm_clk_rst_if)::get(this, "", "clk_rst_vif", clk_rst_vif)) begin
            `uvm_fatal("NOCLK", {"[Driver] Failed to get clk_rst_vif for: ", get_full_name(), ". ",
                                   "Check that tb_top sets: uvm_config_db#(virtual autouvm_clk_rst_if)::set(...)"});
        end
    endfunction

    extern virtual task run_phase(uvm_phase phase);
    extern virtual task drive_item(uart_seq_item tr);

endclass

task uart_driver::run_phase(uvm_phase phase);
    uart_seq_item req;
    forever begin
        seq_item_port.get_next_item(req);
        drive_item(req);
        seq_item_port.item_done();
    end
endtask

task uart_driver::drive_item(uart_seq_item tr);
    // UART drive_item
    // Generic protocol: not implemented
    // LLM_BODY_START: drive_item
    // Implement protocol-specific driving logic here
    // LLM_BODY_END: drive_item
endtask

`endif