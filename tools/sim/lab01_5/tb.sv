module tb; logic [3:0] b; logic [6:0] h; int fd;
 binary_to_seven_seg dut(.bin_in(b),.hex_out(h));
 initial begin fd=$fopen("seg.txt","w"); for (int i=0;i<16;i++) begin b=i; #1; $fwrite(fd,"%0d %b\n",i,h); end $fclose(fd); $finish; end
endmodule
