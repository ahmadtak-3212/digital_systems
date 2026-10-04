`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2021 09:57:40 PM
// Design Name: 
// Module Name: top_level_tb
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


`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////
//
// lpset Top_Level test bench  9/25/2019
//
/////////////////////////////////////////////////////////////////////////////

module top_level_tb;

   // Inputs
   logic clock;
   logic data_clk;
   logic start;
   logic data;

   // Outputs
   logic done;
   logic [95:0] fec;
   logic [6:0] cycle_counter;
   logic control;

   // Instantiate the Unit Under Test (UUT)
   top_level uut (
      .clock(clock), 
      .start(start), 
      .data(data), 
      .done(done), 
      .fec_out(fec),
      .cycle_counter(cycle_counter),
      .control(control)
   );

 // this is the input data
   logic [47:0] input_data = 48'h03_01_02_03_30_3A;
   integer i;      // required for "for" loop

   initial begin   // system clock
      forever #5 clock = !clock;
      end
      
   initial begin   // data_clk, ensures setup time met               
      #2
      forever #5 data_clk = !data_clk;
      end
      
   initial begin
      // Initialize Inputs
      clock = 0;
      data_clk = 0;
      start = 0;
      data = 0;

      // Wait 100 ns for global reset to finish
      #100;
        
      // Add stimulus here
      start=1;
      #10 start = 0;
      #5;	// change if necessary for your design

      //forever #5 data_clk = !data_clk;
       for (i=0; i<50; i=i+1)
       begin
         data = input_data[47];
         // at each clock, left shift the data
         // note syntax for test bench "for" loop - no "always"
         // note the blocking assignment (immediate)
         @(posedge data_clk) input_data = {input_data[46:0],1'b0};     
       end
        
   $stop; // Pause simulation   
   end
      
endmodule
