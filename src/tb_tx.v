`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/03 05:34:12
// Design Name: 
// Module Name: test_send
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


module tb_tx( );
	
    reg [7:0] din;
	reg wr_en;
	reg system_clk;
	reg reset;
	reg rx;
	reg uart_clk;
	
	wire tx;
	wire tx_busy;
	wire rx_complete;
	wire [7:0] dout;
	wire deb_rx;
    wire deb_rx_complete;
    wire deb_rx_clk;
    wire [1:0] rx_error_bit;
    
    reg [3:0] iCount;
    
    // clk gen
    always
        #5 system_clk = ~system_clk;
    
        
    initial begin
        $display("initialize value [%0d]", $time);
        din = 8'b0;
        wr_en = 1'b0;
        system_clk = 1'b0;
        reset = 1'b1;
        rx = 1'b1;
        uart_clk = 1'b0;
        iCount = 0;
        
        // reset_n gen
        $display("Reset! [%0d]", $time);
        # 30
            reset = 0;
        # 10
            reset = 1;
        # 10
        @(posedge system_clk);
        
        //normal data 
        # 2000
        din = 8'hA5;
        wr_en = 1'b1;
        # 2000
        wr_en = 1'b0;
        wait(tx_busy); 
        
        wait(!tx_busy);
        din = 8'h5A;
        wr_en = 1'b1;        
        # 2000
        wr_en = 1'b0;        
        wait(tx_busy);    
         
        wait(!tx_busy);
        din = 8'hAA;
        wr_en = 1'b1;
        #2000
        wr_en = 1'b0;
        wait(tx_busy);
        
        wait(!tx_busy);
        #5000
        $display("Finish! [%d]", $time);
        $finish;
    end

    customUartTop #(
        .SYSTEM_CLOCK(100000000),
        .UART_BAUDRATE(115200)  
    ) tb_tx(
        .din(din),
	    .wr_en(wr_en),
	    .system_clk(system_clk),
	    .reset(reset),
	    .tx(tx),
	    .tx_busy(tx_busy),
	    .rx(rx),
	    .rx_complete(rx_complete),
	    .dout(dout),
	    .rx_error_bit(rx_error_bit),
	    .deb_rx(deb_rx),
        .deb_rx_complete(deb_rx_complete),
        .deb_rx_clk(deb_rx_clk)
    );

endmodule
