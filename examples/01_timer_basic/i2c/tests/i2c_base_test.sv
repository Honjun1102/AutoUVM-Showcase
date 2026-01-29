`ifndef I2C_BASE_TEST_SV
`define I2C_BASE_TEST_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

import i2c_env_pkg::*;
import i2c_agent_pkg::*;

class i2c_base_test extends uvm_test;
    `uvm_component_utils(i2c_base_test)

    // Top environment
    i2c_env env;
    virtual autouvm_clk_rst_if tb_clk_rst_vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = i2c_env::type_id::create("env", this);
        if (!uvm_config_db#(virtual autouvm_clk_rst_if)::get(this, "", "tb_clk_rst_vif", tb_clk_rst_vif)) begin
            `uvm_fatal("NOCLK", {{"[Test] Failed to get tb_clk_rst_vif for: ", get_full_name(), ". ",
                                   "Check that tb_top sets: uvm_config_db#(virtual autouvm_clk_rst_if)::set(null, 'uvm_test_top', 'tb_clk_rst_vif', ...)"}});
        end
    endfunction

    // LLM_BODY_START: sequences
    // Define local sequences here if needed
    // LLM_BODY_END: sequences

    task run_phase(uvm_phase phase);
        int run_cycles;
        phase.raise_objection(this);
        if (!$value$plusargs("AUTO_UVM_RUN_CYCLES=%d", run_cycles)) begin
            run_cycles = 2000;
        end
        // Auto-start sequences (MVP)
        if (1) begin
        begin
            // Declarations
            i2c_agent_pkg::i2c_rand_seq seq_i2c;

            // Create and start sequences
            seq_i2c = i2c_agent_pkg::i2c_rand_seq::type_id::create("seq_i2c");
            if (seq_i2c != null) begin
                seq_i2c.start(env.i2c_agent_inst.sequencer);
            end
            repeat (10) @(posedge tb_clk_rst_vif.clk);
            repeat (run_cycles) @(posedge tb_clk_rst_vif.clk);
        end
        end else begin
            // DUT mode: deterministic time advance only (no protocol driving).
            repeat (10) @(posedge tb_clk_rst_vif.clk);
            repeat (run_cycles) @(posedge tb_clk_rst_vif.clk);
        end
        // LLM_BODY_START: run_phase
        // Add additional scenario sequences here
        // LLM_BODY_END: run_phase
        phase.drop_objection(this);
    endtask

endclass

`endif