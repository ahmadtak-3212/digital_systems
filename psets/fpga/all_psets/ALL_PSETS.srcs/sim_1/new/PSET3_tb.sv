`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2021 03:22:22 PM
// Design Name: 
// Module Name: PSET3_tb
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

module PSET3_tb;
    logic [1:0] trigger;
    logic [1:0] clk;
    logic pulse;
    
    initial clk = 0;
    initial trigger = 0;
    initial pulse = 0;
   
    PSET3 pulser(.trigger_in(trigger), .clk_in(clk), .pulse_out(pulse));
    
    always begin
        #1;
        clk = !clk;
    end 
    always begin
        #100;
        trigger = !trigger;
    end 
    
    
    initial begin
        
        $display("Starting Sim");
        #1000;
        $finish;
    end 
   
endmodule
`default_nettype wire