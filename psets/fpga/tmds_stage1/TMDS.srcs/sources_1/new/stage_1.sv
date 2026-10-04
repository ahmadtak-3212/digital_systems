`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2021 11:37:56 PM
// Design Name: 
// Module Name: stage_1
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
module stage_1 (input wire clk_in, 
               input wire rst_in, 
               input wire [7:0] s1_in, 
               output logic [8:0] s1_out
                );
     logic [7:0] op1, op2, transitions1, transitions2;
     assign op1 = {s1_in[7] ^ s1_in[6], s1_in[6] ^ s1_in[5], s1_in[5] ^ s1_in[4], s1_in[4] ^ s1_in[3], s1_in[3] ^ s1_in[2], s1_in[2] ^ s1_in[1], s1_in[1] ^ s1_in[0], s1_in[0]};
     assign op2 = {!(s1_in[7] ^ s1_in[6]), !(s1_in[6] ^ s1_in[5]), !(s1_in[5] ^ s1_in[4]), !(s1_in[4] ^ s1_in[3]), !(s1_in[3] ^ s1_in[2]), !(s1_in[2] ^ s1_in[1]), !(s1_in[1] ^ s1_in[0]), s1_in[0]};
     
     assign transitions1 = {(op1[7]^op1[6]),(op1[6]^op1[5]), (op1[5]^op1[4]),(op1[4]^op1[3]),(op1[3]^op1[2]),(op1[2]^op1[1]),(op1[1]^op1[0]), op1[0]};
     assign transitions2 = {(op2[7]^op2[6]),(op2[6]^op2[5]), (op1[5]^op2[4]),(op2[4]^op2[3]),(op2[3]^op2[2]),(op2[2]^op2[1]),(op2[1]^op2[0]), op2[0]};
    
     logic [3:0] tally1, tally2;
     logic [9:0] out;
     
     
     
     tallier t1(.byte_in(transitions1), .tally_out(tally1));
     tallier t2(.byte_in(transitions2), .tally_out(tally2));
     assign out = (tally1 < tally2) ? {1'b1, op1} : {1'b0, op2};
     
    
    always_ff @(posedge clk_in) begin
        if(rst_in) begin
            s1_out <= 9'b0_0000_0000;
        end else begin 
            s1_out <= out;
        end
    end
endmodule


module tallier(
    input wire [7:0] byte_in,
    output logic [3:0] tally_out
    ); 
    assign tally_out = byte_in[7] + byte_in[6] + byte_in[5] + byte_in[4] + byte_in[3] + byte_in[2] + byte_in[1] + byte_in[0];
endmodule

`default_nettype wire