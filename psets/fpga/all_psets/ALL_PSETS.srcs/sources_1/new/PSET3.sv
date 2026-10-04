`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2021 03:17:41 PM
// Design Name: 
// Module Name: PSET3
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

module PSET3( 
    input wire trigger_in, clk_in,
    output logic pulse_out
);
    logic prev_state;  
    always_ff @(posedge clk_in) begin 
        if(prev_state) begin
            pulse_out <= 0;
            prev_state <=  trigger_in;
        end else begin
            if(trigger_in) begin
                pulse_out <= 1;
                prev_state <= 1;
            end 
        end
    end
endmodule

module PSET32(
    input wire [7:0] byte_in,
    output logic [3:0] tally_out
    ); 
    assign tally_out = byte_in[7] + byte_in[6] + byte_in[5] + byte_in[4] + byte_in[3] + byte_in[2] + byte_in[1] + byte_in[0];
endmodule


`default_nettype wire