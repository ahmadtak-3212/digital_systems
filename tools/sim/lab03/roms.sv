module image_rom(input wire clka, input wire [15:0] addra, output logic [7:0] douta);
  logic [7:0] mem[0:61439]; initial $readmemb("image_rom.mif", mem);
  always_ff @(posedge clka) douta <= mem[addra];
endmodule
module red_coe(input wire clka, input wire [7:0] addra, output logic [7:0] douta);
  logic [7:0] mem[0:255]; initial begin for (int i=0;i<256;i++) mem[i]=0; $readmemb("red_coe.mif", mem); end
  always_ff @(posedge clka) douta <= mem[addra];
endmodule
