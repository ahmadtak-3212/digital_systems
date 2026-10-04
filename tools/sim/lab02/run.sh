#!/bin/bash
# Simulates the Lab 2 debouncer and the Lab 2.5 UART transmitter and plots the waveforms
# (needs iverilog, python3 + numpy + matplotlib).
set -e; cd "$(dirname "$0")"; R=../../..
tr -d '\r' < $R/lab02_counters_seven_seg/fpga/lab2/Lab2.srcs/sources_1/new/debounce.sv > /tmp/debounce.sv
tr -d '\r' < $R/lab02_5_uart_tx/fpga/lab2_5/Lab2.5.srcs/sources_1/new/serial_tx.sv > /tmp/serial_tx.sv
iverilog -g2012 -o /tmp/tx tb_tx.sv /tmp/serial_tx.sv && vvp -n /tmp/tx >/dev/null
iverilog -g2012 -o /tmp/db tb_db.sv /tmp/debounce.sv && vvp -n /tmp/db >/dev/null
sed -i '/ x$/d; / x /d' tx.txt db.txt
python3 plot.py $R/docs/images
