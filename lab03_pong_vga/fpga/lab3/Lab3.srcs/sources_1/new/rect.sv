`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// rect: draws a solid WIDTH x HEIGHT rectangle of COLOR at (x_in, y_in).
// This is the `blob` module from the submitted Lab 3 code (docs/Lab3_Code.pdf).
// It was renamed `rect` in top_level.sv when blob.sv was reused for the
// problem set 9 circle exercise, but the module itself was never re-added.
//////////////////////////////////////////////////////////////////////////////////
module rect
   #(parameter WIDTH = 64,            // default width: 64 pixels
               HEIGHT = 64,           // default height: 64 pixels
               COLOR = 12'hFFF)       // default color: white
   (input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   always_comb begin
      if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) &&
          (vcount_in >= y_in && vcount_in < (y_in+HEIGHT)))
        pixel_out = COLOR;
      else
        pixel_out = 0;
   end
endmodule
`default_nettype wire
