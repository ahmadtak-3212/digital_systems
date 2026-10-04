# Lab 0: I/O demo

The course's "hello world" for the Nexys 4 DDR, provided by the 6.111 staff and used to check that the Vivado → board flow works.

- The 16 LEDs mirror the 16 switches (`assign led = sw`).
- The buttons pick the colour of the two RGB LEDs.
- The switch value sets the RGB LEDs' brightness by PWM, using a free-running counter compared against `sw`.
- A second counter blinks the RGB LEDs on and off.

## Recreate

1. Open `fpga/lab0/Lab0.xpr` in Vivado.
2. Generate the bitstream and program the board.
3. Flip switches and press buttons.

| Path | What |
|---|---|
| `fpga/lab0/Lab0.xpr` | Vivado project |
| `fpga/lab0/top_level.sv` | The demo module |
| `fpga/lab0/nexys4_ddr.xdc` | Board constraints |

_Part of [digital_systems](../README.md), MIT 6.111, fall 2021. Board: Nexys 4 DDR. Tool: Vivado 2019.2._
