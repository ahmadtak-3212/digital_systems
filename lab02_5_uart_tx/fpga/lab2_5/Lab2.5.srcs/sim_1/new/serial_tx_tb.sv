
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 11:43:45 PM
// Design Name: 
// Module Name: serial_tx_tb
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
module serial_tx_tb;
    logic clk;
    logic rst;
    logic trigger;
    logic[7:0] val;
    logic data;

    serial_tx my_serial(    .clk_in(clk),
                            .rst_in(rst),
                            .trigger_in(trigger),
                            .val_in(val),
                            .data_out(data));
    always begin
        #5;
        clk = !clk;
     end

     initial begin
        clk = 0;
        rst = 0;
        trigger = 0;
        val = 8'b0;
        #10000;
        rst = 1;
        #10;
        rst = 0;
        #10;
        val = 8'b1010_1010;
        #40;
        trigger = 1;
        #10;
        trigger = 0;
        #500;  //as you run it...should see 10101010 show up ont eh data out line
     end
endmodule
