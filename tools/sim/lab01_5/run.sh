#!/bin/bash
# Simulates binary_to_seven_seg for all 16 inputs and draws the segments (needs iverilog, python3 + pillow).
set -e; cd "$(dirname "$0")"; R=../../..
SRC=$(find $R/lab01_5_seven_seg_decoder -name binary_to_seven_seg.sv | head -1)
tr -d '\r' < "$SRC" > /tmp/dec.sv
iverilog -g2012 -o /tmp/lab15 tb.sv /tmp/dec.sv && vvp -n /tmp/lab15 >/dev/null
python3 plot.py seg.txt $R/docs/images/lab01_5_seven_seg.png
