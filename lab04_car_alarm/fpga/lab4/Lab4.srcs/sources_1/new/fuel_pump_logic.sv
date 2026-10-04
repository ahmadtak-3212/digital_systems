`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2021 02:26:00 PM
// Design Name: 
// Module Name: fuel_pump_logic
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
// TIME PARAMETER MODULE
//
///////////////////////////////////////////////////////////////////////////////

module fuel_pump_logic(
     input wire clock_in, reset_in, ignition_in, hidden_sw_in, brake_in,
     output logic fuel_pump_led_out
    );
    enum {idle, waiting, led_on} state;
    always_ff @(posedge clock_in) begin 
        if(reset_in) begin 
            state <= idle;
        end else if (state == idle) begin 
            fuel_pump_led_out <= 0;
            if(ignition_in) begin 
                state <= waiting;
            end 
        end else if (state == waiting) begin 
            fuel_pump_led_out <= 0;
            if (hidden_sw_in && brake_in ) begin
                state <= led_on;
            end  
        end else if (state == led_on) begin 
            fuel_pump_led_out <= 1;
            if(!ignition_in) begin 
                state <= idle;
            end 
        end 
            
    end     

endmodule
`default_nettype wire