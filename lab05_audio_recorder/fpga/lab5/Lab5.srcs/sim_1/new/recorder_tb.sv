`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2021 08:35:13 PM
// Design Name: 
// Module Name: recorder_tb
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


module recorder_tb;

   // Inputs
   logic clk;
   logic rst;
   logic record;
   logic ready;
   logic filter;
   logic signed[7:0] mic;
    

   // Outputs
   logic  signed[7:0] data;

   // Instantiate the Unit Under Test (UUT)
   recorder uut(
          .clk_in(clk),              // 100MHz system clock
          .rst_in(rst),               // 1 to reset to initial state
          .record_in(record),            // 0 for playback, 1 for record
          .ready_in(ready),             // 1 when data is available
          .filter_in(filter),            // 1 when using low-pass filter
          .mic_in(mic),         // 8-bit PCM data from mic
          .data_out(data)       // 8-bit PCM data to headphone
    ); 
   always #5 clk = !clk;
   
   initial begin
      // Initialize Inputs
        clk = 0;
        rst = 0;
        record = 0;
        ready = 0;
        filter = 0;
        mic = 0;
            
        // Wait 100 ns for global reset to finish
        #100;
        #10;
        rst = 1;
        #10;
        rst = 0;
      // Add stimulus here

   end
      
endmodule
