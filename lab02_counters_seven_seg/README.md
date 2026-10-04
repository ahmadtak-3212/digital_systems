# Lab 2: debouncing, counters and the 7-segment display

Builds the reusable sequential blocks used in every later lab:

| Module | Role |
|---|---|
| `debounce.sv` | Cleans a bouncy button: the output changes only after the input is stable for a set time |
| `edge_detector.sv` | One-cycle pulse on a rising edge |
| `simple_counter.sv` | Counts input events |
| `multiplexer.sv` | Picks what to show: the switches, the button-press count (hold left button) or a 10 Hz free-running count (hold centre button) |
| `seven_seg_controller.sv` | Time-multiplexes 8 hex digits onto the shared cathode lines |

Testbenches for the debouncer and counter are in `sim_1`. The printed code is in `docs/Lab2_Code.pdf`.

_Part of [digital_systems](../README.md), MIT 6.111, fall 2021._
