`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////

module top_level_tb;

   //System Inputs
   logic clk_100mhz;
   logic hidden_switch;
   logic brake_depressed;
   logic driver_door;
   logic passenger_door;
   logic ignition_switch;
   logic [1:0] time_parameter_selector;
   logic [3:0] time_value;
   logic reprogram;
   logic system_reset;

   //System Outputs:

   logic status_light;
   logic fuel_pump_power;
   logic siren_out;
   logic ca,cb,cc,cd,ce,cf,cg;
   logic [7:0] an;
   logic siren_out;



   top_level #(.LOW_FREQ(20), .HIGH_FREQ(5), .ONE_HZ_PERIOD(100), .DEBOUNCE_COUNT(1)) uut(
               .clk_100mhz(clk_100mhz), 
               .sw({system_reset, ignition_switch, 8'b0, time_parameter_selector, time_value}), 
               .btnc(reprogram), 
               .btnu(hidden_switch), 
               .btnl(driver_door), 
               .btnd(brake_depressed), 
               .btnr(passenger_door),
               .led({fuel_pump_power, status_light}), 
               .ca(ca),.cb(cb),.cc(cc),.cd(cd),.ce(ce),.cf(cf),.cg(cg), 
               .an(an),  
               .ja(siren_out)
               );

   always #5 clk_100mhz = !clk_100mhz;
   
   initial begin
      // Initialize Inputs
      clk_100mhz = 0;
      hidden_switch = 0;
      brake_depressed = 0;
      driver_door = 0;
      passenger_door = 0;
      ignition_switch = 0;
      time_parameter_selector = 2'b0;
      time_value = 4'b0000;
      reprogram = 0;
      system_reset = 0;

      // Wait 5 ns, good to go:
      #10000;
      
      #5;
      system_reset = 1;
      #40;
      system_reset = 0;
      #40;
      
      #200;
      driver_door = 1;
      #40
          
      
      
      //add your test cases below. Please trust us, debugging on the testbench can be much more fruitful than on the hardware directly.
      #10000;
      $finish;

   end
      
endmodule