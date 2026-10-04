//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2021 08:51:50 PM
// Design Name: 
// Module Name: total_system
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

`default_nettype none  //ensure undeclared variable aren't inferred for you.

module total_system(
    input wire [2:0] a_in,
    input wire [5:0] b_in, 
    output logic [4:0] f_out 
    );
    logic [2:0] s_out_0;
    logic [1:0] s_out_1;
    logic [1:0] s_out_2;
    logic [3:0] s_out_3;
    logic [1:0] s_out_4;
    logic [4:0] s_out_5;
    m0 module_0 (.s_in(a_in), .s_out(s_out_0));
    m1 module_1 (.a_in(s_out_0), .b_in(b_in), .s_out(s_out_1));
    m2 module_2 (.a_in(s_out_0), .b_in(b_in), .s_out(s_out_2));
    m3 module_3 (.a_in(a_in), .b_in(b_in), .s_out(s_out_3));
    m4 module_4 (.a_in(s_out_1), .b_in(s_out_2), .s_out(s_out_4));
    m5 module_5 (.a_in(s_out_4), .b_in(s_out_3), .s_out(s_out_5));
    assign f_out = s_out_5;
   //  YOUR CODE HERE
endmodule

`default_nettype wire
