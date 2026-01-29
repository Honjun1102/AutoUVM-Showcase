//==============================================================================
// AHB-Lite Interface
//==============================================================================

interface ahb_lite_if(input logic HCLK, input logic HRESETn);
    
    // AHB-Lite Master signals
    logic [15:0]  HADDR;
    logic         HWRITE;
    logic [2:0]   HSIZE;
    logic [2:0]   HBURST;
    logic [1:0]   HTRANS;
    logic [31:0]  HWDATA;
    logic         HSEL;
    
    // AHB-Lite Slave signals
    logic [31:0]  HRDATA;
    logic         HREADY;
    logic         HRESP;
    
    // Modports
    modport master (
        input  HCLK, HRESETn, HRDATA, HREADY, HRESP,
        output HADDR, HWRITE, HSIZE, HBURST, HTRANS, HWDATA, HSEL
    );
    
    modport slave (
        input  HCLK, HRESETn, HADDR, HWRITE, HSIZE, HBURST, HTRANS, HWDATA, HSEL,
        output HRDATA, HREADY, HRESP
    );
    
    modport monitor (
        input HCLK, HRESETn, HADDR, HWRITE, HSIZE, HBURST, HTRANS, 
              HWDATA, HRDATA, HREADY, HRESP, HSEL
    );
    
endinterface
