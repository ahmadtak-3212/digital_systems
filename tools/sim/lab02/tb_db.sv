`timescale 1ns/1ps
module tb_db; logic clk=0; always #5 clk=~clk; logic rst=1, b=0, c; int fd; int i;
 debounce dut(.clk_in(clk),.rst_in(rst),.bouncey_in(b),.clean_out(c));
 initial begin fd=$fopen("db.txt","w"); repeat(4) @(posedge clk); rst=0; repeat(200000) @(posedge clk);
   // press: bounce for ~2 ms then stay high
   for (i=0;i<12;i++) begin b=~b; repeat(5000+($urandom%20000)) @(posedge clk); end
   b=1; repeat(1600000) @(posedge clk);
   // release: bounce then stay low
   for (i=0;i<9;i++) begin b=~b; repeat(5000+($urandom%20000)) @(posedge clk); end
   b=0; repeat(1600000) @(posedge clk); $fclose(fd); $finish; end
 always @(posedge clk) if (($time/10)%200==0) $fwrite(fd,"%0d %0d %0d\n",$time,b,c);
endmodule
