`timescale 1ns / 1ps

module BaudRateGenerator #(
        parameter SYSTEM_CLOCK = 99999001,
        parameter UART_BAUDRATE = 115200
    )(
        input wire system_clk,
        input wire reset,
		output reg rxclk_en,
		output reg txclk_en
    );

    localparam  RX_ACC_MAX = (SYSTEM_CLOCK / (UART_BAUDRATE * 16))/2;
    localparam  TX_ACC_MAX = (SYSTEM_CLOCK / UART_BAUDRATE)/2;
    localparam  RX_ACC_WIDTH = $clog2(RX_ACC_MAX);
    localparam  TX_ACC_WIDTH = $clog2(TX_ACC_MAX);
    
    reg [RX_ACC_WIDTH - 1:0] rx_acc = 0;
    reg [TX_ACC_WIDTH - 1:0] tx_acc = 0;
    
    initial begin
        rxclk_en = 1'b0;
        txclk_en = 1'b0;
    end

    always @(posedge system_clk) begin
        if(reset == 1'b0) begin
            rx_acc <= RX_ACC_MAX;
        end else begin        
            if (rx_acc == RX_ACC_MAX[RX_ACC_WIDTH - 1:0]) begin
                rx_acc <= 1;
                rxclk_en <= ~rxclk_en;
            end else begin
                rx_acc <= rx_acc + 1'b1;
            end
        end
    end

    always @(posedge system_clk) begin
        if(reset == 1'b0) begin
            tx_acc <=  TX_ACC_MAX;
        end else begin 
            if (tx_acc == TX_ACC_MAX[TX_ACC_WIDTH - 1:0]) begin
                tx_acc <= 1;
                txclk_en <= ~txclk_en;
            end else begin
                tx_acc <= tx_acc + 1'b1;
            end
        end
    end

endmodule
