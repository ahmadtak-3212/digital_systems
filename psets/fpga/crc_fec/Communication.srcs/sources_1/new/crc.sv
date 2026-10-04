///////////////////////////////////////////////////////////////////////////////
//
// CRC Module 
//
///////////////////////////////////////////////////////////////////////////////

`default_nettype none
module crc(
    input wire clock,
    input wire start,
    input wire data, 
    output logic done, 
    output logic [15:0] r
    );
    parameter COUNT = 32;
    logic [5:0] bit_counter; //Counts to 32 bits
    always_ff @(posedge clock) begin 
        if (start) begin 
            //Initial Trigger
            r <= 16'hFFFF;
            done <= 1'b0;
            bit_counter <= 1'd0;
        end else begin 
            if (bit_counter == COUNT - 1) begin 
            //Termination
                done <= 1'b1;
                bit_counter <= 1'd0;
            end else begin 
                done <= 1'b0;
                bit_counter <= bit_counter + 1'd1;
             end  
             r[0] <= data + r[15];
             r[1] <= r[0];
             r[2] <= r[15] + r[1] + data;
             for(int i = 3; i < 15; i++) begin r[i] <= r[i - 1]; end //All registers 3-14 are equal to previous
             r[15] <= r[14] + r[15] + data; 
        end 
    end 
endmodule
`default_nettype wire
