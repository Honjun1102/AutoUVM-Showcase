// I2C Master控制器 - 支持标准模式(100kHz)和快速模式(400kHz)
module i2c_master_ctrl (
    input  wire        clk,
    input  wire        rst_n,
    
    // Register接口
    input  wire        reg_wr,
    input  wire        reg_rd,
    input  wire [3:0]  reg_addr,
    input  wire [7:0]  reg_wdata,
    output reg  [7:0]  reg_rdata,
    output reg         reg_ready,
    
    // I2C接口
    output reg         scl_out,
    output reg         scl_oe,
    input  wire        scl_in,
    output reg         sda_out,
    output reg         sda_oe,
    input  wire        sda_in,
    
    // 中断
    output reg         irq
);

    // 寄存器定义
    localparam REG_CTRL   = 4'h0;  // [0]:start, [1]:stop, [2]:read, [3]:write
    localparam REG_STATUS = 4'h1;  // [0]:busy, [1]:ack, [2]:arb_lost
    localparam REG_DATA   = 4'h2;  // 数据寄存器
    localparam REG_SLAVE  = 4'h3;  // 从机地址
    localparam REG_PRESCL = 4'h4;  // 时钟分频
    
    reg [7:0] ctrl_reg;
    reg [7:0] status_reg;
    reg [7:0] data_reg;
    reg [6:0] slave_addr;
    reg [7:0] prescaler;
    
    // 状态机
    localparam IDLE       = 3'h0;
    localparam START      = 3'h1;
    localparam ADDR       = 3'h2;
    localparam WRITE_DATA = 3'h3;
    localparam READ_DATA  = 3'h4;
    localparam ACK        = 3'h5;
    localparam STOP       = 3'h6;
    
    reg [2:0]  state;
    reg [7:0]  shift_reg;
    reg [3:0]  bit_cnt;
    reg [7:0]  clk_cnt;
    reg        ack_bit;
    
    // 寄存器读写
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ctrl_reg <= 8'h0;
            prescaler <= 8'd50;  // 默认100kHz @ 50MHz
            reg_ready <= 1'b1;
        end else if (reg_wr && reg_ready) begin
            case (reg_addr)
                REG_CTRL:   ctrl_reg <= reg_wdata;
                REG_DATA:   data_reg <= reg_wdata;
                REG_SLAVE:  slave_addr <= reg_wdata[6:0];
                REG_PRESCL: prescaler <= reg_wdata;
            endcase
        end else if (reg_rd && reg_ready) begin
            case (reg_addr)
                REG_CTRL:   reg_rdata <= ctrl_reg;
                REG_STATUS: reg_rdata <= status_reg;
                REG_DATA:   reg_rdata <= data_reg;
                REG_SLAVE:  reg_rdata <= {1'b0, slave_addr};
                REG_PRESCL: reg_rdata <= prescaler;
                default:    reg_rdata <= 8'h0;
            endcase
        end
    end
    
    // I2C状态机
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            scl_out <= 1'b1;
            scl_oe <= 1'b0;
            sda_out <= 1'b1;
            sda_oe <= 1'b0;
            status_reg <= 8'h0;
            irq <= 1'b0;
            clk_cnt <= 8'h0;
            bit_cnt <= 4'h0;
        end else begin
            case (state)
                IDLE: begin
                    scl_oe <= 1'b0;
                    sda_oe <= 1'b0;
                    irq <= 1'b0;
                    clk_cnt <= 8'h0;
                    
                    if (ctrl_reg[0]) begin  // start
                        state <= START;
                        status_reg[0] <= 1'b1;  // busy
                    end
                end
                
                START: begin
                    clk_cnt <= clk_cnt + 1;
                    if (clk_cnt == 0) begin
                        sda_oe <= 1'b1;
                        sda_out <= 1'b0;  // SDA下降沿 (SCL高)
                    end else if (clk_cnt == prescaler/2) begin
                        scl_oe <= 1'b1;
                        scl_out <= 1'b0;  // 然后SCL下降
                    end else if (clk_cnt == prescaler) begin
                        clk_cnt <= 8'h0;
                        bit_cnt <= 4'h0;
                        if (ctrl_reg[3]) begin  // write
                            shift_reg <= {slave_addr, 1'b0};  // 地址+写
                            state <= ADDR;
                        end else if (ctrl_reg[2]) begin  // read
                            shift_reg <= {slave_addr, 1'b1};  // 地址+读
                            state <= ADDR;
                        end
                    end
                end
                
                ADDR: begin
                    clk_cnt <= clk_cnt + 1;
                    if (clk_cnt == prescaler/4) begin
                        sda_out <= shift_reg[7];
                        shift_reg <= {shift_reg[6:0], 1'b0};
                    end else if (clk_cnt == prescaler/2) begin
                        scl_out <= 1'b1;  // SCL上升沿
                    end else if (clk_cnt == prescaler) begin
                        scl_out <= 1'b0;  // SCL下降沿
                        clk_cnt <= 8'h0;
                        bit_cnt <= bit_cnt + 1;
                        if (bit_cnt == 7) begin
                            state <= ACK;
                        end
                    end
                end
                
                ACK: begin
                    clk_cnt <= clk_cnt + 1;
                    if (clk_cnt == 0) begin
                        sda_oe <= 1'b0;  // 释放SDA
                    end else if (clk_cnt == prescaler/2) begin
                        scl_out <= 1'b1;
                        ack_bit <= sda_in;  // 采样ACK
                    end else if (clk_cnt == prescaler) begin
                        scl_out <= 1'b0;
                        status_reg[1] <= !ack_bit;  // ACK status
                        clk_cnt <= 8'h0;
                        
                        if (ctrl_reg[3]) begin  // write data
                            shift_reg <= data_reg;
                            bit_cnt <= 4'h0;
                            state <= WRITE_DATA;
                        end else if (ctrl_reg[2]) begin  // read data
                            bit_cnt <= 4'h0;
                            state <= READ_DATA;
                        end else if (ctrl_reg[1]) begin  // stop
                            state <= STOP;
                        end else begin
                            state <= IDLE;
                        end
                    end
                end
                
                WRITE_DATA: begin
                    clk_cnt <= clk_cnt + 1;
                    if (clk_cnt == 0) begin
                        sda_oe <= 1'b1;
                    end else if (clk_cnt == prescaler/4) begin
                        sda_out <= shift_reg[7];
                        shift_reg <= {shift_reg[6:0], 1'b0};
                    end else if (clk_cnt == prescaler/2) begin
                        scl_out <= 1'b1;
                    end else if (clk_cnt == prescaler) begin
                        scl_out <= 1'b0;
                        clk_cnt <= 8'h0;
                        bit_cnt <= bit_cnt + 1;
                        if (bit_cnt == 7) begin
                            state <= ACK;
                        end
                    end
                end
                
                STOP: begin
                    clk_cnt <= clk_cnt + 1;
                    if (clk_cnt == 0) begin
                        sda_oe <= 1'b1;
                        sda_out <= 1'b0;
                    end else if (clk_cnt == prescaler/2) begin
                        scl_oe <= 1'b0;  // 释放SCL
                    end else if (clk_cnt == prescaler) begin
                        sda_out <= 1'b1;  // SDA上升沿 (SCL高)
                        clk_cnt <= 8'h0;
                        state <= IDLE;
                        status_reg[0] <= 1'b0;  // not busy
                        irq <= 1'b1;
                        ctrl_reg <= 8'h0;  // 清除命令
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule
