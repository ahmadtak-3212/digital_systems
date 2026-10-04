`default_nettype none //prevents system from inferring an undeclared logic

module top_level(
                    input wire [3:0] sw, //note you can also specify inputs and outputs in line like this
                    output logic      ca, //you'll see both this way (and the previous way), is matter of
                    output logic      cb, //legacy and preference
                    output logic      cc,
                    output logic      cd,
                    output logic      ce,
                    output logic      cf,
                    output logic      cg
    );
   
    //create a linker array to take the output of our module (will make sense below)
    logic [6:0] led_out;
   
    //create an instance of our binary_to_seven_seg module!  Feed in sw to the input
    //and feed otu the output to the led_out array which we'll do operations on below.
    //notice the instance syntax is the same as what appeared in the testbench above!
    //...in otherwords: NAME_OF_MODULE NAME_OF_INSTANCE(inputs,outputs);
    binary_to_seven_seg my_converter ( .bin_in(sw), .hex_out(led_out));
   

    //the values we want to assign to the cathode pins should be the logical inverse of s
    //what our module above generates so do a bitwise inversion and assign that to all the pins!
    assign {cg,cf,ce,cd,cc,cb,ca} = ~led_out; 
    
endmodule //top_level
`default_nettype wire //important to put at end (makes it work nicer with IP modules)