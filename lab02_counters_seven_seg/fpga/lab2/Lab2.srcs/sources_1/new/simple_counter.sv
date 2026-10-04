`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2021 05:27:30 PM
// Design Name: 
// Module Name: simple_counter
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

module simple_counter(  input wire          clk_in,
                        input wire          rst_in,
                        input wire          evt_in,
                        output logic[15:0]  count_out
    );
    
    always_ff @(posedge clk_in)begin
        if(rst_in)begin
            count_out <= 16'b0; //reset signal
        end else begin
            //your code here
            if(evt_in) begin
                count_out <= count_out + 1;
            end
        end
    end
endmodule
`default_nettype wire
