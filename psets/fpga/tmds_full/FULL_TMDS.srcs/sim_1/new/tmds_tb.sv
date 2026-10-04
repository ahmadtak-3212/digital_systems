`timescale 1ns / 1ps


module tmds_tb;
    //make logics for inputs and outputs!
    logic clk;
    logic rst;
    logic [7:0] input_data;
    logic [7:0] output_data;
    logic [9:0] transmit_cable;
  
    //If you have a 
    tmds_transmitter uut_tx (.clk_in(clk), 
                             .rst_in(rst),
                             .data_in(input_data),
                             .data_out(transmit_cable));
    //
    tmds_receiver    rx (.data_in(transmit_cable),
                         .data_out(output_data));                      
    always begin
        #5;  //every 5 ns switch...so period of clock is 10 ns...100 MHz clock
        clk = !clk;
    end
    //initial block...this is our test simulation
    initial begin
        $display("Starting Simulation! Are you excited? I'm excited."); //print nice message
        clk = 0; //initialize clk (super important)
        rst = 0; //initialize rst (super important)
        input_data = 8'b0000_0000;
        #10  //wait a little bit of time at beginning
        rst = 1; //reset system
        #10; //hold high for a few clock cycles
        rst=0; //pull low
        #100; //see what it does for all 0's
        for(integer i=0; i<255; i++)begin
            input_data = i;
            #10; //wait a little bit
        end
    end
endmodule //debounce_tb