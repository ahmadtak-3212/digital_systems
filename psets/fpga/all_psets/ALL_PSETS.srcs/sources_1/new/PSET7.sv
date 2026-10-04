(1) Interleaver:

module interveaver(
    input wire [7:0] byte0,  // 00 (in example)
    input wire [7:0] byte1,  // 0E (in example)
    input wire [7:0] byte2,  // 8C (in example)
    input wire [7:0] byte3,  // 03 (in example)
    output logic [7:0] out0,
    output logic [7:0] out1,
    output logic [7:0] out2,
    output logic [7:0] out3
    );   
    //Bitwise Pair Concatentaion for each output. Using the LSB of the input  
    assign out0 = {byte0[0:1], byte1[0:1], byte2[0:1], byte3[0:1]};                                   
    assign out1 = {byte0[2:3], byte1[2:3], byte2[2:3], byte3[2:3]};  
    assign out2 = {byte0[4:5], byte1[4:5], byte2[4:5], byte3[4:5]};  
    assign out3 = {byte0[6:7], byte1[6:7], byte2[6:7], byte3[6:7]};  
         
endmodule
(1.1) Deinterleaver:

module deinterveaver(
    input wire [7:0] byte0,  // C8 (in example)
    input wire [7:0] byte1,  // 3C (in example)
    input wire [7:0] byte2,  // 00 (in example)
    input wire [7:0] byte3,  // 20 (in example)
    output logic [7:0] out0,
    output logic [7:0] out1,
    output logic [7:0] out2,
    output logic [7:0] out3
    );   
    //Bitwise Pair Concatentaion for each output. Using the LSB of the input  
    assign out0 = {byte0[0:1], byte1[0:1], byte2[0:1], byte3[0:1]};                                   
    assign out1 = {byte0[2:3], byte1[2:3], byte2[2:3], byte3[2:3]};  
    assign out2 = {byte0[4:5], byte1[4:5], byte2[4:5], byte3[4:5]};  
    assign out3 = {byte0[6:7], byte1[6:7], byte2[6:7], byte3[6:7]};  
         
endmodule

(2) Morse Code Encoding:
	For my encoding I utilize 7 bits in total, the first bit (MSB, so bit from the left) is used to tell when the morse code starts and the other 1-6 bits to encode the unique morse code signal itself (dot is a 1 and dash a 0). In the worst case when the morse code is 6 bits long the first bit will either be a 1 if the MSB of the morse code is 0 and 0 if the MSB of the code is 1. When the code is 1 bits long the first 5 bits will be padded with same bits based on the aformentioned rule, and the 6th bit will follow the rules from before, and the rest will be the code. For example A would be [0000_010], this is because A itself would be 2'b10 then we pad it with 5'b0 beacuese the MSB is 1. to becode we simply look for where the first bit transition is and then the bits after will encode the morse code. So for my implementation, A is [0000_010], B is [111_0111], D is [1111_011], E is [0000_001], and the period is [0101_010].  
