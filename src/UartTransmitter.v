`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/11 01:09:24
// Design Name: 
// Module Name: transmitter
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

module UartTransmitter (
        input wire [7:0] din,
        input wire wr_en,
        input wire system_clk,
        input wire reset,
        input wire clken,
        output reg tx,
        output wire tx_busy
);

initial begin
	 tx = 1'b1;
end

localparam  TX_IDLE             = 1'h0,
            TX_START            = 1'h1;

localparam  STATE_IDLE          = 2'h0,
            STATE_SEND_DATA     = 2'h1,
            STATE_SEND_STOP_BIT = 2'h2,
            STATE_SEND_END      = 2'h3;
            

reg [7:0] data                  = 8'h00;
reg [2:0] bitpos                = 3'h0;
reg state                       = TX_IDLE;
reg [1:0] tx_state              = STATE_IDLE;

assign tx_busy      = (tx_state != STATE_IDLE);

always @(posedge system_clk) begin
    if(reset == 1'b0) begin
        state <= TX_IDLE;
    end else begin
        case (state)
            TX_IDLE: begin
                if (wr_en) begin
                    state <= TX_START;
                end 
            end
            
            TX_START: begin
                if(tx_state == STATE_SEND_END) begin
                    state <= TX_IDLE;
                end 
            end
        endcase
    end
end

always @(posedge clken) begin
    if(reset == 1'b0) begin
        tx_state <= STATE_IDLE;
    end else begin
        case (tx_state)
            STATE_IDLE: begin
                if (state == TX_START) begin
                    tx_state <= STATE_SEND_DATA;
                    data <= din;
                    tx <= 1'b0;
                    bitpos <= 3'h0;
                end 
            end
                
            STATE_SEND_DATA: begin
                if (bitpos == 3'h7) begin
                    tx_state <= STATE_SEND_STOP_BIT;
                end else begin
                    bitpos <= bitpos + 3'h1;
                end
                tx <= data[bitpos];
            end
            
            STATE_SEND_STOP_BIT: begin
                tx <= 1'b1;
                tx_state <= STATE_SEND_END;
            end
            
            STATE_SEND_END: begin
                tx_state <= STATE_IDLE;
            end
            
            default: begin
                tx <= 1'b1;
                tx_state <= STATE_IDLE;
            end 
        endcase
    end
end

endmodule