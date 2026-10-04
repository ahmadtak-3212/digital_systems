`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: MIT
// Engineer: AHMAD TAKA
// 
// Create Date: 10/10/2021 02:26:00 PM
// Design Name: CAR ALARM 
// Module Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: This Lab was Actually Fun 
// 
//////////////////////////////////////////////////////////////////////////////////
module top_level(input wire clk_100mhz, 
					input wire [15:0] sw, 
					input wire btnc, btnu, btnl, btnd, btnr,
					output logic [1:0] led, 
					output logic ca,cb,cc,cd,ce,cf,cg, 
					output logic [7:0] an,  
					output logic ja,
					output logic[3:0] vga_r,
                    output logic[3:0] vga_b,
                    output logic[3:0] vga_g,
                    output logic vga_hs,
                    output logic vga_vs
                    );
	parameter ONE_HZ_PERIOD = 25_000_000;
	parameter DEBOUNCE_COUNT = 1000000;
	parameter LOW_FREQ = 28409; //corresponds to 440hz
	parameter HIGH_FREQ = 14205; //corresponds to 880hz
    ///////////////////////////////////////////////////////////////
    // LOGICS
    //////////////////////////////////////////////////////////////
    logic clk_25mhz;
    logic reset;
    assign reset = sw[15];
    
    //Buttons
    logic reprogram;
    logic h_switch;
    logic br_switch;
    logic dr_switch;
    logic p_switch;
    
    //Switches
    logic ig_switch;
    assign ig_switch = sw[14];
    logic [1:0] time_param;
    assign time_param = sw[5:4];
    logic [3:0] time_value;
    assign time_value = sw[3:0];
    
    //Multiplexer
    logic status_light;
    
    //Audio
    logic audio_signal; //used for audio generation (you control with siren generator)
    logic alarm;
    
    // FSM
    logic start_timer, status;
    logic [1:0] interval;
    logic [2:0] state;
    
    //Fuel Pump
     logic fuel_pump_led;
     
    //Timings
    logic [3:0] time_value_output, count;     
    logic expired_pulse, counting, one_hz; 
    
    //7 Seg
    logic [6:0] cat;
    logic [31:0] data;
         
    //Clock IN
     clk_25Mhz new_clk(.clk_in1(clk_100mhz), 
        .clk_out1(clk_25mhz));
    
    //debounce instances:
	debounce #(.DEBOUNCE_COUNT(DEBOUNCE_COUNT)) db_reprogram  (.reset_in(reset), .clock_in(clk_25mhz), .noisy_in(btnc),
	   .clean_out(reprogram));
	debounce #(.DEBOUNCE_COUNT(DEBOUNCE_COUNT)) db_h_switch   (.reset_in(reset), .clock_in(clk_25mhz), .noisy_in(btnu),
	   .clean_out(h_switch));
	debounce #(.DEBOUNCE_COUNT(DEBOUNCE_COUNT)) db_br_switch  (.reset_in(reset), .clock_in(clk_25mhz), .noisy_in(btnd),
	   .clean_out(br_switch));
	debounce #(.DEBOUNCE_COUNT(DEBOUNCE_COUNT)) db_dr_switch  (.reset_in(reset), .clock_in(clk_25mhz), .noisy_in(btnl),
	   .clean_out(dr_switch));
    debounce #(.DEBOUNCE_COUNT(DEBOUNCE_COUNT)) db_p_switch   (.reset_in (reset), .clock_in(clk_25mhz), .noisy_in(btnr),
        .clean_out(p_switch));
        
    //Time Parameter:
    time_parameter time1 (.clock_in(clk_25mhz),.reset_in(reset),.reprogram_in(reprogram), .interval_in(interval), .time_parameter_selector_in(time_param), .time_value_in(time_value),
         .time_value_out(time_value_output));
    
    //Timer:
	timer #(.ONE_HZ_PERIOD(ONE_HZ_PERIOD)) time2 (.clock_in(clk_25mhz), .reset_in(reset), .start_timer_in(start_timer),.value_in(time_value_output), 
	    .counting_out(counting),.expired_pulse_out(expired_pulse), .one_hz_out(one_hz), .count_out(count));
    
    //Fuel Pump FSM:
    fuel_pump_logic fuel1(.clock_in(clk_25mhz), .reset_in(reset), .ignition_in(ig_switch), .hidden_sw_in(h_switch), .brake_in(br_switch),
        .fuel_pump_led_out(fuel_pump_led));
    
    //Anti Theft FSM:
    anti_theft_fsm main_fsm (.clock_in(clk_25mhz),.reset_in(reset),.reprogram_in(reprogram),.ignition_in(ig_switch),.driver_in(dr_switch),.passenger_in(p_switch),.time_expired_in(expired_pulse),
        .interval_out(interval),.state_out(state),.start_timer_out(start_timer),.alarm_out(alarm),.status_out(status));  
        
   //Audio Generator:
    siren_generator #(.HIGH_FREQ(HIGH_FREQ), .LOW_FREQ(LOW_FREQ), .ONE_HZ(ONE_HZ_PERIOD)) wave_gen(.clock_in(clk_25mhz), .reset_in(reset), .alarm_in(alarm), .one_hz_in(one_hz),
        .wave_out(audio_signal));
	
	//Multiplexer
	multiplexer #(.LED_INTERVAL(2)) multi(.clock_in(clk_25mhz), .reset_in(reset), .led_status_in(status), .one_hz_in(one_hz),.state_in(state),
	   .led_out(status_light));
	
	//Seven Segment Display 
	seven_seg_controller seven_seg(.clk_in(clk_25mhz), .rst_in(reset), .val_in(data), 
	   .cat_out(cat), .an_out(an));
	
	//Display Driver
	display_driver display(.clock_in(clk_25mhz), .reset_in(reset), .state_in(state),
	   .vga_r_out(vga_r), .vga_b_out(vga_b), .vga_g_out(vga_g), .vga_hs_out(vga_hs), .vga_vs_out(vga_vs));
	   
	assign data = {{1'b0, state},12'h0,count, 4'h0,{2'b0, time_param}, time_value};
	always_comb begin
	   ca = cat[0];
	   cb = cat[1];
	   cc = cat[2];
	   cd = cat[3];
	   ce = cat[4];
	   cf = cat[5];
	   cg = cat[6];
	   ja = audio_signal;
	   led[0] = status_light;
	   led[1] = fuel_pump_led;
	end 
endmodule 
///////////////////////////////////////////////////////////////////////////////
//
// Pushbutton Debounce Module (LAB4 STARTER CODE)
//
///////////////////////////////////////////////////////////////////////////////
module debounce (input wire reset_in, clock_in, noisy_in,
                 output logic clean_out);
   parameter DEBOUNCE_COUNT = 1000000;
   logic [19:0] count;
   logic new_input;

   always_ff @(posedge clock_in)
     if (reset_in) begin 
        new_input <= noisy_in; 
        clean_out <= noisy_in; 
        count <= 0; end
     else if (noisy_in != new_input) begin new_input<=noisy_in; count <= 0; end
     else if (count == DEBOUNCE_COUNT) clean_out <= new_input;
     else count <= count+1;
endmodule

///////////////////////////////////////////////////////////////////////////////
//
// TIME PARAMETER MODULE
//
///////////////////////////////////////////////////////////////////////////////
module time_parameter(
    input wire clock_in, reset_in, reprogram_in,
    input wire [1:0] interval_in, time_parameter_selector_in,
    input wire [3:0] time_value_in,
    output logic [3:0] time_value_out
    );
    logic [3:0] T_ARM_DELAY, T_DRIVER_DELAY, T_PASSENGER_DELAY, T_ALARM_ON;
    
    always_comb begin
        case(interval_in) 
            //Combinational Logic for when signals come in from the fsm
            2'b00 : time_value_out = T_ARM_DELAY;
            2'b01 : time_value_out = T_DRIVER_DELAY;
            2'b10 : time_value_out = T_PASSENGER_DELAY;
            2'b11 : time_value_out = T_ALARM_ON;
            default : time_value_out = T_ARM_DELAY;
        endcase
    end 
    always_ff @(posedge clock_in) begin
        //Logic For reprograming the time parameters
        if (reset_in) begin 
            T_ARM_DELAY <= 4'b0110;
            T_DRIVER_DELAY <= 4'b1000;
            T_PASSENGER_DELAY <= 4'b1111;
            T_ALARM_ON <= 4'b1010;
        end else if (reprogram_in) begin 
            case(time_parameter_selector_in) 
                2'b00: T_ARM_DELAY <= time_value_in;
                2'b01: T_DRIVER_DELAY <= time_value_in;
                2'b10: T_PASSENGER_DELAY <= time_value_in;
                2'b11: T_ALARM_ON <= time_value_in;
                default: T_ARM_DELAY <= time_value_in;
            endcase 
        end 
    end
endmodule

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

///////////////////////////////////////////////////////////////////////////////
//
// FUEL PUMP FSM
//
////////////////////////////////////////////////////////////////////////////

module fuel_pump_logic(
     input wire clock_in, reset_in, ignition_in, hidden_sw_in, brake_in,
     output logic fuel_pump_led_out
    );
    enum {idle, waiting, led_on} state;
    always_ff @(posedge clock_in) begin 
        if(reset_in) begin 
            state <= idle;
        end else if (state == idle) begin 
            fuel_pump_led_out <= 0;
            if(ignition_in) begin 
                state <= waiting;
            end 
        end else if (state == waiting) begin 
            fuel_pump_led_out <= 0;
            if (hidden_sw_in && brake_in ) begin
                state <= led_on;
            end  
        end else if (state == led_on) begin 
            fuel_pump_led_out <= 1;
            if(!ignition_in) begin 
                state <= idle;
            end 
        end 
            
    end     

endmodule

///////////////////////////////////////////////////////////////////////////////
//
// MAIN FSM
//
///////////////////////////////////////////////////////////////////////////////
module anti_theft_fsm(
    input wire clock_in, reset_in, reprogram_in, ignition_in, driver_in, passenger_in, time_expired_in,
    output logic [1:0] interval_out,
    output logic [2:0] state_out,
    output logic start_timer_out, alarm_out, status_out
    );
    enum {armed, disarmed, triggered, sound_alarm, sound_alarm_door_closed, disarmed_driver_door_open, disarmed_driver_door_close} state;
    logic [1:0] led_count;
    always_ff @(posedge clock_in) begin 
        if(reset_in || reprogram_in) begin 
            //Default State
            state <= armed;
        end else if (state == armed) begin
            //Logic For Armed State
            alarm_out <= 0;
            status_out <= 1; 
            state_out <= 3'b000;
            start_timer_out <= 0;
            if (ignition_in) begin 
                state <= disarmed;
            end else if (driver_in) begin
                interval_out <= 2'b01;
                start_timer_out <= 1;
                state <= triggered;
            end else if (passenger_in) begin
                interval_out <= 2'b10; 
                start_timer_out <= 1;
                state <= triggered;
            end 
        end else if (state == triggered) begin
            //Logic for Triggered State
            alarm_out <= 0;
            status_out <= 1; 
            state_out <= 3'b001;  
            start_timer_out <= 0;
            if (ignition_in ) begin 
                state <= disarmed;
            end else if (time_expired_in) begin 
               
                state <= sound_alarm;
            end 
        end else if (state == sound_alarm) begin 
            //Logic For Sound Alarm State
            alarm_out <= 1;
            status_out <= 1; 
            state_out <= 3'b010; 
            start_timer_out <= 0; 
            if (ignition_in) begin 
                state <= disarmed;
            end else if (!passenger_in && !driver_in) begin 
                start_timer_out <= 1;
                state <= sound_alarm_door_closed;   
            end 
        end else if(state == sound_alarm_door_closed) begin
           //Logic For when the Alarm is Sounding and the Doors are Closed 
           alarm_out <= 1;
           status_out <= 1; 
           state_out <= 3'b011;  
           interval_out <= 2'b11; 
           start_timer_out <= 0;
           if(time_expired_in) begin
                state <= armed;
           end
        end else if (state == disarmed ) begin 
            //Logic For when in the disarmed state
            alarm_out <= 0;
            status_out <= 0; 
            state_out <= 3'b100;  
            start_timer_out <= 0;
            if (!ignition_in && driver_in) begin 
                state <= disarmed_driver_door_open;
            end 
        end else if (state == disarmed_driver_door_open) begin 
            //Logic for when in the disarmed state and the driver door opens
            alarm_out <= 0;
            status_out <= 0; 
            state_out <= 3'b101; 
            start_timer_out <= 0;
            if (!driver_in) begin 
               start_timer_out <= 1; 
               state <= disarmed_driver_door_close;
            end 
        end else if (state == disarmed_driver_door_close) begin 
            //Logic for when in the disarmed state and the driver door closes
            alarm_out <= 0;
            status_out <= 0; 
            state_out <= 3'b110; 
            interval_out <= 2'b00;
            start_timer_out <= 0; 
            if (time_expired_in) begin 
                state <= armed;
            end 
        end 
    end 
    
endmodule

///////////////////////////////////////////////////////////////////////////////
//
// SIREN GENERATOR
//
///////////////////////////////////////////////////////////////////////////////
module siren_generator(
    input wire clock_in, reset_in, alarm_in, one_hz_in,
    output logic wave_out
    );
    parameter HIGH_FREQ = 14205;
    parameter LOW_FREQ = 28409;
    parameter ONE_HZ = 25_000_000;

    logic [31:0] period_count_low;
    logic [31:0] period_count_high;
    logic state;
    always_ff @(posedge clock_in) begin        
        if(reset_in) begin 
            period_count_low <= 0;
            period_count_high <= 0;
            wave_out <= 0;
            state <= 0;
        end else if(alarm_in) begin 
            if (one_hz_in) begin 
                // if one hz is pulled high it changes states should happen every second
                 state <= ~state;
                 
            end 
            if (state) begin
                //High freqency counter 
                if (period_count_high >= HIGH_FREQ) begin 
                    wave_out <= ~wave_out;
                    period_count_high <= 0;
                end else begin  
                    period_count_high <= period_count_high + 1;
                end
            end else begin
                //Low frequency counter
                if (period_count_low >= LOW_FREQ) begin 
                    wave_out <= ~wave_out;
                    period_count_low <= 0;
                end else begin
                    period_count_low <= period_count_low + 1;
                end
            end 
        end 
    end    
endmodule

///////////////////////////////////////////////////////////////////////////////
//
// MULTIPLEXER
//
///////////////////////////////////////////////////////////////////////////////

module multiplexer(
    input wire clock_in, reset_in, led_status_in, one_hz_in,
    input wire [2:0] state_in,
    output logic led_out
    );
    parameter LED_INTERVAL = 2;
    logic [1:0] period_count;
    always_ff @(posedge clock_in) begin
        if(reset_in) begin
            period_count <= 0;
            led_out <= 0;
        end else if(state_in == 3'b000 && led_status_in) begin 
            // STATE is armed it will blink LED every LED_INTERVAL seconds
            if(one_hz_in) begin
                if (period_count == LED_INTERVAL - 1) begin
                   led_out <= 1;
                   period_count <= 0;
                end else begin
                   period_count <= period_count + 1;
                   led_out <= 0;  
                end 
            end 
        end else if(led_status_in) begin
            //IF status is high but its not in armed the LED should be solid 
            led_out <= 1;
        end else begin
            //else set to low
            led_out <= 0;
        end 
    end 
endmodule

///////////////////////////////////////////////////////////////////////////////
//
// 7 SEGMENT CONTROLLER FROM  LAB2
//
///////////////////////////////////////////////////////////////////////////////
module seven_seg_controller(input wire         clk_in,
                            input wire         rst_in,
                            input wire [31:0]  val_in,
                            output logic [6:0]   cat_out,
                            output logic [7:0]   an_out
    );
    
    logic [7:0]     segment_state;
    logic [31:0]    segment_counter;
    logic [3:0]     routed_vals;
    logic [6:0]     led_out;
    
    binary_to_seven_seg my_converter ( .bin_in(routed_vals), .hex_out(led_out));
    assign cat_out = ~led_out;
    assign an_out = ~segment_state;

    
    always_comb begin
        case(segment_state)
            8'b0000_0001:   routed_vals = val_in[3:0];
            8'b0000_0010:   routed_vals = val_in[7:4];
            8'b0000_0100:   routed_vals = val_in[11:8];
            8'b0000_1000:   routed_vals = val_in[15:12];
            8'b0001_0000:   routed_vals = val_in[19:16];
            8'b0010_0000:   routed_vals = val_in[23:20];
            8'b0100_0000:   routed_vals = val_in[27:24];
            8'b1000_0000:   routed_vals = val_in[31:28];
            default:        routed_vals = val_in[3:0];       
        endcase
    end
    
    always_ff @(posedge clk_in)begin
        if (rst_in)begin
            segment_state <= 8'b0000_0001;
            segment_counter <= 32'b0;
        end else begin
            if (segment_counter == 32'd100_000)begin
                segment_counter <= 32'd0;
                segment_state <= {segment_state[6:0],segment_state[7]};
            end else begin
                segment_counter <= segment_counter +1;
            end
        end
    end
        
endmodule //seven_seg_controller


//feel free to either include binary_to_seven_seg module here or in its own file!
module binary_to_seven_seg ( 
        input wire [3:0]       bin_in,  //declaring input explicitely
        output logic [6:0]      hex_out);  //declaring output explicitely
       
        
        always @(bin_in) begin
            case (bin_in) 
                4'b0000 : hex_out = 7'h3F;
                4'b0001 : hex_out = 7'h06;
                4'b0010 : hex_out = 7'h5B;
                4'b0011 : hex_out = 7'h4F; 
                
                4'b0100 : hex_out = 7'h66; 
                4'b0101 : hex_out = 7'h6D; 
                4'b0110 : hex_out = 7'h7D; 
                4'b0111 : hex_out = 7'h07; 
                
                4'b1000 : hex_out = 7'h7F; 
                4'b1001 : hex_out = 7'h67; 
                4'b1010 : hex_out = 7'h77; 
                4'b1011 : hex_out = 7'h7C; 
                
                4'b1100 : hex_out = 7'h39; 
                4'b1101 : hex_out = 7'h5E; 
                4'b1110 : hex_out = 7'h79; 
                4'b1111 : hex_out = 7'h71; 
            endcase
        end 
endmodule 




`default_nettype wire
