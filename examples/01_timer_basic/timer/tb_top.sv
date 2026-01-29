`timescale 1ns/1ps

module tb_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Clock / Reset generation (per clock domain)
    logic clk_i;
    logic rst_ni;

    // Fallback clk (used only when an interface has no clock_domain)
    logic clk;

    // Fallback rst_n (used only when an interface has no clock_domain)
    logic rst_n;

    initial clk_i = 1'b0;
    always #5 clk_i = ~clk_i;

    initial begin
        rst_ni = 1'b1;
        repeat (5) @(posedge clk_i);
        rst_ni = 1'b0;
    end

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 1'b0;
        repeat (5) @(posedge clk_i);
        rst_n = 1'b1;
    end

    // Global clock/reset carrier for tests (deterministic time control)
    autouvm_clk_rst_if tb_clk_rst_vif();
    assign tb_clk_rst_vif.clk = clk_i;
    assign tb_clk_rst_vif.rst = rst_ni;

    // Interfaces (one instance per IR interface)
    apb_if apb_if_vif (
        .clk_i(clk_i),
        .rst_ni(rst_ni)
    );
    autouvm_clk_rst_if apb_if_clk_rst_vif();
    assign apb_if_clk_rst_vif.clk = clk_i;
    assign apb_if_clk_rst_vif.rst = rst_ni;

    // Initialize interface signals to 0
    initial begin
        // init apb_if
    end

    // Bind virtual interfaces into UVM config_db
    initial begin
        uvm_config_db#(virtual autouvm_clk_rst_if)::set(null, "*", "tb_clk_rst_vif", tb_clk_rst_vif);

        run_test();
    end

endmodule