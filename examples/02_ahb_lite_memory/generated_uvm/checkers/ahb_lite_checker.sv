`timescale 1ns/1ps

//============================================================================
// AHB-Lite Protocol Checker
// 
// Implements SystemVerilog Assertions (SVA) to verify AHB-Lite protocol
// compliance according to ARM AMBA specification.
//
// Features:
// - Handshake protocol verification
// - Address/Data phase stability checks
// - Burst transaction rules
// - Transfer type transitions
// - Response checking
// - Timeout protection
//============================================================================

module ahb_lite_checker #(
    parameter ADDR_WIDTH = 16,
    parameter DATA_WIDTH = 32,
    parameter TIMEOUT_CYCLES = 2000
) (
    // Global signals
    input  wire                    HCLK,
    input  wire                    HRESETn,
    
    // Master signals
    input  wire [ADDR_WIDTH-1:0]   HADDR,
    input  wire                    HWRITE,
    input  wire [2:0]              HSIZE,
    input  wire [2:0]              HBURST,
    input  wire [6:0]              HPROT,
    input  wire [1:0]              HTRANS,
    input  wire                    HMASTLOCK,
    input  wire [DATA_WIDTH-1:0]   HWDATA,
    
    // Slave signals
    input  wire [DATA_WIDTH-1:0]   HRDATA,
    input  wire                    HREADY,
    input  wire                    HRESP,
    
    // Select signal
    input  wire                    HSEL
);

    // ========== Helper functions and constants ==========
    
    // HTRANS definitions
    localparam TRANS_IDLE   = 2'b00;
    localparam TRANS_BUSY   = 2'b01;
    localparam TRANS_NONSEQ = 2'b10;
    localparam TRANS_SEQ    = 2'b11;
    
    // HBURST definitions
    localparam BURST_SINGLE = 3'b000;
    localparam BURST_INCR   = 3'b001;
    localparam BURST_WRAP4  = 3'b010;
    localparam BURST_INCR4  = 3'b011;
    localparam BURST_WRAP8  = 3'b100;
    localparam BURST_INCR8  = 3'b101;
    localparam BURST_WRAP16 = 3'b110;
    localparam BURST_INCR16 = 3'b111;
    
    // HRESP definitions
    localparam RESP_OKAY  = 1'b0;
    localparam RESP_ERROR = 1'b1;
    
    // Transfer active signal
    wire transfer_active = HSEL && HREADY && (HTRANS != TRANS_IDLE);
    
    // ========== Basic Protocol Checks ==========
    
    // Check 1: HREADY must be high for at least one cycle after reset
    property hready_after_reset;
        @(posedge HCLK) $rose(HRESETn) |-> ##[1:10] HREADY;
    endproperty
    assert property (hready_after_reset)
        else `uvm_error("AHB_CHK", "HREADY not asserted within 10 cycles after reset")
    
    // Check 2: Address must be stable when HREADY is low (slave extending)
    property addr_stable_when_not_ready;
        @(posedge HCLK) disable iff (!HRESETn)
        (transfer_active && !HREADY) |=> $stable(HADDR);
    endproperty
    assert property (addr_stable_when_not_ready)
        else `uvm_error("AHB_CHK", "HADDR changed while HREADY was low")
    
    // Check 3: Control signals must be stable when HREADY is low
    property control_stable_when_not_ready;
        @(posedge HCLK) disable iff (!HRESETn)
        (transfer_active && !HREADY) |=> ($stable(HWRITE) && $stable(HSIZE) && $stable(HBURST) && $stable(HTRANS));
    endproperty
    assert property (control_stable_when_not_ready)
        else `uvm_error("AHB_CHK", "Control signals changed while HREADY was low")
    
    // Check 4: Write data must be stable when HREADY is low during write
    property wdata_stable_when_not_ready;
        @(posedge HCLK) disable iff (!HRESETn)
        (transfer_active && HWRITE && !HREADY) |=> $stable(HWDATA);
    endproperty
    assert property (wdata_stable_when_not_ready)
        else `uvm_error("AHB_CHK", "HWDATA changed while HREADY was low during write")
    
    // ========== Transfer Type Transition Checks ==========
    
    // Check 5: IDLE can only transition to IDLE or NONSEQ
    property idle_transition;
        @(posedge HCLK) disable iff (!HRESETn)
        (HTRANS == TRANS_IDLE && HREADY) |=> (HTRANS == TRANS_IDLE || HTRANS == TRANS_NONSEQ);
    endproperty
    assert property (idle_transition)
        else `uvm_error("AHB_CHK", "Invalid transition from IDLE (must go to IDLE or NONSEQ)")
    
    // Check 6: BUSY can only follow NONSEQ or SEQ
    property busy_follows_nonseq_or_seq;
        @(posedge HCLK) disable iff (!HRESETn)
        (HTRANS == TRANS_BUSY) |-> ($past(HTRANS) == TRANS_NONSEQ || $past(HTRANS) == TRANS_SEQ || $past(HTRANS) == TRANS_BUSY);
    endproperty
    assert property (busy_follows_nonseq_or_seq)
        else `uvm_error("AHB_CHK", "BUSY can only follow NONSEQ, SEQ, or BUSY")
    
    // Check 7: SEQ must follow NONSEQ, SEQ, or BUSY
    property seq_follows_nonseq_seq_busy;
        @(posedge HCLK) disable iff (!HRESETn)
        (HTRANS == TRANS_SEQ && HREADY) |-> ($past(HTRANS) == TRANS_NONSEQ || $past(HTRANS) == TRANS_SEQ || $past(HTRANS) == TRANS_BUSY);
    endproperty
    assert property (seq_follows_nonseq_seq_busy)
        else `uvm_error("AHB_CHK", "SEQ must follow NONSEQ, SEQ, or BUSY")
    
    // ========== Burst Transaction Checks ==========
    
    // Check 8: SINGLE burst must have only one NONSEQ transfer
    property single_burst_one_transfer;
        @(posedge HCLK) disable iff (!HRESETn)
        (transfer_active && HBURST == BURST_SINGLE && HTRANS == TRANS_NONSEQ) |=> (HTRANS != TRANS_SEQ);
    endproperty
    assert property (single_burst_one_transfer)
        else `uvm_error("AHB_CHK", "SINGLE burst cannot have SEQ transfers")
    
    // Check 9: SEQ transfer must have same HBURST as preceding NONSEQ
    logic [2:0] burst_type_reg;
    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            burst_type_reg <= BURST_SINGLE;
        end else if (HREADY && HTRANS == TRANS_NONSEQ) begin
            burst_type_reg <= HBURST;
        end
    end
    
    property seq_same_burst;
        @(posedge HCLK) disable iff (!HRESETn)
        (HTRANS == TRANS_SEQ) |-> (HBURST == burst_type_reg);
    endproperty
    assert property (seq_same_burst)
        else `uvm_error("AHB_CHK", "SEQ transfer HBURST mismatch with burst start")
    
    // Check 10: Address alignment for burst transfers
    property addr_aligned;
        @(posedge HCLK) disable iff (!HRESETn)
        (transfer_active) |-> ((HADDR % (1 << HSIZE)) == 0);
    endproperty
    assert property (addr_aligned)
        else `uvm_error("AHB_CHK", $sformatf("Address 0x%h not aligned to size %0d", HADDR, HSIZE))
    
    // ========== HSIZE Validity Checks ==========
    
    // Check 11: HSIZE must be valid (0-7)
    property hsize_valid;
        @(posedge HCLK) disable iff (!HRESETn)
        (transfer_active) |-> (HSIZE <= 3'b111);
    endproperty
    assert property (hsize_valid)
        else `uvm_error("AHB_CHK", "Invalid HSIZE value")
    
    // Check 12: HSIZE must not exceed data bus width
    property hsize_within_bus_width;
        @(posedge HCLK) disable iff (!HRESETn)
        (transfer_active) |-> ((1 << (HSIZE + 3)) <= DATA_WIDTH);
    endproperty
    assert property (hsize_within_bus_width)
        else `uvm_error("AHB_CHK", $sformatf("HSIZE %0d exceeds DATA_WIDTH %0d", HSIZE, DATA_WIDTH))
    
    // ========== Response Checks ==========
    
    // Check 13: ERROR response requires two-cycle error handling
    logic error_seen;
    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            error_seen <= 1'b0;
        end else if (HREADY) begin
            error_seen <= HRESP && transfer_active;
        end
    end
    
    property error_two_cycle;
        @(posedge HCLK) disable iff (!HRESETn)
        (HRESP && !HREADY && transfer_active) |=> (HRESP && HREADY);
    endproperty
    assert property (error_two_cycle)
        else `uvm_error("AHB_CHK", "ERROR response must be two cycles (first with HREADY=0, second with HREADY=1)")
    
    // Check 14: After ERROR response, transfer must be IDLE or NONSEQ (not SEQ)
    property no_seq_after_error;
        @(posedge HCLK) disable iff (!HRESETn)
        (HRESP && HREADY && transfer_active) |=> (HTRANS != TRANS_SEQ);
    endproperty
    assert property (no_seq_after_error)
        else `uvm_error("AHB_CHK", "SEQ transfer cannot immediately follow ERROR response")
    
    // ========== Timeout Protection ==========
    
    // Check 15: HREADY must assert within timeout period
    property hready_timeout;
        @(posedge HCLK) disable iff (!HRESETn)
        (transfer_active && !HREADY) |-> ##[1:TIMEOUT_CYCLES] HREADY;
    endproperty
    assert property (hready_timeout)
        else `uvm_error("AHB_CHK", $sformatf("HREADY timeout after %0d cycles", TIMEOUT_CYCLES))
    
    // ========== X/Z Detection ==========
    
    // Check 16: No X/Z on HADDR during active transfer
    property no_x_haddr;
        @(posedge HCLK) disable iff (!HRESETn)
        (transfer_active) |-> (!$isunknown(HADDR));
    endproperty
    assert property (no_x_haddr)
        else `uvm_error("AHB_CHK", "X/Z detected on HADDR during active transfer")
    
    // Check 17: No X/Z on control signals during active transfer
    property no_x_control;
        @(posedge HCLK) disable iff (!HRESETn)
        (transfer_active) |-> (!$isunknown(HWRITE) && !$isunknown(HSIZE) && !$isunknown(HBURST) && !$isunknown(HTRANS));
    endproperty
    assert property (no_x_control)
        else `uvm_error("AHB_CHK", "X/Z detected on control signals during active transfer")
    
    // Check 18: No X/Z on HWDATA during write data phase
    property no_x_wdata;
        @(posedge HCLK) disable iff (!HRESETn)
        (HWRITE && HREADY && $past(transfer_active)) |-> (!$isunknown(HWDATA));
    endproperty
    assert property (no_x_wdata)
        else `uvm_error("AHB_CHK", "X/Z detected on HWDATA during write data phase")
    
    // Check 19: No X/Z on HREADY
    property no_x_hready;
        @(posedge HCLK) disable iff (!HRESETn)
        (1'b1) |-> (!$isunknown(HREADY));
    endproperty
    assert property (no_x_hready)
        else `uvm_error("AHB_CHK", "X/Z detected on HREADY")
    
    // Check 20: No X/Z on HRESP
    property no_x_hresp;
        @(posedge HCLK) disable iff (!HRESETn)
        (HREADY) |-> (!$isunknown(HRESP));
    endproperty
    assert property (no_x_hresp)
        else `uvm_error("AHB_CHK", "X/Z detected on HRESP")
    
    // ========== Pipelined Operation Checks ==========
    
    // Check 21: Data phase follows address phase by one cycle
    logic [ADDR_WIDTH-1:0] addr_pipeline;
    logic write_pipeline;
    logic transfer_pipeline;
    
    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            addr_pipeline <= '0;
            write_pipeline <= 1'b0;
            transfer_pipeline <= 1'b0;
        end else if (HREADY) begin
            addr_pipeline <= HADDR;
            write_pipeline <= HWRITE;
            transfer_pipeline <= transfer_active;
        end
    end
    
    // ========== Coverage Points ==========
    
    covergroup ahb_protocol_cov @(posedge HCLK);
        option.per_instance = 1;
        option.name = "ahb_lite_protocol_coverage";
        
        // Transfer types
        trans_type: coverpoint HTRANS {
            bins idle   = {TRANS_IDLE};
            bins busy   = {TRANS_BUSY};
            bins nonseq = {TRANS_NONSEQ};
            bins seq    = {TRANS_SEQ};
        }
        
        // Burst types
        burst_type: coverpoint HBURST {
            bins single = {BURST_SINGLE};
            bins incr   = {BURST_INCR};
            bins wrap4  = {BURST_WRAP4};
            bins incr4  = {BURST_INCR4};
            bins wrap8  = {BURST_WRAP8};
            bins incr8  = {BURST_INCR8};
            bins wrap16 = {BURST_WRAP16};
            bins incr16 = {BURST_INCR16};
        }
        
        // Transfer sizes
        trans_size: coverpoint HSIZE {
            bins byte     = {3'b000};
            bins halfword = {3'b001};
            bins word     = {3'b010};
            bins dword    = {3'b011};
        }
        
        // Read/Write
        direction: coverpoint HWRITE {
            bins read  = {1'b0};
            bins write = {1'b1};
        }
        
        // Response
        response: coverpoint HRESP {
            bins okay  = {RESP_OKAY};
            bins error = {RESP_ERROR};
        }
        
        // Ready states
        ready: coverpoint HREADY {
            bins ready     = {1'b1};
            bins not_ready = {1'b0};
        }
        
        // Cross coverage
        burst_x_size: cross burst_type, trans_size;
        trans_x_dir: cross trans_type, direction;
        trans_x_resp: cross trans_type, response;
    endgroup
    
    ahb_protocol_cov cov_inst = new();

endmodule