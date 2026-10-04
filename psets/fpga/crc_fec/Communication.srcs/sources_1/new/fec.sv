///////////////////////////////////////////////////////////////////////////////
//
// FEC (Forward Error Correction)  
//
///////////////////////////////////////////////////////////////////////////////


`default_nettype none

module fec (input wire clock, 
            input wire start, 
            input wire data,
            output logic done,
            output logic [95:0] fec 
            );
        parameter MAX = 48;
        logic [2:0] x;
        logic [6:0] cycle_counter;        
        always_ff @(posedge clock) begin 
            if(start) begin
            //Resests State Variables
                x <= 0;
                done <= 0;
                fec <= 0;
                cycle_counter <= 0;   
            end else begin 
               if (cycle_counter ==  MAX - 1) begin
                    done <= 1;
                    cycle_counter <= 0;   
                    //Asserts done after 48 cycles                
               end else begin    
                    cycle_counter <= cycle_counter + 1;
                    done <= 0;
               end  
               //We Calculate the FEC concurrently and keep three registers to keep the state of the window
               fec <= {fec, {data ^ x[1] ^ x[2]},{data ^ x[0] ^ x[1] ^ x[2]}};
               x[0] <= data;
               x[1] <= x[0];
               x[2] <= x[1]; 
            end 
        end 
endmodule
`default_nettype wire