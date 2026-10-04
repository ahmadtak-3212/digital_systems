`timescale 1ns/1ps
module tb_tx; logic clk=0; always #5 clk=~clk; logic rst=1, trig=0, d; int fd;
 serial_tx dut(.clk_in(clk),.rst_in(rst),.trigger_in(trig),.val_in(8'h41),.data_out(d));
 initial begin fd=$fopen("tx.txt","w"); repeat(4) @(posedge clk); rst=0; repeat(12000) @(posedge clk); #1 trig=1; @(posedge clk); #1 trig=0; repeat(12000) @(posedge clk); $fclose(fd); $finish; end
 always @(posedge clk) $fwrite(fd,"%0d %0d %0d\n",$time,trig,d);
endmodule
