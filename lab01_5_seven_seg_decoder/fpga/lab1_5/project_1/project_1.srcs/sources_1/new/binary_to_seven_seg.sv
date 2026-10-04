`default_nettype none //prevents system from inferring an undeclared logic
module binary_to_seven_seg( 
        input wire [3:0]       bin_in,  //declaring input explicitely
        output logic [6:0]      hex_out);  //declaring output explicitely
       
        
        always @(bin_in) begin
            case (bin_in) 
                4'b0000 : hex_out = 7'h3F;
                4'b0001 : hex_out = 7'h06;
                4'b0010 : hex_out = 7'h5B;
                4'b0011 : hex_out = 7'h4F; 
                
                4'b0100 : hex_out = 7'h66; 
                4'b0101 : hex_out = 7'h6D; 
                4'b0110 : hex_out = 7'h7D; 
                4'b0111 : hex_out = 7'h07; 
                
                4'b1000 : hex_out = 7'h7F; 
                4'b1001 : hex_out = 7'h67; 
                4'b1010 : hex_out = 7'h77; 
                4'b1011 : hex_out = 7'h7C; 
                
                4'b1100 : hex_out = 7'h39; 
                4'b1101 : hex_out = 7'h5E; 
                4'b1110 : hex_out = 7'h79; 
                4'b1111 : hex_out = 7'h71; 
            endcase
        end 
    //your logic here
    //many ways to do this (syntatically)
    // assign statements with ternary operators or logical statements/equality checks
    // always_comb block with some if/else if/else logic inside
    // switch statement
    // etc.... this is up to you!

endmodule //binary_to_hex
`default_nettype wire //important to put at end (makes it work nicer with IP modules)