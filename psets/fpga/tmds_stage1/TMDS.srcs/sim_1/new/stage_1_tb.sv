`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2021 12:28:24 AM
// Design Name: 
// Module Name: stage_1_tb
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

module stage_1_tb;
//make logics for inputs and outputs!
    logic clk;
    logic rst;
    logic [7:0] input_data;
    logic [8:0] output_data;
  
    stage_1 uut (.clk_in(clk), 
                  .rst_in(rst),
                  .s1_in(input_data),
                  .s1_out(output_data));                    
    always begin
        #5;  //every 5 ns switch...so period of clock is 10 ns...100 MHz clock
        clk = !clk;
    end
    //initial block...this is our test simulation
    initial begin
        $display("Starting Simulation! Are you excited? I'm excited."); //print nice message
        clk = 0; //initialize clk (super important)
        rst = 0; //initialize rst (super important)
        input_data = 8'b0000_0000;
        #10  //wait a little bit of time at beginning
        rst = 1; //reset system
        #10; //hold high for a few clock cycles
        rst=0; //pull low
        for(integer i=0; i<255; i++)begin
            input_data = i;
            #10; //wait a little bit
        end
    end
endmodule
