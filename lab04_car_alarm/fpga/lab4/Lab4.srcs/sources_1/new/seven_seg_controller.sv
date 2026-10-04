`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2021 04:08:49 PM
// Design Name: 
// Module Name: seven_seg_controller
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
endmodule // binary_to_seven
`default_nettype wire