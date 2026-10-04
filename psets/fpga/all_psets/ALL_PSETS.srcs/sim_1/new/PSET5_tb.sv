`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2021 08:40:03 PM
// Design Name: 
// Module Name: PSET5_tb
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


module PSET5_tb();
    logic clk_in;
    logic req;
    logic mux;
    logic cas;
    logic ras;
    
    initial req = 1'b0;
    initial mux = 1'b0;
    initial ras = 1'b1;
    initial cas = 1'b1;
    initial clk_in =1'b0;
    
    always begin 
        #10;
        clk_in = !clk_in;
    end 
   PSET5 uut(.clk_in(clk_in), .req_in(req), .ras_out(ras), .cas_out(cas), .mux_out(mux)); 
   initial begin
      #30;  
      req = 1'b1;
      #30;
      req = 1'b0;
        
   end 
    
endmodule
