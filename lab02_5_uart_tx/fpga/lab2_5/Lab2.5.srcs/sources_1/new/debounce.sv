`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 09:33:54 PM
// Design Name: 
// Module Name: debounce
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
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2021 10:07:28 PM
// Design Name: 
// Module Name: debounce
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

`default_nettype none
module debounce(    input  wire     clk_in, //clock in
                    input  wire     rst_in, //reset in
                    input  wire     bouncey_in,//raw input to the system
                    output logic    clean_out //debounced output
    );
   logic [19:0] count; // is 20 bits enough?
   logic old;

   always_ff @(posedge clk_in) begin
        //Your Verilog here!
        if(rst_in) begin 
            clean_out <= 0;
        end else begin 
            if(old == bouncey_in) begin 
                count <= count+1;
                if(count > 20'd999_999) begin 
                    clean_out <= old;
                end 
            end else begin 
                count <= 0;
            end 
            old <= bouncey_in;
         end 
   end

endmodule
`default_nettype wire