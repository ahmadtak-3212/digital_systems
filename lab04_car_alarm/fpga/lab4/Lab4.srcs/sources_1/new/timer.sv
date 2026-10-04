`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2021 02:26:00 PM
// Design Name: 
// Module Name: fuel_pump_logic
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

///////////////////////////////////////////////////////////////////////////////
//
// TIMER MODULE
//
///////////////////////////////////////////////////////////////////////////////
module timer(   input wire clock_in, reset_in, start_timer_in,
                input wire [3:0] value_in,
                output logic counting_out,
                output logic expired_pulse_out,
                output logic one_hz_out, 
                output logic [3:0] count_out);

	//parameter below for generating one_hz_enable signal
	parameter ONE_HZ_PERIOD = 25_000_000;
	logic [31:0] period_count;
	
	always_ff @(posedge clock_in) begin
	    if (start_timer_in || reset_in) begin 
	        // Set All Outputs to defaults
	        period_count <= 0;
            counting_out <= 1;    
            count_out <= value_in;
            expired_pulse_out <= 0;
            one_hz_out <= 0;
        end else begin 
            if (period_count == ONE_HZ_PERIOD - 1) begin
                //This is where one hz signal is enabled
                period_count <= 0;
                one_hz_out <= 1;
                expired_pulse_out <= 0;
                if (counting_out) begin 
                    count_out <= count_out - 1; // if still counting decrement count
                end 
            end else if (count_out == 0 && counting_out) begin
                //To reset the count values for the display we have to make sure we were still counting and count is currently at 0 
                expired_pulse_out <= 1;
                counting_out <= 0;
                one_hz_out <= 0;
            end else begin 
                //Default for icrementing the number of cycles to the ONE_HZ_PERIOD
                expired_pulse_out <= 0;
                one_hz_out <= 0;
                period_count <= period_count + 1;
            end 
        end
    end 
endmodule
`default_nettype wire