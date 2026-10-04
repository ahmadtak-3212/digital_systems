`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testing input-output relationships for part one of lab one
// commented excessively for learning
//  jds
//////////////////////////////////////////////////////////////////////////////////


module top_tb;  // a test-bench module really doesn't need inputs and outputs. It is the top-level module
                // that doesn't have to interface with anything else outside since it is a simulation
                //. If a module has no input or output arguments, you don't need to add a parentheses.

//    In a testbench, the first step is to create appropriately sized logics for all the inputs and outputs
//    of the unit that you are testing!  This often requires some clicking back and forth to make sure things 
    
    logic [3:0] sw_in;
    logic [4:0] led_out;
    logic green_out;  //notice that we can name these whatever we want.
    logic blue_out;
    logic red_out;
    logic left_in;  //we're just declaring these things here. We'll assign them values down below
    logic center_in;
    logic right_in;
    
//    below we declare an instance of our module that we want to test. In the case of this testbench, 
//    we're testing the top_level module from top_level.sv.  We often call the module we're testing the 
//    "Unit Under Test" or uut for short, but this is just convention, you can call it lentil_soup, it doesn't matter.
//    You will forget this, but for reference in declaring a module in SystemVerilog the syntax is: 
//    NAME_OF_MODULE NAME_OF_INSTANCE (ARGUMENTS...);  As shown below, our module is top_level, and we're calling its instance
//    uut in this test bench.  
//    Also notice how we are explicitely specifying the module's inputs and outputs. You don't have to do this and could alternatively do:
//    top_level uut( sw_in,led_out,green_out,blue_out,red_out,left_in,center_in,right_in);  if you'd like! Just be careful since 
//    your input/output accounting can get screwed up in this manner, whereas explicit linkage is a bit safer easier to track.
//    Also note that I broke down the inputs/outputs to one-per line. This is for readability but is not required. Remember SystemVerilog 
//    is heavily influenced by C in syntax...which means you can make it as ugly or not-ugly as you want.
    
    top_level uut(  .sw(sw_in),
                    .led(led_out),
                    .led16_g(green_out),
                    .led16_b(blue_out),
                    .led16_r(red_out),
                    .btnl(left_in),
                    .btnc(center_in),
                    .btnr(right_in)
    );
    
//    so far we've only just set up all the connections...simulations usually take place in time. This one is especially weird
//     because everything is combinatorial and therefore isn't time-dependent, but we'll still simulate this module with some time
//     included for the sake of learning
     
     initial begin
        //set the inputs to the module to starting values here:
        sw_in       = 4'b0000;  //assign all four switches to be 0 (could have also done = 0;)
        left_in     = 1'b0; //one-bit value...assign it to 0
        center_in   = 1'b0;
        right_in    = 0;  //can also just write it as 0...Verilog is usually figures it out)
        #10; //Extremely important!!! make sure some time runs prior to analyzing outputs Even in a combinatorial-only system
        //here, #10 means "10 ns" based on the timescale unit up above at the top
        $display("\n\n---------\nStarting Simulation!");
        $display("sw_in\tleft_in\tcenter_in\tright_in\tled_out\tgreen_out\tblue_out\tred_out");
        $display("%4b\t%b\t\t%b\t\t\t%b\t\t\t%5b\t%b\t\t\t%b\t\t\t%b",
        sw_in,left_in,center_in,right_in,led_out,green_out,blue_out,red_out);
        left_in = 1'b1;
        #10; //10 ns pause
        $display("sw_in\tleft_in\tcenter_in\tright_in\tled_out\tgreen_out\tblue_out\tred_out");
        $display("%4b\t%b\t\t%b\t\t\t%b\t\t\t%5b\t%b\t\t\t%b\t\t\t%b",
        sw_in,left_in,center_in,right_in,led_out,green_out,blue_out,red_out);
        sw_in = 4'b1010;
        #10;
        $display("sw_in\tleft_in\tcenter_in\tright_in\tled_out\tgreen_out\tblue_out\tred_out");
        $display("%4b\t%b\t\t%b\t\t\t%b\t\t\t%5b\t%b\t\t\t%b\t\t\t%b",
        sw_in,left_in,center_in,right_in,led_out,green_out,blue_out,red_out);
        assert (red_out == 0) else $error("Bad");
        
        
        sw_in = 4'b0010;
        #10;
        $display("sw_in\tleft_in\tcenter_in\tright_in\tled_out\tgreen_out\tblue_out\tred_out");
        $display("%4b\t%b\t\t%b\t\t\t%b\t\t\t%5b\t%b\t\t\t%b\t\t\t%b",
        sw_in,left_in,center_in,right_in,led_out,green_out,blue_out,red_out);
        

        sw_in = 4'b1000;
        #10;
        $display("sw_in\tleft_in\tcenter_in\tright_in\tled_out\tgreen_out\tblue_out\tred_out");
        $display("%4b\t%b\t\t%b\t\t\t%b\t\t\t%5b\t%b\t\t\t%b\t\t\t%b",
        sw_in,left_in,center_in,right_in,led_out,green_out,blue_out,red_out);        
  
        
        $finish; //call this at the end of your test.
     end
endmodule //top_level_tb  (i usually try to do this so I know where this endmodule is supposed to be associated