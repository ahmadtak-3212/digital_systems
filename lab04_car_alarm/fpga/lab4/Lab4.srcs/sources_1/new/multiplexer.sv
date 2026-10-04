`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2021 11:52:37 PM
// Design Name: 
// Module Name: multiplexer
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

`default_nettype none

///////////////////////////////////////////////////////////////////////////////
//
// MULTIPLEXER
//
///////////////////////////////////////////////////////////////////////////////

module multiplexer(
    input wire clock_in, reset_in, led_status_in, one_hz_in,
    input wire [2:0] state_in,
    output logic led_out
    );
    parameter LED_INTERVAL = 2;
    logic [1:0] period_count;
    always_ff @(posedge clock_in) begin
        if(reset_in) begin
            period_count <= 0;
            led_out <= 0;
        end else if(state_in == 3'b000 && led_status_in) begin 
            // STATE is armed it will blink LED every LED_INTERVAL seconds
            if(one_hz_in) begin
                if (period_count == LED_INTERVAL - 1) begin
                   led_out <= 1;
                   period_count <= 0;
                end else begin
                   period_count <= period_count + 1;
                   led_out <= 0;  
                end 
            end 
        end else if(led_status_in) begin
            //IF status is high but its not in armed the LED should be solid 
            led_out <= 1;
        end else begin
            //else set to low
            led_out <= 0;
        end 
    end 
endmodule
`default_nettype wire