//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2021 08:37:14 PM
// Design Name: 
// Module Name: endian
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
`default_nettype none  //ensure undeclared variable aren't inferred for you.

module endian(
    input wire [7:0] data,             //  data to be sent
    input wire big_endian,             //  programmable switch, if true, outputs be in big endian format
    output logic [7:0] send_data       //  send_data[0] will be first bit sent
    );
    always_comb begin 
        if(big_endian) begin
           assign send_data = {data[7], data[6], data[5], data[4], data[3], data[2], data[1], data[0]};
        end else begin 
            assign send_data = data;
        end
     end 
   //  data is a 8 bit Verilog value. 
   //  send_data should be the reorganized bits of data based on big_endian
   //  YOUR CODE HERE
endmodule

`default_nettype wire
