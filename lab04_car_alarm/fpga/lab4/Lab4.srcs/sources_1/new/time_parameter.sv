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
module time_parameter(
    input wire clock_in, reset_in, reprogram_in,
    input wire [1:0] interval_in, time_parameter_selector_in,
    input wire [3:0] time_value_in,
    output logic [3:0] time_value_out
    );
    logic [3:0] T_ARM_DELAY, T_DRIVER_DELAY, T_PASSENGER_DELAY, T_ALARM_ON;
    
    always_comb begin
        case(interval_in) 
            //Combinational Logic for when signals come in from the fsm
            2'b00 : time_value_out = T_ARM_DELAY;
            2'b01 : time_value_out = T_DRIVER_DELAY;
            2'b10 : time_value_out = T_PASSENGER_DELAY;
            2'b11 : time_value_out = T_ALARM_ON;
            default : time_value_out = T_ARM_DELAY;
        endcase
    end 
    always_ff @(posedge clock_in) begin
        //Logic For reprograming the time parameters
        if (reset_in) begin 
            T_ARM_DELAY <= 4'b0110;
            T_DRIVER_DELAY <= 4'b1000;
            T_PASSENGER_DELAY <= 4'b1111;
            T_ALARM_ON <= 4'b1010;
        end else if (reprogram_in) begin 
            case(time_parameter_selector_in) 
                2'b00: T_ARM_DELAY <= time_value_in;
                2'b01: T_DRIVER_DELAY <= time_value_in;
                2'b10: T_PASSENGER_DELAY <= time_value_in;
                2'b11: T_ALARM_ON <= time_value_in;
                default: T_ARM_DELAY <= time_value_in;
            endcase 
        end 
    end
endmodule
`default_nettype wire