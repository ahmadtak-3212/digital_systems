`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 07:30:10 PM
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
module multiplexer( 
    input wire [15:0] in_sw,
    input wire [15:0] in_count,
    input wire [15:0] in_10hz,
    input wire in_btnc,
    input wire in_btnl,
    output logic [15:0] out_val
    );
    always_comb begin 
        if(in_btnl) begin
            out_val  = in_count;
        end else begin 
            if(in_btnc) begin 
                out_val = in_10hz;
            end else begin
                out_val = in_sw;
            end 
            
        end
        
    end
endmodule
`default_nettype wire