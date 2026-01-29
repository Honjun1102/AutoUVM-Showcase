//==============================================================================
// Testbench Top
//==============================================================================

module tb_top;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    // Clock and reset
    logic HCLK = 0;
    logic HRESETn = 0;
    
    // Clock generation
    always #5 HCLK = ~HCLK;  // 100MHz
    
    // Interface instance
    ahb_lite_if dut_if(HCLK, HRESETn);
    
    // DUT instance
    ahb_lite_memory dut (
        .HCLK(dut_if.HCLK),
        .HRESETn(dut_if.HRESETn),
        .HSEL(dut_if.HSEL),
        .HADDR(dut_if.HADDR),
        .HWRITE(dut_if.HWRITE),
        .HSIZE(dut_if.HSIZE),
        .HBURST(dut_if.HBURST),
        .HTRANS(dut_if.HTRANS),
        .HWDATA(dut_if.HWDATA),
        .HRDATA(dut_if.HRDATA),
        .HREADY(dut_if.HREADY),
        .HRESP(dut_if.HRESP)
    );
    
    // Protocol checker instance
    ahb_lite_checker #(
        .ADDR_WIDTH(16),
        .DATA_WIDTH(32),
        .TIMEOUT_CYCLES(2000)
    ) checker (
        .HCLK(dut_if.HCLK),
        .HRESETn(dut_if.HRESETn),
        .HADDR(dut_if.HADDR),
        .HWRITE(dut_if.HWRITE),
        .HSIZE(dut_if.HSIZE),
        .HBURST(dut_if.HBURST),
        .HTRANS(dut_if.HTRANS),
        .HWDATA(dut_if.HWDATA),
        .HRDATA(dut_if.HRDATA),
        .HREADY(dut_if.HREADY),
        .HRESP(dut_if.HRESP)
    );
    
    initial begin
        // Reset sequence
        HRESETn = 0;
        repeat(10) @(posedge HCLK);
        HRESETn = 1;
        
        // Register interface with UVM config_db
        uvm_config_db#(virtual ahb_lite_if)::set(null, "*", "vif", dut_if);
        
        // Run test
        run_test("ahb_lite_test");
    end
    
    // Watchdog
    initial begin
        #10ms;
        `uvm_fatal("TIMEOUT", "Simulation timeout")
    end
    
endmodule
