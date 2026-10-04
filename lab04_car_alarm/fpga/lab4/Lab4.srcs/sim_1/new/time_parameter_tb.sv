`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////

module time_parameter_tb;

   // Inputs
   logic clk, rst, reprogram;
   logic [1:0] interval, time_selector;
   logic [3:0] time_value;

   // Outputs
   logic  [3:0] time_value_output;

   // Instantiate the Unit Under Test (UUT)
   time_parameter uut (
      .clock_in(clk),
      .reset_in(rst),
      .reprogram_in(reprogram),
      .interval_in(interval), 
      .time_parameter_selector_in(time_selector),
      .time_value_in(time_value),
      .time_value_out(time_value_output)
   );

   always #5 clk = !clk;
   
   initial begin
      // Initialize Inputs
      clk = 0;    
      rst = 0; 
      interval = 2'b00;
      time_selector = 2'b00;
      time_value = 4'b1111;
      reprogram = 0;
      // Wait 100 ns for global reset to finish
      #100;
      
      rst = 1;
      #10;
      rst = 0;
      #20
      reprogram = 1;
      #10 
      reprogram = 0;
      
      // Add stimulus here

   end
      
endmodule