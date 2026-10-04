`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2021 10:18:39 PM
// Design Name: 
// Module Name: debounce_tb
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
module debounce_tb;
    //make logics for inputs and outputs!
    logic clk;
    logic rst;
    logic dirty;
    logic clean;  
    //make an instance of the counter...call it uut or my_counter or something else
    debounce uut(               .clk_in(clk),
                                .rst_in(rst),
                                .bouncey_in(dirty),
                                .clean_out(clean));                            
    //An always block in simulation **always** runs in the background
    //this is your standard way of making a clock below:
    //it says: every 5 ns, make clk be !clk
    //still need to initialize clk in an initial block
    always begin
        #5;  //every 5 ns switch...so period of clock is 10 ns...100 MHz clock
        clk = !clk;
    end
    //initial block...this is our test simulation
    initial begin
        $display("Starting Sim"); //print nice message
        clk = 0; //initialize clk (super important)
        rst = 0; //initialize rst (super important)
        dirty = 0; //initialize evt (super important)
        #20  //wait a little bit of time at beginning
        rst = 1; //reset system
        #20; //hold high for a few clock cycles
        rst=0; //pull low
        #20; //wait a little bit
        dirty = 1; //push the button
        #15000000; //wait a bit...
        dirty = 0; //release the button
    end
endmodule //debounce_tb