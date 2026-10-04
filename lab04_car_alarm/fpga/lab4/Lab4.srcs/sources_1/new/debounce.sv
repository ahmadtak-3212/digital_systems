///////////////////////////////////////////////////////////////////////////////
//
// Pushbutton Debounce Module (LAB4 STARTER CODE)
//
///////////////////////////////////////////////////////////////////////////////
`default_nettype none
module debounce (input wire reset_in, clock_in, noisy_in,
                 output logic clean_out);
   parameter DEBOUNCE_COUNT = 1000000;
   logic [19:0] count;
   logic new_input;

   always_ff @(posedge clock_in)
     if (reset_in) begin 
        new_input <= noisy_in; 
        clean_out <= noisy_in; 
        count <= 0; end
     else if (noisy_in != new_input) begin new_input<=noisy_in; count <= 0; end
     else if (count == DEBOUNCE_COUNT) clean_out <= new_input;
     else count <= count+1;
endmodule
`default_nettype wire