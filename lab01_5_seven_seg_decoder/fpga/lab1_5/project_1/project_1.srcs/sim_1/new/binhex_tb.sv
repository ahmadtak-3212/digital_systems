`timescale 1ns / 1ps
`default_nettype none //prevents system from inferring an undeclared logic


module binhex_tb;

    logic [3:0] sw;
    logic [6:0] leds;
    
    binary_to_seven_seg my_display(.bin_in(sw), .hex_out(leds));
    
    int answers[15:0];
    
    
    initial begin    
        answers = '{ 7'h3F,
                     7'h06,
                     7'h5B,
                     7'h4F,
                     7'h66,
                     7'h6D,
                     7'h7D,
                     7'h07,
                     7'h7F,
                     7'h67,
                     7'h77,
                     7'h7C,
                     7'h39,
                     7'h5E,
                     7'h79,
                     7'h71      
        };
        $display("Starting Sim");
        for (int i = 0; i < $size(answers); i++) begin
            sw = i; //i goes from 0 to 15
            #10; //wait 10ns
            $display("Input is: %4b, Output is %7b",sw,leds);
            //Now check that a binary 1 input results in a hex-display "1":
            
            assert(leds==answers[15-i]) else $error("Didn't %d draw right :/", i);
        end 

        $finish;
    end
endmodule
`default_nettype wire //important to put at end (makes it work nicer with IP modules)