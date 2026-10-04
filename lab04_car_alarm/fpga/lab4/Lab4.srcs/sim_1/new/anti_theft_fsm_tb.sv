`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
module anti_theft_fsm_tb;

   // Inputs
   logic clock, reset, reprogram, ignition, driver, passenger, time_expired;
   
   // Outputs
   logic [1:0] interval;
   logic [2:0] state;
   logic start_timer, alarm, status;
   
   

   // Instantiate the Unit Under Test (UUT)
   anti_theft_fsm uut (
      .clock_in(clock),
      .reset_in(reset),
      .reprogram_in(reprogram),
      .ignition_in(ignition), 
      .driver_in(driver), 
      .passenger_in(passenger),
      .time_expired_in(time_expired),
      .interval_out(interval),
      .state_out(state),
      .start_timer_out(start_timer),
      .alarm_out(alarm),
      .status_out(status)
   );

   always #20 clock = !clock;
   
   initial begin
      // Initialize Inputs
      clock = 0;
      reset = 0;
      reprogram = 0;
      ignition = 0;
      driver = 0;
      passenger = 0;
      time_expired = 0;
      // Wait 100 ns for global reset to finish
      #100;
      reset = 1;
      #10;
      reset = 0;
      #10;

      ignition = 1;
      #40;
      ignition = 0;
      #40;
      
      driver = 1;
      #40
      driver = 0;
      #40
      
      
       
      time_expired = 1;
      #40
      time_expired = 0;
      #40
      
      #100;
      
      passenger = 1;
      #40
      passenger = 0;
      #40
      
      #10000;
      
     
      $finish;
   end
      
endmodule