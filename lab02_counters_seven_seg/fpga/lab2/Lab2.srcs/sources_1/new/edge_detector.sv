`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2021 10:54:16 PM
// Design Name: 
// Module Name: edge_detector
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
module edge_detector(
        input wire old_clean,
        input wire rst_in,
        output wire rising_clean
    );
    //clean&!old_clean is a signal that indicates a "rising edge":
    assign rising_clean = clean & !old_clean;
    always_ff @(posedge clk_100mhz)begin
        if (rst_in)begin
            old_clean <= 1'b0;
        end else begin
            old_clean <= clean;
        end
    end
    
endmodule
`default_nettype wire