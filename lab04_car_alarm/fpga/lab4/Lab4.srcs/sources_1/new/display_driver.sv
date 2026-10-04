`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MIT
// Engineer: AHMAD TAKA
// 
// Create Date: 10/13/2021 06:53:59 PM
// Design Name: 
// Module Name: display_driver
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
///////////////////////////////////////////////////////////////////////////////
//
// DISPLAY DRIVER COPIED STUFF FROM PREVIOUS LABS AND PSET
//
///////////////////////////////////////////////////////////////////////////////
module display_driver( 
        input wire clock_in, reset_in,
        input wire [2:0] state_in,
        output logic[3:0] vga_r_out,
        output logic[3:0] vga_b_out,
        output logic[3:0] vga_g_out,
        output logic vga_hs_out,
        output logic vga_vs_out   
        );
        logic [10:0] hcount;    // pixel on current line
        logic [9:0] vcount;     // line number
        logic hsync, vsync, blank; //control signals for vga
        logic [11:0] pixel;
        logic [11:0] rgb;  
        logic phsync,pvsync,pblank;
        logic b,hs,vs;
        parameter WIDTH = 640;
        parameter HEIGHT = 480;
    
        xvga xvga1(.vclock_in(clock_in),.hcount_out(hcount),.vcount_out(vcount),
              .hsync_out(hsync),.vsync_out(vsync),.blank_out(blank));
              
        display_state #(.S_WIDTH(WIDTH), .S_HEIGHT(HEIGHT)) ds(.vclock_in(clock_in),.reset_in(reset_in),
                .hcount_in(hcount),.vcount_in(vcount),
                .hsync_in(hsync),.vsync_in(vsync),.blank_in(blank),
                .state_in(state_in), 
                .phsync_out(phsync),.pvsync_out(pvsync),.pblank_out(pblank),.pixel_out(pixel));
        
        
        
        always_ff @(posedge clock_in) begin
             
             hs <= phsync;
             vs <= pvsync;
             b <= pblank;
             rgb <= pixel;
        end
    
        // the following lines are required for the Nexys4 VGA circuit - do not change
        assign vga_r_out = ~b ? rgb[11:8]: 0;
        assign vga_g_out = ~b ? rgb[7:4] : 0;
        assign vga_b_out = ~b ? rgb[3:0] : 0;
    
        assign vga_hs_out = ~hs;
        assign vga_vs_out = ~vs;
    
endmodule

////////////////////////////////////////////////////////////////////////////////
//
// state_display: the logic for the display itself!
//
////////////////////////////////////////////////////////////////////////////////

module display_state (
   input wire vclock_in,        // 25MHz clock
   input wire reset_in,         // 1 to initialize module
   input wire [10:0] hcount_in, // horizontal index of current pixel (0..1023)
   input wire [9:0]  vcount_in, // vertical index of current pixel (0..767)
   input wire hsync_in,         // XVGA horizontal sync signal (active low)
   input wire vsync_in,         // XVGA vertical sync signal (active low)
   input wire blank_in,         // XVGA blanking (1 means output black pixel)
   input wire [2:0] state_in,
     
   output logic phsync_out,       // pong game's horizontal sync
   output logic pvsync_out,       // pong game's vertical sync
   output logic pblank_out,       // pong game's blanking
   output logic [11:0] pixel_out  // pong game's pixel  // r=11:8, g=7:4, b=3:0
   );
   parameter S_WIDTH = 640;
   parameter S_HEIGHT = 480;
   parameter GLOBAL_RADIUS = 64;
   parameter FLASH_PERIOD = 25_000_000;
   
   logic [10:0] global_x;
   assign global_x = (S_WIDTH >> 2) + GLOBAL_RADIUS;
   logic [9:0] global_y;
   assign global_y = (S_HEIGHT >> 2) + GLOBAL_RADIUS;

   
   logic [11:0] disarm_pixel, waiting_pixel, alarm_pixel;     
   // REPLACE ME! The code below just generates a color checkerboard
   // using 64 pixel by 64 pixel squares.
   circle #(.RADIUS(GLOBAL_RADIUS),.COLOR(12'h0F0)) disarm(.x(global_x),.y(global_y),.hcount(hcount_in),.vcount(vcount_in),.pixel_out(disarm_pixel));
   circle #(.RADIUS(GLOBAL_RADIUS),.COLOR(12'h00F)) waiting(.x(global_x),.y(global_y),.hcount(hcount_in),.vcount(vcount_in),.pixel_out(waiting_pixel));
   circle #(.RADIUS(GLOBAL_RADIUS),.COLOR(12'hF00)) alarm(.x(global_x),.y(global_y),.hcount(hcount_in),.vcount(vcount_in),.pixel_out(alarm_pixel));
   
   assign phsync_out = hsync_in;
   assign pvsync_out = vsync_in;
   assign pblank_out = blank_in;
   logic [31:0] period_count;
   logic alarm_on;
   always_comb begin
        case(state_in) 
            3'b000: pixel_out = alarm_pixel;
            3'b100: pixel_out = disarm_pixel;
            3'b010: pixel_out = (alarm_on)? alarm_pixel : 12'b0;  
            3'b011: pixel_out = (alarm_on)? alarm_pixel : 12'b0;  
            default: pixel_out = waiting_pixel;
        endcase
        
    end
    always_ff @(posedge vclock_in) begin 
        if(reset_in) begin
            period_count <= 0;
        end else begin
            if (period_count >= FLASH_PERIOD) begin 
                period_count <= 0;
                alarm_on <= ~alarm_on;
            end else begin
                period_count <= period_count + 1;
            end 
        end 
    end
   
   
endmodule
////////////////////////////////////////////////////////////////////////////////
//
// CIRCle: the logic for the display itself!
//
////////////////////////////////////////////////////////////////////////////////
module circle (
        input wire [10:0] x,hcount,
        input wire [9:0] y,vcount,
        output logic [11:0] pixel_out);

    parameter  RADIUS = 64;           // default height: 100 pixels
    parameter  COLOR = 12'hFFF;
    parameter RASIUS_SQUARED = RADIUS*RADIUS;
    logic [10: 0] deltax; // can't be bigger than the screen
    logic [9: 0] deltay; // can't be bigger than the screen

    always_comb begin // generate round puck
            // compute x-xcenter and y-ycenter
            deltax = (hcount > (x+RADIUS)) ? (hcount-(x+RADIUS)) : ((x+RADIUS)-hcount);
            deltay = (vcount > (y+RADIUS)) ? (vcount-(y+RADIUS)) : ((y+RADIUS)-vcount);
            // check if distance is less than radius squared
            if(deltax*deltax + deltay*deltay <= RASIUS_SQUARED) begin
                  pixel_out = COLOR;
            end else begin 
                  pixel_out = 0;
            end
    end    
endmodule


//////////////////////////////////////////////////////////////////////////////////
// Update: 8/8/2019 GH 
// Create Date: 10/02/2015 02:05:19 AM
// Module Name: xvga
//
// xvga: Generate VGA display signals (1024 x 768 @ 60Hz)
//
//                              ---- HORIZONTAL -----     ------VERTICAL -----
//                              Active                    Active
//                    Freq      Video   FP  Sync   BP      Video   FP  Sync  BP
//   640x480, 60Hz    25.175    640     16    96   48       480    11   2    31
//   800x600, 60Hz    40.000    800     40   128   88       600     1   4    23
//   1024x768, 60Hz   65.000    1024    24   136  160       768     3   6    29
//   1280x1024, 60Hz  108.00    1280    48   112  248       768     1   3    38
//   1280x720p 60Hz   75.25     1280    72    80  216       720     3   5    30
//   1920x1080 60Hz   148.5     1920    88    44  148      1080     4   5    36
//
// change the clock frequency, front porches, sync's, and back porches to create 
// other screen resolutions
////////////////////////////////////////////////////////////////////////////////

module xvga(input wire vclock_in,
            output logic [10:0] hcount_out,    // pixel number on current line
            output logic [9:0] vcount_out,     // line number
            output logic vsync_out, hsync_out,
            output logic blank_out);

       parameter DISPLAY_WIDTH  = 640;      // display width
       parameter DISPLAY_HEIGHT = 480;       // number of lines
    
       parameter  H_FP = 16;                 // horizontal front porch
       parameter  H_SYNC_PULSE = 96;        // horizontal sync
       parameter  H_BP = 48;                // horizontal back porch
    
       parameter  V_FP = 11;                  // vertical front porch
       parameter  V_SYNC_PULSE = 2;          // vertical sync 
       parameter  V_BP = 31;                 // vertical back porch
    
       // horizontal: 1344 pixels total
       // display 1024 pixels per line
       logic hblank,vblank;
       logic hsyncon,hsyncoff,hreset,hblankon;
       assign hblankon = (hcount_out == (DISPLAY_WIDTH -1));    
       assign hsyncon = (hcount_out == (DISPLAY_WIDTH + H_FP - 1));  //1047
       assign hsyncoff = (hcount_out == (DISPLAY_WIDTH + H_FP + H_SYNC_PULSE - 1));  // 1183
       assign hreset = (hcount_out == (DISPLAY_WIDTH + H_FP + H_SYNC_PULSE + H_BP - 1));  //1343
    
       // vertical: 806 lines total
       // display 768 lines
       logic vsyncon,vsyncoff,vreset,vblankon;
       assign vblankon = hreset & (vcount_out == (DISPLAY_HEIGHT - 1));   // 767 
       assign vsyncon = hreset & (vcount_out == (DISPLAY_HEIGHT + V_FP - 1));  // 771
       assign vsyncoff = hreset & (vcount_out == (DISPLAY_HEIGHT + V_FP + V_SYNC_PULSE - 1));  // 777
       assign vreset = hreset & (vcount_out == (DISPLAY_HEIGHT + V_FP + V_SYNC_PULSE + V_BP - 1)); // 805
    
       // sync and blanking
       logic next_hblank,next_vblank;
       assign next_hblank = hreset ? 0 : hblankon ? 1 : hblank;
       assign next_vblank = vreset ? 0 : vblankon ? 1 : vblank;
       always_ff @(posedge vclock_in) begin
          hcount_out <= hreset ? 0 : hcount_out + 1;
          hblank <= next_hblank;
          hsync_out <= hsyncon ? 0 : hsyncoff ? 1 : hsync_out;  // active low
    
          vcount_out <= hreset ? (vreset ? 0 : vcount_out + 1) : vcount_out;
          vblank <= next_vblank;
          vsync_out <= vsyncon ? 0 : vsyncoff ? 1 : vsync_out;  // active low
    
          blank_out <= next_vblank | (next_hblank & ~hreset);
       end
endmodule


`default_nettype wire