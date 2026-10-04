`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2021 06:07:45 PM
// Design Name: 
// Module Name: blob
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

//////////////////////////////////////////////////////////////////////
//
// blob: generate rectangle on screen
//
//////////////////////////////////////////////////////////////////////
`default_nettype none
module circle (
        input wire clock_in, reset_in,
        input wire [10:0] x_in,hcount_in,
        input wire [9:0] y_in,vcount_in,
        output logic [11:0] pixel_out);

    parameter  RADIUS = 64;           // default height: 100 pixels
    parameter  COLOR = 12'hFFF;
    parameter RADIUS_SQUARED = RADIUS*RADIUS;
    
    logic [10: 0] old_delta_x, deltax; // can't be bigger than the screen
    logic [9: 0] old_delta_y, deltay; // can't be bigger than the screen
    logic [21: 0] delta_x_sq; // times 2 for squaring 
    logic [19: 0] delta_y_sq; // times 2 for squaring
    always_comb begin // generate round puck
            // compute x-xcenter and y-ycenter
            deltax = (hcount_in > (x_in+RADIUS)) ? (hcount_in-(x_in+RADIUS)) : ((x_in+RADIUS)-hcount_in);
            deltay = (vcount_in > (y_in+RADIUS)) ? (vcount_in-(y_in+RADIUS)) : ((y_in+RADIUS)-vcount_in);
            // check if distance is less than radius squared
            if(delta_x_sq + delta_y_sq <= RADIUS_SQUARED) begin
                  pixel_out = COLOR;
            end else begin 
                  pixel_out = 0;   
            end
    end    
endmodule


`default_nettype wire