# Lab 0: I/O demo

The course's "hello world" for the Nexys 4 DDR. The 16 LEDs mirror the switches. The buttons pick the colour of the two RGB LEDs, the switch value sets their brightness by PWM, and a counter blinks them. The code is the staff-provided demo, used to check that the Vivado → board flow works.

| Path | What |
|---|---|
| `fpga/lab0/Lab0.xpr` | Vivado project |
| `fpga/lab0/top_level.sv` | The demo module |
| `fpga/lab0/nexys4_ddr.xdc` | Board constraints |

_Part of [digital_systems](../README.md), MIT 6.111, fall 2021._
