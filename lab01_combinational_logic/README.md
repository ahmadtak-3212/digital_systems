# Lab 1: combinational logic

My first SystemVerilog design: `assign` statements map four switches and three buttons onto LEDs.

| Output | Logic |
|---|---|
| `led[0]` | `sw[0] OR sw[1]` |
| `led[1]` | `sw[0] XOR sw[1] XOR sw[2]` |
| `led[2]`, `led[3]` | constant 1, constant 0 |
| `led[4]` | `NAND(sw[1], sw[2])` |
| `led16_b` | `btnc` |
| `led16_g` | `led[0] AND led[1]` |
| `led16_r` | carry out of `sw[1:0] + sw[3:2]` |

`top_tb.sv` is the course's heavily commented starter testbench for checking these input–output relationships.

## Recreate

1. Open `fpga/lab1/Lab1.xpr` and program the board.
2. Toggle `sw[3:0]` and watch `led[4:0]` and the left RGB LED.
3. For simulation, run behavioral simulation with `top_tb` as the top.

_Part of [digital_systems](../README.md), MIT 6.111, fall 2021. Board: Nexys 4 DDR. Tool: Vivado 2019.2._
