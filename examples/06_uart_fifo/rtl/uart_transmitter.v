// UART发送器 - 可配置波特率
module uart_transmitter #(
    parameter CLOCK_FREQ = 50_000_000,
    parameter BAUD_RATE  = 115200
)(
    input  wire       clk,
    input  wire       rst_n,
    
    // 数据接口
    input  wire [7:0] tx_data,
    input  wire       tx_valid,
    output reg        tx_ready,
    
    // UART接口
    output reg        uart_tx
);

    localparam BAUD_DIV = CLOCK_FREQ / BAUD_RATE;
    
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;
    
    reg [1:0]  state;
    reg [15:0] baud_cnt;
    reg [2:0]  bit_cnt;
    reg [7:0]  shift_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            uart_tx <= 1'b1;
            tx_ready <= 1'b1;
            baud_cnt <= 0;
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    uart_tx <= 1'b1;
                    tx_ready <= 1'b1;
                    if (tx_valid && tx_ready) begin
                        shift_reg <= tx_data;
                        tx_ready <= 1'b0;
                        state <= START;
                        baud_cnt <= 0;
                    end
                end
                
                START: begin
                    uart_tx <= 1'b0;  // Start bit
                    if (baud_cnt == BAUD_DIV - 1) begin
                        baud_cnt <= 0;
                        bit_cnt <= 0;
                        state <= DATA;
                    end else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end
                
                DATA: begin
                    uart_tx <= shift_reg[0];
                    if (baud_cnt == BAUD_DIV - 1) begin
                        baud_cnt <= 0;
                        shift_reg <= {1'b0, shift_reg[7:1]};
                        if (bit_cnt == 7) begin
                            state <= STOP;
                        end else begin
                            bit_cnt <= bit_cnt + 1;
                        end
                    end else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end
                
                STOP: begin
                    uart_tx <= 1'b1;  // Stop bit
                    if (baud_cnt == BAUD_DIV - 1) begin
                        state <= IDLE;
                        tx_ready <= 1'b1;
                    end else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end
            endcase
        end
    end

endmodule
