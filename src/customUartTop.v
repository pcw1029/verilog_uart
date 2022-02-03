`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/11 01:06:51
// Design Name: 
// Module Name: uart
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module customUartTop # (
        parameter SYSTEM_CLOCK = 100000000,
        parameter UART_BAUDRATE = 115200        
    )(
        input wire [7:0] din,
	    input wire wr_en,
	    input wire system_clk,
	    input wire reset,
	    output wire tx,
	    output wire tx_busy,
	    input wire rx,
	    output wire rx_complete,
	    output wire [7:0] dout,
	    output wire [1:0] rx_error_bit,
	    ///////////DEBUG////////////
        output wire deb_rx,
        output wire deb_rx_complete,
        output wire deb_rx_clk
	);
	
	

wire rxclk_en, txclk_en;

    
BaudRateGenerator #(
    .SYSTEM_CLOCK(SYSTEM_CLOCK),
    .UART_BAUDRATE(UART_BAUDRATE)
) uart_baud(
    .system_clk(system_clk),
    .reset(reset),
    .rxclk_en(rxclk_en),
    .txclk_en(txclk_en)
);

UartTransmitter uart_tx(
    .din(din),
    .wr_en(wr_en),
    .system_clk(system_clk),
    .reset(reset),
    .clken(txclk_en),
    .tx(tx),
    .tx_busy(tx_busy)
);


UartReceiver uart_rx(
    .rx(rx),
    .rx_complete(rx_complete),   
    .system_clk(system_clk),
    .reset(reset),
    .uart_clk(rxclk_en),
    .data(dout),
    .rx_error_bit(rx_error_bit),
    ///////////DEBUG////////////
    .deb_rx(deb_rx),
    .deb_rx_complete(deb_rx_complete),
    .deb_rx_clk(deb_rx_clk)
);

endmodule