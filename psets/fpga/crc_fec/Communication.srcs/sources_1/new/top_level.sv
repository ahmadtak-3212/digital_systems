`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MIT
// Engineer: Ahmad Taka
// 
// Create Date: 10/20/2021 09:40:57 PM
// Design Name: 
// Module Name: top_level
// Project Name: Communication Lpset 11
// Additional Comments:
//      This is my full top level for the FEC Communication system
//////////////////////////////////////////////////////////////////////////////////

`default_nettype none

module top_level( 
    input wire clock, 
    input wire start,
    input wire data, 
    output logic done,
    output logic [6:0] cycle_counter, 
    output logic [95:0] fec_out,
    output logic control
    );
    //This Module only uses only two state variables one for montioring the state of the crc calculation
    // and another to store the result of that calculation. Note a third to store the output of crc concurrently.
    
    logic [15:0] r_temp;
     
      
    logic [15:0] r;
    crc crc1 (.clock(clock), .start(start), .data(data), 
        .done(control), .r(r));
        
    logic fec_data;
    fec fec1 (.clock(clock), .start(start), .data(fec_data), 
        .done(done), .fec(fec_out));
  
    always_comb begin 
        if(control) begin 
            fec_data = r_temp[15];
            r_temp = r;
        end else begin
            fec_data = data;
        end 
    end 
    always_ff @(posedge clock)  begin
        if (start) begin 
            cycle_counter <= 0; //
            r_temp <= 0; // sets states to 0
        end else begin 
            if (cycle_counter == 47) begin
                cycle_counter <= 0; //After 48 Cycles reset count
            end else begin 
                cycle_counter <= cycle_counter + 1;
            end
        end 
        if (control) begin
            r_temp <= r_temp << 1;
        end         
    end 
endmodule

`default_nettype wire