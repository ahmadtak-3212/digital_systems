module tb;
  logic clk=0; always #1 clk=~clk;
  logic [10:0] hc; logic [9:0] vc; logic hs,vs,bl;
  logic phs,pvs,pbl,gend; logic [11:0] px;
  logic reset=1;
  int frames=0; int f; int target;
  logic [2:0] alpha; logic img; logic [3:0] speed;
  xvga xv(.vclock_in(clk),.hcount_out(hc),.vcount_out(vc),.vsync_out(vs),.hsync_out(hs),.blank_out(bl));
  pong_game pg(.vclock_in(clk),.reset_in(reset),.up_in(1'b0),.down_in(1'b0),.up_in2(1'b0),.down_in2(1'b0),
     .pspeed_in(speed),.hcount_in(hc),.vcount_in(vc),.hsync_in(hs),.vsync_in(vs),.blank_in(bl),
     .alpha_in(alpha),.image_set_in(img),.phsync_out(phs),.pvsync_out(pvs),.pblank_out(pbl),.pixel_out(px),.game_end_out(gend));
  initial begin
    if (!$value$plusargs("alpha=%d", alpha)) alpha=3'd2;
    if (!$value$plusargs("img=%d", img)) img=1;
    if (!$value$plusargs("speed=%d", speed)) speed=4'd4;
    if (!$value$plusargs("frames=%d", target)) target=12;
    repeat(20) @(posedge clk); reset=0;
  end
  always @(posedge clk) begin
    if (hc==0 && vc==0 && !reset) begin
      frames++;
      if (frames==target) f=$fopen("frame.txt","w");
      if (frames==target+1) begin $fclose(f); $finish; end
    end
    if (frames==target && hc<1024 && vc<768) $fwrite(f,"%03x\n",px);
  end
endmodule
