


`default_nettype none
module tmds_transmitter(input wire clk_in, 
                        input wire rst_in,
                        input wire [7:0] data_in,
                        output logic[9:0] data_out); 
      logic [8:0] s1_to_s2;      
      stage_1 my_stage_1(.clk_in(clk_in),.rst_in(rst_in),.s1_in(data_in), .s1_out(s1_to_s2));
      stage_2 my_stage_2(.clk_in(clk_in),.rst_in(rst_in),.s2_in(s1_to_s2),.s2_out(data_out));
endmodule



module stage_1 (input wire clk_in, input wire rst_in, input wire [7:0] s1_in, output logic [8:0] s1_out);
     logic [7:0] op1, op2, transitions1, transitions2;
     assign op1 = {s1_in[7] ^ s1_in[6], s1_in[6] ^ s1_in[5], s1_in[5] ^ s1_in[4], s1_in[4] ^ s1_in[3], s1_in[3] ^ s1_in[2], s1_in[2] ^ s1_in[1], s1_in[1] ^ s1_in[0], s1_in[0]};
     assign op2 = {!(s1_in[7] ^ s1_in[6]), !(s1_in[6] ^ s1_in[5]), !(s1_in[5] ^ s1_in[4]), !(s1_in[4] ^ s1_in[3]), !(s1_in[3] ^ s1_in[2]), !(s1_in[2] ^ s1_in[1]), !(s1_in[1] ^ s1_in[0]), s1_in[0]};
     
     assign transitions1 = {(op1[7]^op1[6]),(op1[6]^op1[5]), (op1[5]^op1[4]),(op1[4]^op1[3]),(op1[3]^op1[2]),(op1[2]^op1[1]),(op1[1]^op1[0]), op1[0]};
     assign transitions2 = {(op2[7]^op2[6]),(op2[6]^op2[5]), (op1[5]^op2[4]),(op2[4]^op2[3]),(op2[3]^op2[2]),(op2[2]^op2[1]),(op2[1]^op2[0]), op2[0]};
    
     logic [3:0] tally1, tally2;
     logic [9:0] out;
     
     
     
     tallier t1(.byte_in(transitions1), .tally_out(tally1));
     tallier t2(.byte_in(transitions2), .tally_out(tally2));
     assign out = (tally1 < tally2) ? {1'b1, op1} : {1'b0, op2};
     
    
     always_ff @(posedge clk_in) begin
        if(rst_in) begin
            s1_out <= 9'b0_0000_0000;
        end else begin 
            s1_out <= out;
        end
     end
endmodule

module tallier(
    input wire [7:0] byte_in,
    output logic [3:0] tally_out
    ); 
    assign tally_out = byte_in[7] + byte_in[6] + byte_in[5] + byte_in[4] + byte_in[3] + byte_in[2] + byte_in[1] + byte_in[0];
endmodule

module stage_2 (input wire clk_in, input wire rst_in, input wire [8:0] s2_in, output logic[9:0] s2_out);
    logic major_in, major_out;
    majority maj_in(.data_in(s2_in), .majority_out(major_in));
    majority maj_out(.data_in(s2_out[8:0]), .majority_out(major_out));
    always_ff @(posedge clk_in ) begin 
        if (rst_in) begin 
                s2_out <= 0;
        end else begin
            if(major_in) begin 
                s2_out <= (major_out) ? {1'b1, ~s2_in[8:0]} : {1'b0, s2_in[8:0]};
            end else begin
                s2_out <= (major_out) ? {1'b0, s2_in[8:0]} : {1'b1, ~s2_in[8:0]};
            end  
        end
    end 
endmodule

module majority (
    input wire [8:0] data_in,
    output logic majority_out
);
    logic [3:0] temp; 
    assign temp = (data_in[8] + data_in[7] + data_in[6] + data_in[5]+ data_in[4]+ data_in[3]+ data_in[2]+ data_in[1] + data_in[0]);
    assign majority_out = (temp > 4);
endmodule


//provided for your usage:
module tmds_receiver (input wire [9:0] data_in, output logic[7:0] data_out);
        logic[8:0] stage_1;
        assign stage_1 = data_in[9]? ~data_in[8:0]:data_in[8:0];
        logic [7:0] option_1;
        logic [7:0] option_2;
        xor_decode my_xord   (.data_in(stage_1[7:0]),.data_out(option_1));
        xnor_decode my_xnord (.data_in(stage_1[7:0]),.data_out(option_2));
        assign data_out = stage_1[8]?option_1:option_2;
endmodule

module xor_decode (input wire [7:0] data_in, output logic[7:0] data_out);
    always_comb begin
        data_out = 8'b0; //initialize
        data_out[0] = data_in[0];
        for(integer i=1; i<8; i++)begin
            data_out[i] = data_out[i-1]^data_in[i];
        end
    end
endmodule

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

