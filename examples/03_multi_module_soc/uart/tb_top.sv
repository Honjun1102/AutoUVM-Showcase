`timescale 1ns/1ps

module tb_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Clock / Reset generation (per clock domain)
    logic clk;
    logic rst_n;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 1'b0;
        repeat (5) @(posedge clk);
        rst_n = 1'b1;
    end

    // Global clock/reset carrier for tests (deterministic time control)
    autouvm_clk_rst_if tb_clk_rst_vif();
    assign tb_clk_rst_vif.clk = clk;
    assign tb_clk_rst_vif.rst = rst_n;

    // Interfaces (one instance per IR interface)
    uart_if uart_if_vif (
        .clk(clk),
        .rst_n(rst_n)
    );
    autouvm_clk_rst_if uart_if_clk_rst_vif();
    assign uart_if_clk_rst_vif.clk = clk;
    assign uart_if_clk_rst_vif.rst = rst_n;

    // Initialize interface signals to 0
    initial begin
        // init uart_if
        uart_if_vif.tx = '0;
        uart_if_vif.rx = '0;
    end

    // Bind virtual interfaces into UVM config_db
    initial begin
        uvm_config_db#(virtual autouvm_clk_rst_if)::set(null, "*", "tb_clk_rst_vif", tb_clk_rst_vif);

        run_test();
    end

endmodule