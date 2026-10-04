`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2021 07:17:44 PM
// Design Name: 
// Module Name: PSET5
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


module PSET5( 
    input wire clk_in,
    input wire req_in,  
    output logic ras_out, 
    output logic cas_out,
    output logic mux_out
    );
   logic [3:0] cycle;
   always_ff @(posedge clk_in) begin 
        if(req_in) begin
           cycle <= 3'd0;
        end else begin 
            case(cycle) 
                3'd0 : begin ras_out <= 1'b0; cycle <= 3'd1; end
                3'd1 : begin mux_out <= 1'b1; cycle <= 3'd2; end 
                3'd2 : begin cas_out <= 1'b0; cycle <= 3'd3; end 
                3'd3 : begin cycle <= 3'd4; end 
                default : begin mux_out <= 1'b0; cas_out <= 1'b1; ras_out <= 1'b1; end 
            endcase
        end 
    end 
endmodule
