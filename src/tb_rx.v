`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/01 22:41:42
// Design Name: 
// Module Name: tb_recv
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


module tb_rx( );
	
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
    wire debuging_high;
        
    reg [3:0] iCount;
    reg [7:0] rxData;
    
    // clk gen
    always
        #5 system_clk = ~system_clk;
    
    always
        #4340 uart_clk = ~uart_clk;
        
    initial begin
        $display("initialize value [%0d]", $time);
        din = 8'b0;
        wr_en = 1'b0;
        system_clk = 1'b0;
        reset = 1'b1;
        rx = 1'b1;
        uart_clk = 1'b0;
        iCount = 0;
        rxData = 8'hA5;
        
        // reset_n gen
        $display("Reset! [%0d]", $time);
        # 30
            reset = 0;
        # 10
            reset = 1;
        # 10
        @(posedge system_clk);
        
        //normal data 
        rxData = 8'hA5;
        # 2000
        for(iCount=0; iCount<10; iCount=iCount+1) begin
            @(posedge uart_clk);
            if(iCount == 0) begin
                rx = 1'b0;
            end else if(iCount == 9) begin
                rx = 1'b1;
            end else begin
                if(iCount == 1)
                    rx = rxData[0:0];
                else if(iCount == 2)
                    rx = rxData[1:1];
                else if(iCount == 3)
                    rx = rxData[2:2];
                else if(iCount == 4)
                    rx = rxData[3:3];
                else if(iCount == 5)
                    rx = rxData[4:4];
                else if(iCount == 6)
                    rx = rxData[5:5];
                else if(iCount == 7)
                    rx = rxData[6:6];
                else if(iCount == 8)
                    rx = rxData[7:7];                
            end            
        end
        
        //abnormal data, If the last bit is not 1(stop bit).
        rxData = 8'h5A;
        # 20000   
        for(iCount=0; iCount<10; iCount=iCount+1) begin
            @(posedge uart_clk);
            if(iCount == 0) begin
                rx = 1'b0;
            end else if(iCount == 9) begin
                rx = 1'b0;
            end else begin
                if(iCount == 1)
                    rx = rxData[0:0];
                else if(iCount == 2)
                    rx = rxData[1:1];
                else if(iCount == 3)
                    rx = rxData[2:2];
                else if(iCount == 4)
                    rx = rxData[3:3];
                else if(iCount == 5)
                    rx = rxData[4:4];
                else if(iCount == 6)
                    rx = rxData[5:5];
                else if(iCount == 7)
                    rx = rxData[6:6];
                else if(iCount == 8)
                    rx = rxData[7:7];                
            end            
        end
        rxData = 8'h0;
        rx = 1'b1;
        #2000000
        
        
        
        $display("Finish! [%d]", $time);
        $finish;
    end

    customUartTop #(
        .SYSTEM_CLOCK(99999001),
        .UART_BAUDRATE(115200)  
    ) tb_rx(
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
        .deb_rx_clk(deb_rx_clk),
        .debuging_high(debuging_high)
    );

	
	
endmodule
