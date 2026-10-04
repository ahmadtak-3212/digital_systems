
logic [$size(hcount) - 1: 0] old_delta_x; // can't be bigger than the screen
logic [$size(vcount) - 1: 0] old_delta_y; // can't be bigger than the screen
logic [2*($size(hcount) - 1): 0] delta_x_sq; // times 2 for squaring 
logic [2*($size(hcount) - 1): 0] delta_y_sq; // times 2 for squaring 
    
always_comb begin // generate round puck
// compute x-xcenter and y-ycenter
radiussquared = RADIUS*RADIUS; // RADIUS is a paramater
deltax = (hcount > (x+RADIUS)) ? (hcount-(x+RADIUS)) : ((x+RADIUS)-hcount);
deltay = (vcount > (y+RADIUS)) ? (vcount-(y+RADIUS)) : ((y+RADIUS)-vcount);
// check if distance is less than radius squared
if(delta_x_sq + delta_y_sq <= radiussquared) begin
      pixel_out = COLOR;
end else begin 
      pixel_out = 0;
end    
always_ff @(posedge clk_in) begin
    // Basically Seperated out the combinational logic for the square between
    // two registers
    //four registers two for x and 2 for y
    deltax <= old_delta_x; 
    deltay <= old_delta_y;
    delta_x_sq <= old_delta_x*old_delta_x; 
    delta_y_sq <= old_delta_y*old_delta_y;
end 















module xnor_decode (input wire [7:0] data_in, output logic[7:0] data_out);
    always_comb begin
        data_out = 8'b0; //initialize
        data_out[0] = data_in[0];
        for(integer i=1; i<8; i++)begin
            data_out[i] = ~(data_out[i-1]^data_in[i]);
        end
    end
endmodule
`default_nettype wire

(5) Testbench: 

	










