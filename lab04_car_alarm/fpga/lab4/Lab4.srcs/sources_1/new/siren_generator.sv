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
// SIREN GENERATOR
//
///////////////////////////////////////////////////////////////////////////////
module siren_generator(
    input wire clock_in, reset_in, alarm_in, one_hz_in,
    output logic wave_out
    );
    parameter HIGH_FREQ = 14205;
    parameter LOW_FREQ = 28409;
    parameter ONE_HZ = 25_000_000;

    logic [31:0] period_count_low;
    logic [31:0] period_count_high;
    logic state;
    always_ff @(posedge clock_in) begin        
        if(reset_in) begin 
            period_count_low <= 0;
            period_count_high <= 0;
            wave_out <= 0;
            state <= 0;
        end else if(alarm_in) begin 
            if (one_hz_in) begin 
                // if one hz is pulled high it changes states should happen every second
                 state <= ~state;
                 
            end 
            if (state) begin
                //High freqency counter 
                if (period_count_high >= HIGH_FREQ) begin 
                    wave_out <= ~wave_out;
                    period_count_high <= 0;
                end else begin  
                    period_count_high <= period_count_high + 1;
                end
            end else begin
                //Low frequency counter
                if (period_count_low >= LOW_FREQ) begin 
                    wave_out <= ~wave_out;
                    period_count_low <= 0;
                end else begin
                    period_count_low <= period_count_low + 1;
                end
            end 
        end 
    end    
endmodule
`default_nettype wire