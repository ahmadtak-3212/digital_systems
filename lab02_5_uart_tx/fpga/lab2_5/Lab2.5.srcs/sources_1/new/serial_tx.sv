`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 09:35:58 PM
// Design Name: 
// Module Name: serial_tx
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
module serial_tx(   input wire      clk_in,
                    input wire      rst_in,
                    input wire      trigger_in,
                    input wire [7:0]    val_in,
                    output logic    data_out);
    parameter   DIVISOR = 868; //treat this like a constant!!
    
    logic [9:0]         shift_buffer; //10 bits...interesting
    logic [31:0]        time_count;
    
    always_ff @(posedge clk_in) begin
        if(rst_in) begin 
            shift_buffer <= 10'b0;
            time_count <= 32'b0;   
            data_out <= 1'b1;
        end else begin               
            if(trigger_in) begin 
                shift_buffer = {1'b1, val_in, 1'b0};
                time_count <= 32'b0;   
            end 
            if(time_count >= DIVISOR - 1) begin 
                time_count <= 32'b0;   
                data_out <= shift_buffer[0];
                shift_buffer <= {1'b1, shift_buffer[9:1]};
            end else begin
                time_count <= time_count + 32'b1;
            end   
        end 
    end              
endmodule
`default_nettype wire
