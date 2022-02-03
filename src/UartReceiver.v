`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/11 01:08:45
// Design Name: 
// Module Name: receiver
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
//


module UartReceiver(
        input   wire rx,
        output  wire rx_complete,
        input   wire system_clk,
        input   wire reset,
        input   wire uart_clk,
        output  reg [7:0] data,
        output  reg [1:0] rx_error_bit,
        ///////////DEBUG////////////
        output  wire deb_rx,
        output  wire deb_rx_complete,
        output  wire deb_rx_clk
);
        
localparam  RX_STATE_START          = 2'h0,
            RX_STATE_DATA           = 2'h1,
            RX_STATE_STOP           = 2'h2,
            RX_CLOCK_OFF            = 2'h3;

localparam  RX_CHECK_START_BIT      = 2'h0,
            SET_RX_CLK_RESET        = 2'h1,
            DATA_RECEVING           = 2'h2;
            
localparam  RECEIVED_DATA_SUCCESS   = 2'h0,
            NO_DATA_RECEIVED        = 2'h1,
            STOP_BIT_ERROR          = 2'h2;            

initial begin
    data            = 8'b0;
    rx_error_bit    = RECEIVED_DATA_SUCCESS;
end


    
reg [1:0] reg_rx_start_stop_state   = RX_CHECK_START_BIT;
reg [1:0] state                     = RX_STATE_START;
   
always @(posedge system_clk) begin
    if(reset == 1'b0) begin
        reg_rx_start_stop_state <= RX_CHECK_START_BIT;
    end else begin
        case(reg_rx_start_stop_state)
            RX_CHECK_START_BIT: begin
                if(!rx) begin
                    reg_rx_start_stop_state <= DATA_RECEVING;
                end else begin
                    reg_rx_start_stop_state <= RX_CHECK_START_BIT;
                end
            end
            
            DATA_RECEVING: begin 
                if(state == RX_CLOCK_OFF) begin
                    reg_rx_start_stop_state <= RX_CHECK_START_BIT;
                end else begin
                    reg_rx_start_stop_state <= DATA_RECEVING;
                end
            end
        endcase
    end
end


reg [4:0] sample                = 0;
reg [3:0] bitpos                = 0;
reg [7:0] scratch               = 8'b0;
reg reg_rx_complete             = 1'b0;
reg [6:0] no_data_receive_count = 3'h0;

assign rx_complete  = reg_rx_complete;
//or negedge 
always @(posedge uart_clk )  begin
    if(reset == 1'b0) begin
        state <= RX_STATE_START;
        sample <= 0;
    end else begin 
        case (state)            
            RX_STATE_START: begin
                if (!rx || sample != 0) begin
                    sample <= sample + 4'b1;
                end else begin
                    if(no_data_receive_count == 7'h7F)begin
                        rx_error_bit <= NO_DATA_RECEIVED;
                        no_data_receive_count <= 0;                    
                    end else begin
                        no_data_receive_count <= no_data_receive_count + 1'b1;
                    end
                end
                if (sample == 5'h10) begin
                    state <= RX_STATE_DATA;
                    rx_error_bit <= RECEIVED_DATA_SUCCESS;    
                    no_data_receive_count <= 0;                  
                    bitpos <= 0;
                    sample <= 0;
                    scratch <= 0;                    
                end
            end
            
            RX_STATE_DATA: begin
                sample <= sample + 1'b1;
                if (bitpos == 4'h8 && sample == 5'hA) begin
                    state <= RX_STATE_STOP;
                    sample <= 0;
                    if(rx == 1'b1) begin
                        rx_error_bit <= RECEIVED_DATA_SUCCESS;
                    end else begin
                        rx_error_bit <= STOP_BIT_ERROR;
                    end                    
                end else if(sample == 5'hF) begin
                    sample <= 0;
                end
                if (sample == 5'h8) begin
                    scratch[bitpos[2:0]] <= rx;
                    bitpos <= bitpos + 1'b1;
                end
            end
            
            RX_STATE_STOP: begin     
                if (sample == 3'h5 ) begin
                    state <= RX_CLOCK_OFF;	
                    reg_rx_complete <= 1'b0;
                    sample <= 0;
                end else begin
                    if(rx_error_bit == RECEIVED_DATA_SUCCESS) begin                        
                        data <= scratch;    
                    end else begin
                        data <= 8'b0;
                    end
                    reg_rx_complete <= 1'b1;
                    sample <= sample + 4'b1;
                end
            end
            
            RX_CLOCK_OFF: begin
                state <= RX_STATE_START;
            end
        endcase
    end
end

assign deb_rx           = rx;
assign deb_rx_complete  = reg_rx_complete;
assign deb_rx_clk       = uart_clk;

endmodule