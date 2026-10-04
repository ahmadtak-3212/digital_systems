`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2021 02:09:50 AM
// Design Name: 
// Module Name: top_level
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


module crc(
    input wire clock,
    input wire start,
    input wire data, 
    output logic done, 
    output logic [15:0] r
    );
    logic [5:0] bit_counter; //Counts to 48 bits
    always_ff @(posedge clock) begin 
        if (start) begin 
            //Initial Trigger
            r <= 16'hFFFF;
            done <= 1'b0;
            bit_counter <= 1'd0;
        end else begin 
            if (bit_counter == 6'd48) begin 
            //Termination
                done <= 1'b1;
                bit_counter <= 1'd0;
            end else begin 
            //FSM LOGIC
                bit_counter <= bit_counter + 1'd1;
                r[0] <= data + r[15];
                r[1] <= r[0];
                r[2] <= r[15] + r[1] + data;
                for(int i = 3; i < 15; i++) begin r[i] <= r[i - 1]; end //All registers 3-14 are equal to previous
                r[15] <= r[14] + r[15] + data;
             end   
        end 
    end 
endmodule
