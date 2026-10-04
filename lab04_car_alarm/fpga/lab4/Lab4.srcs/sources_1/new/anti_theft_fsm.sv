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
// MAIN FSM
//
///////////////////////////////////////////////////////////////////////////////
module anti_theft_fsm(
    input wire clock_in, reset_in, reprogram_in, ignition_in, driver_in, passenger_in, time_expired_in,
    output logic [1:0] interval_out,
    output logic [2:0] state_out,
    output logic start_timer_out, alarm_out, status_out
    );
    enum {armed, disarmed, triggered, sound_alarm, sound_alarm_door_closed, disarmed_driver_door_open, disarmed_driver_door_close} state;
    logic [1:0] led_count;
    always_ff @(posedge clock_in) begin 
        if(reset_in || reprogram_in) begin 
            //Default State
            state <= armed;
        end else if (state == armed) begin
            //Logic For Armed State
            alarm_out <= 0;
            status_out <= 1; 
            state_out <= 3'b000;
            start_timer_out <= 0;
            if (ignition_in) begin 
                state <= disarmed;
            end else if (driver_in) begin
                interval_out <= 2'b01;
                start_timer_out <= 1;
                state <= triggered;
            end else if (passenger_in) begin
                interval_out <= 2'b10; 
                start_timer_out <= 1;
                state <= triggered;
            end 
        end else if (state == triggered) begin
            //Logic for Triggered State
            alarm_out <= 0;
            status_out <= 1; 
            state_out <= 3'b001;  
            start_timer_out <= 0;
            if (ignition_in ) begin 
                state <= disarmed;
            end else if (time_expired_in) begin 
               
                state <= sound_alarm;
            end 
        end else if (state == sound_alarm) begin 
            //Logic For Sound Alarm State
            alarm_out <= 1;
            status_out <= 1; 
            state_out <= 3'b010; 
            start_timer_out <= 0; 
            if (ignition_in) begin 
                state <= disarmed;
            end else if (!passenger_in && !driver_in) begin 
                start_timer_out <= 1;
                state <= sound_alarm_door_closed;   
            end 
        end else if(state == sound_alarm_door_closed) begin
           //Logic For when the Alarm is Sounding and the Doors are Closed 
           alarm_out <= 1;
           status_out <= 1; 
           state_out <= 3'b011;  
           interval_out <= 2'b11; 
           start_timer_out <= 0;
           if(time_expired_in) begin
                state <= armed;
           end
        end else if (state == disarmed ) begin 
            //Logic For when in the disarmed state
            alarm_out <= 0;
            status_out <= 0; 
            state_out <= 3'b100;  
            start_timer_out <= 0;
            if (!ignition_in && driver_in) begin 
                state <= disarmed_driver_door_open;
            end 
        end else if (state == disarmed_driver_door_open) begin 
            //Logic for when in the disarmed state and the driver door opens
            alarm_out <= 0;
            status_out <= 0; 
            state_out <= 3'b101; 
            start_timer_out <= 0;
            if (!driver_in) begin 
               start_timer_out <= 1; 
               state <= disarmed_driver_door_close;
            end 
        end else if (state == disarmed_driver_door_close) begin 
            //Logic for when in the disarmed state and the driver door closes
            alarm_out <= 0;
            status_out <= 0; 
            state_out <= 3'b110; 
            interval_out <= 2'b00;
            start_timer_out <= 0; 
            if (time_expired_in) begin 
                state <= armed;
            end 
        end 
    end 
    
endmodule
`default_nettype wire