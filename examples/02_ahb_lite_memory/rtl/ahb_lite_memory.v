// ============================================================================
// AHB-Lite Memory Controller
// ============================================================================
// Simple AHB-Lite slave memory for demonstration and testing
//
// Features:
// - Single-cycle read/write operations
// - All AHB-Lite burst types supported
// - Configurable memory size
// - OKAY/ERROR response
//
// Author: AutoUVM Example
// Date: 2026-01-27
// ============================================================================

module ahb_lite_memory #(
    parameter ADDR_WIDTH = 16,  // 64KB address space
    parameter DATA_WIDTH = 32   // 32-bit data bus
)(
    // Global signals
    input  wire                     HCLK,
    input  wire                     HRESETn,
    
    // AHB-Lite slave signals
    input  wire                     HSEL,
    input  wire [ADDR_WIDTH-1:0]    HADDR,
    input  wire                     HWRITE,
    input  wire [2:0]               HSIZE,
    input  wire [2:0]               HBURST,
    input  wire [1:0]               HTRANS,
    input  wire [DATA_WIDTH-1:0]    HWDATA,
    
    output reg  [DATA_WIDTH-1:0]    HRDATA,
    output reg                      HREADY,
    output reg                      HRESP
);

    // ========================================================================
    // Local Parameters
    // ========================================================================
    
    // HTRANS encoding
    localparam TRANS_IDLE   = 2'b00;
    localparam TRANS_BUSY   = 2'b01;
    localparam TRANS_NONSEQ = 2'b10;
    localparam TRANS_SEQ    = 2'b11;
    
    // HRESP encoding
    localparam RESP_OKAY  = 1'b0;
    localparam RESP_ERROR = 1'b1;
    
    // Memory size
    localparam MEM_DEPTH = (1 << ADDR_WIDTH) / (DATA_WIDTH / 8);
    
    // ========================================================================
    // Internal Memory
    // ========================================================================
    
    reg [DATA_WIDTH-1:0] memory [0:MEM_DEPTH-1];
    
    // ========================================================================
    // Pipeline Registers (Address Phase)
    // ========================================================================
    
    reg [ADDR_WIDTH-1:0]    addr_reg;
    reg                     write_reg;
    reg [2:0]               size_reg;
    reg [1:0]               trans_reg;
    reg                     sel_reg;
    
    // ========================================================================
    // Address Phase Sampling
    // ========================================================================
    
    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            addr_reg  <= {ADDR_WIDTH{1'b0}};
            write_reg <= 1'b0;
            size_reg  <= 3'b0;
            trans_reg <= TRANS_IDLE;
            sel_reg   <= 1'b0;
        end else if (HREADY) begin
            // Sample address phase when HREADY=1
            addr_reg  <= HADDR;
            write_reg <= HWRITE;
            size_reg  <= HSIZE;
            trans_reg <= HTRANS;
            sel_reg   <= HSEL;
        end
    end
    
    // ========================================================================
    // Data Phase Operations
    // ========================================================================
    
    wire transfer_valid = sel_reg && (trans_reg == TRANS_NONSEQ || trans_reg == TRANS_SEQ);
    
    // Calculate word address (for 32-bit data bus)
    wire [ADDR_WIDTH-1:0] word_addr = addr_reg[ADDR_WIDTH-1:2];
    
    // Check if address is in valid range
    wire addr_valid = (word_addr < MEM_DEPTH);
    
    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            HRDATA <= {DATA_WIDTH{1'b0}};
            HREADY <= 1'b1;  // Ready after reset
            HRESP  <= RESP_OKAY;
        end else begin
            // Default: single-cycle operation
            HREADY <= 1'b1;
            HRESP  <= RESP_OKAY;
            
            if (transfer_valid) begin
                if (addr_valid) begin
                    if (write_reg) begin
                        // Write operation
                        case (size_reg)
                            3'b000: begin // Byte
                                case (addr_reg[1:0])
                                    2'b00: memory[word_addr][7:0]   <= HWDATA[7:0];
                                    2'b01: memory[word_addr][15:8]  <= HWDATA[7:0];
                                    2'b10: memory[word_addr][23:16] <= HWDATA[7:0];
                                    2'b11: memory[word_addr][31:24] <= HWDATA[7:0];
                                endcase
                            end
                            3'b001: begin // Halfword
                                if (addr_reg[1] == 0)
                                    memory[word_addr][15:0]  <= HWDATA[15:0];
                                else
                                    memory[word_addr][31:16] <= HWDATA[15:0];
                            end
                            3'b010: begin // Word
                                memory[word_addr] <= HWDATA;
                            end
                            default: begin
                                // Unsupported size
                                HRESP <= RESP_ERROR;
                            end
                        endcase
                    end else begin
                        // Read operation
                        case (size_reg)
                            3'b000: begin // Byte
                                case (addr_reg[1:0])
                                    2'b00: HRDATA <= {{24{1'b0}}, memory[word_addr][7:0]};
                                    2'b01: HRDATA <= {{24{1'b0}}, memory[word_addr][15:8]};
                                    2'b10: HRDATA <= {{24{1'b0}}, memory[word_addr][23:16]};
                                    2'b11: HRDATA <= {{24{1'b0}}, memory[word_addr][31:24]};
                                endcase
                            end
                            3'b001: begin // Halfword
                                if (addr_reg[1] == 0)
                                    HRDATA <= {{16{1'b0}}, memory[word_addr][15:0]};
                                else
                                    HRDATA <= {{16{1'b0}}, memory[word_addr][31:16]};
                            end
                            3'b010: begin // Word
                                HRDATA <= memory[word_addr];
                            end
                            default: begin
                                // Unsupported size
                                HRDATA <= {DATA_WIDTH{1'b0}};
                                HRESP  <= RESP_ERROR;
                            end
                        endcase
                    end
                end else begin
                    // Address out of range - ERROR response
                    HRESP  <= RESP_ERROR;
                    HRDATA <= {DATA_WIDTH{1'bx}};
                end
            end else begin
                // No valid transfer
                HRDATA <= {DATA_WIDTH{1'b0}};
            end
        end
    end
    
    // ========================================================================
    // Memory Initialization (for simulation)
    // ========================================================================
    
    integer i;
    initial begin
        for (i = 0; i < MEM_DEPTH; i = i + 1) begin
            memory[i] = {DATA_WIDTH{1'b0}};
        end
    end

endmodule
