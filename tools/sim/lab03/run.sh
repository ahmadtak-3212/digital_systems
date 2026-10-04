#!/bin/bash
# Renders Pong frames from the Lab 3 RTL with Verilator: one 1024x768 frame (PNG) and an animation (GIF).
# Needs verilator (5.x, for --binary --timing), python3 + pillow.
#   ./run.sh                      -> plain-square puck, 50% alpha blend, speed 4/8
#   IMG=1 ./run.sh                -> puck drawn from the image ROM instead
set -e; cd "$(dirname "$0")"; R=../../..; P=$R/lab03_pong_vga/fpga/lab3
rm -rf work && mkdir -p work/frames && cd work
tr -d '\r' < ../$P/Lab3.srcs/sources_1/new/top_level.sv    > top_level.sv
tr -d '\r' < ../$P/Lab3.srcs/sources_1/new/picture_blob.sv > picture_blob.sv
tr -d '\r' < ../$P/Lab3.srcs/sources_1/new/rect.sv         > rect.sv
cp ../$P/Lab3.srcs/sources_1/ip/image_rom/image_rom.mif ../$P/Lab3.srcs/sources_1/ip/red_coe/red_coe.mif .
V="verilator --binary --timing -Wno-fatal -Wno-lint -Wno-style --top-module tb"
$V ../tb.sv      top_level.sv picture_blob.sv rect.sv ../roms.sv -o frame --Mdir obj_frame >/dev/null
$V ../tb_anim.sv top_level.sv picture_blob.sv rect.sv ../roms.sv -o anim  --Mdir obj_anim  >/dev/null
./obj_frame/frame +alpha=2 +img=${IMG:-0} +speed=4 +frames=6 >/dev/null
./obj_anim/anim   +alpha=2 +img=${IMG:-0} +speed=8 +frames=160 +step=2 >/dev/null
python3 ../render.py ../../../../docs/images
