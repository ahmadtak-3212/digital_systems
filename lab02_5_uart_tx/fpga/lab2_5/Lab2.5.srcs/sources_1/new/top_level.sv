`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 09:22:20 PM
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

`default_nettype none

module top_level(   input wire              clk_100mhz,
                    input wire [15:0]       sw,
                    input wire              btnc,
                    input wire              btnd,
                    output logic [15:0]     led,
                    output logic            uart_rxd_out
    );
   
    logic               clean;
    logic               old_clean;
    assign led = sw;
    
    always_ff @(posedge clk_100mhz)begin
        old_clean <= clean;  //for rising edge detection
    end
    
    debounce my_deb(.clk_in(clk_100mhz), 
                    .rst_in(btnd),
                    .bouncey_in(btnc), 
                    .clean_out(clean));
    
    serial_tx my_tx(.clk_in(clk_100mhz), 
                    .rst_in(btnd), 
                    .trigger_in(clean&~old_clean),
                    .val_in(sw[7:0]),
                    .data_out(uart_rxd_out));
endmodule//top_level


`default_nettype wire
