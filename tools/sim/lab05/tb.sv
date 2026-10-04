module tb;
  logic clk=0; always #1 clk=~clk;
  logic rst=1, ready=0; logic signed [7:0] x; logic signed [17:0] y;
  fir31 dut(.clk_in(clk),.rst_in(rst),.ready_in(ready),.x_in(x),.y_out(y));
  real fs=48000.0; real f; int n; int fd; real ymax; real pi=3.14159265358979;
  real freqs[$] = '{100,500,1000,1500,2000,2500,3000,3500,4000,4500,5000,6000,7000,8000,10000,12000,14000,16000,18000,20000,22000,23900};
  initial begin
    fd=$fopen("resp.txt","w");
    repeat(5) @(posedge clk); rst=0;
    foreach (freqs[k]) begin
      f=freqs[k]; ymax=0;
      for (n=0;n<800;n++) begin
        x = $rtoi($floor(100.0*$sin(2*pi*f*n/fs)+0.5));
        @(posedge clk); ready=1; @(posedge clk); ready=0;
        repeat(62) @(posedge clk);
        if (n>200 && ($itor(y)>ymax)) ymax=$itor(y);
        if (n>200 && (-$itor(y)>ymax)) ymax=-$itor(y);
      end
      $fwrite(fd,"%f %f\n", f, ymax/1024.0/100.0);
    end
    $fclose(fd); $finish;
  end
endmodule
