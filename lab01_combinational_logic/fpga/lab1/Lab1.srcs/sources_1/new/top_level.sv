`default_nettype none //prevents system from inferring an undeclared logic

module top_level(  
        //Inputs: (can also declare these inline up above)
        input wire [3:0]   sw, //when declaring 
        input wire         btnl,
        input wire         btnc,
        input wire         btnr,
        
        //Outputs:
        output logic[4:0]   led,
        output logic        led16_g,
        output logic        led16_b,
        output logic        led16_r);
            
       
        //Your logic here:
        assign led[0] = sw[0] || sw[1];
        assign led[1] = sw[0] ^ sw[1] ^ sw[2];
        assign led[2] = 1;
        assign led[3] = 0;
        assign led[4] = ~(sw[1] && sw[2]);
        assign led16_b = btnc;
        assign led16_g = (led[0] && led[1]);
        logic [1:0] arr;
        assign arr = sw[1:0] + sw[3:2];
        assign led16_r = arr[1];
        
endmodule //top_level 
//I usually add a comment to associate my endmodule line with the module name
//this helps when if you have multiple module definitions in a file and they are long.


`default_nettype wire //important to put at end (makes it work nicer with IP modules)