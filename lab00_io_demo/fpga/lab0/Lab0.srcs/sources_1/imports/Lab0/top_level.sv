//////////////////////////////////////////////////////////////////////////////////
// Simple Input-Output Demo on the Nexys 4 DDR for 6.111 Fall 2019
// jodalyst 8/2019
// 
//////////////////////////////////////////////////////////////////////////////////

module top_level(   input                   clk_100mhz, //clock
                    input [15:0]            sw,         //switches
                    input                   btnc,       //center button
                    input                   btnu,      //up button
                    input                   btnl,       //left button
                    input                   btnr,       //right button
                    input                   btnd,       //down button
                    output logic[15:0]      led,        //little LEDs above switches
                    output logic            led16_b,    //blue channel left RGB LED
                    output logic            led16_g,    //green channel left RGB LED
                    output logic            led16_r,    //red channel left RGB LED
                    output logic            led17_b,    //blue channel right RGB LED
                    output logic            led17_g,    //green channel right RGB LED
                    output logic            led17_r    //red channel right RGB LED
    );
    
    parameter MAX_COUNT = 32'd25_000_000; //turn on/off LED every 250 ms...so flash at 2 Hz
    logic [31:0] counter; // for flashing the LEDs
    logic [15:0] dim_counter; //for adjusting LED brightness
    logic rgb_enable;  //used for enabling LED
    logic dim_on_off;  //used for PWM-dimming the RGB LEDs

    //do the combinatorial stuff first:
    assign led = sw; //blanket assignment of all 16 switch values to all 16 LEDs
    assign dim_on_off = dim_counter<sw;  //the higher the switches, the longer this will be on for a cycle
    
    //make the RGB LEDs be based on buttons (for color) and switches (for brightness)
    assign led16_b = dim_on_off & rgb_enable?btnl:1'b0;
    assign led16_g = dim_on_off & rgb_enable?btnc:1'b0;
    assign led16_r = dim_on_off & rgb_enable?btnr:1'b0;
    assign led17_b = dim_on_off & rgb_enable?btnu:1'b0;
    assign led17_g = dim_on_off & rgb_enable?btnc:1'b0;
    assign led17_r = dim_on_off & rgb_enable?btnd:1'b0;  
      
    //do sequential stuff lower down on page:  
    always_ff @(posedge clk_100mhz)begin
        if (counter==MAX_COUNT)begin
            counter <= 32'd0;
            rgb_enable <= ~rgb_enable;
        end else begin
            counter <= counter + 32'd1;
        end
        dim_counter <= dim_counter +16'b1;
    end 
endmodule