// SPI Master控制器 - 支持4种模式
module spi_master (
    // 系统接口
    input  wire        clk,
    input  wire        rst_n,
    
    // APB接口
    input  wire        psel,
    input  wire        penable,
    input  wire        pwrite,
    input  wire [7:0]  paddr,
    input  wire [31:0] pwdata,
    output reg  [31:0] prdata,
    output reg         pready,
    
    // SPI接口
    output reg         spi_sclk,
    output reg         spi_mosi,
    input  wire        spi_miso,
    output reg         spi_cs_n,
    
    // 中断
    output reg         irq
);

    // 寄存器地址
    localparam ADDR_CTRL   = 8'h00;  // 控制寄存器
    localparam ADDR_STATUS = 8'h04;  // 状态寄存器
    localparam ADDR_DATA   = 8'h08;  // 数据寄存器
    localparam ADDR_DIV    = 8'h0C;  // 分频系数
    
    // 寄存器
    reg [31:0] ctrl_reg;    // [0]:enable, [1]:cpol, [2]:cpha, [7:4]:cs_id
    reg [31:0] status_reg;  // [0]:busy, [1]:done
    reg [7:0]  tx_data;
    reg [7:0]  rx_data;
    reg [7:0]  clk_div;
    
    // 状态机
    localparam IDLE  = 2'b00;
    localparam SETUP = 2'b01;
    localparam TRANS = 2'b10;
    localparam DONE  = 2'b11;
    
    reg [1:0]  state;
    reg [3:0]  bit_cnt;
    reg [7:0]  clk_cnt;
    reg [7:0]  shift_reg;
    
    wire cpol = ctrl_reg[1];
    wire cpha = ctrl_reg[2];
    wire enable = ctrl_reg[0];
    
    // APB读写
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ctrl_reg <= 0;
            clk_div  <= 8'd10;
            pready   <= 1'b1;
        end else if (psel && penable && pready) begin
            if (pwrite) begin
                case (paddr)
                    ADDR_CTRL: ctrl_reg <= pwdata;
                    ADDR_DATA: tx_data  <= pwdata[7:0];
                    ADDR_DIV:  clk_div  <= pwdata[7:0];
                endcase
            end else begin
                case (paddr)
                    ADDR_CTRL:   prdata <= ctrl_reg;
                    ADDR_STATUS: prdata <= status_reg;
                    ADDR_DATA:   prdata <= {24'h0, rx_data};
                    ADDR_DIV:    prdata <= {24'h0, clk_div};
                endcase
            end
        end
    end
    
    // SPI传输状态机
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            bit_cnt <= 0;
            clk_cnt <= 0;
            spi_cs_n <= 1'b1;
            spi_sclk <= 1'b0;
            spi_mosi <= 1'b0;
            shift_reg <= 8'h0;
            rx_data <= 8'h0;
            status_reg <= 32'h0;
            irq <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    spi_cs_n <= 1'b1;
                    spi_sclk <= cpol;
                    irq <= 1'b0;
                    if (enable && !status_reg[0]) begin
                        shift_reg <= tx_data;
                        state <= SETUP;
                        status_reg[0] <= 1'b1;  // busy
                        status_reg[1] <= 1'b0;  // done
                    end
                end
                
                SETUP: begin
                    spi_cs_n <= 1'b0;
                    clk_cnt <= 0;
                    bit_cnt <= 0;
                    state <= TRANS;
                end
                
                TRANS: begin
                    clk_cnt <= clk_cnt + 1;
                    if (clk_cnt == clk_div) begin
                        clk_cnt <= 0;
                        
                        // 时钟边沿
                        if (spi_sclk == cpol) begin
                            // 第一个边沿 - 数据建立
                            spi_sclk <= ~cpol;
                            if (cpha == 0) begin
                                spi_mosi <= shift_reg[7];
                            end else begin
                                shift_reg <= {shift_reg[6:0], spi_miso};
                            end
                        end else begin
                            // 第二个边沿 - 数据采样
                            spi_sclk <= cpol;
                            if (cpha == 1) begin
                                spi_mosi <= shift_reg[7];
                            end else begin
                                shift_reg <= {shift_reg[6:0], spi_miso};
                            end
                            
                            bit_cnt <= bit_cnt + 1;
                            if (bit_cnt == 7) begin
                                state <= DONE;
                            end
                        end
                    end
                end
                
                DONE: begin
                    spi_cs_n <= 1'b1;
                    spi_sclk <= cpol;
                    rx_data <= shift_reg;
                    status_reg[0] <= 1'b0;  // not busy
                    status_reg[1] <= 1'b1;  // done
                    irq <= 1'b1;
                    ctrl_reg[0] <= 1'b0;    // clear enable
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
