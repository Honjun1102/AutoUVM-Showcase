// SPI Slave模型 - 用于测试
module spi_slave_model (
    input  wire spi_sclk,
    input  wire spi_mosi,
    output reg  spi_miso,
    input  wire spi_cs_n
);

    reg [7:0] rx_data;
    reg [2:0] bit_cnt;
    reg [7:0] tx_data;
    
    // 简单的回环模式：接收到什么就发送什么+1
    always @(posedge spi_sclk or posedge spi_cs_n) begin
        if (spi_cs_n) begin
            bit_cnt <= 0;
            tx_data <= 8'h00;
        end else begin
            rx_data <= {rx_data[6:0], spi_mosi};
            bit_cnt <= bit_cnt + 1;
            if (bit_cnt == 7) begin
                tx_data <= rx_data + 1;  // 返回接收值+1
            end
        end
    end
    
    always @(negedge spi_sclk or posedge spi_cs_n) begin
        if (spi_cs_n) begin
            spi_miso <= 1'b0;
        end else begin
            spi_miso <= tx_data[7];
            tx_data <= {tx_data[6:0], 1'b0};
        end
    end

endmodule
