#!/bin/bash
# Measures the frequency response of the Lab 5 fir31 RTL (sine in, peak out) with Verilator
# and plots it against the ideal response of the coefficients. Needs verilator, python3 + numpy + matplotlib.
set -e; cd "$(dirname "$0")"; R=../../..
tr -d '\r' < $R/lab05_audio_recorder/fpga/lab5/Lab5.srcs/sources_1/new/top_level.sv > /tmp/l5.sv
awk '/^module fir31/,/^endmodule/' /tmp/l5.sv > fir.sv; awk '/^module coeffs31/,/^endmodule/' /tmp/l5.sv >> fir.sv
verilator --binary --timing -Wno-fatal -Wno-lint -Wno-style --top-module tb tb.sv fir.sv -o simv >/dev/null
./obj_dir/simv >/dev/null
python3 plot.py $R/docs/images/lab05_fir_response.png
