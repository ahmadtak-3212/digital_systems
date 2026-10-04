# Lab 4: car anti-theft alarm

A complete car-alarm controller running on a 25 MHz clock.

| Input | Meaning |
|---|---|
| `sw[15]` | Reset |
| `sw[14]` | Ignition |
| `btnl` / `btnr` | Driver / passenger door |
| `btnu` | Hidden switch |
| `btnd` | Brake pedal |
| `btnc` + `sw[5:4]` + `sw[3:0]` | Reprogram one of four time parameters with a 4-bit value |

| Module | Role |
|---|---|
| `anti_theft_fsm.sv` | 7 states: armed, disarmed, triggered, sound alarm, sound alarm with door closed, and disarmed with the driver door open or closed |
| `time_parameter.sv` | Stores the four programmable delays: arm delay, driver delay, passenger delay, alarm-on time |
| `timer.sv` | 1 Hz countdown that raises `expired` |
| `fuel_pump_logic.sv` | After the ignition turns on, the fuel pump enables only once the hidden switch and brake are pressed together, and it stays on until the ignition turns off |
| `siren_generator.sv` | Two-tone siren, alternating about 880 Hz and 440 Hz each second, out on Pmod JA |
| `display_driver.sv` | Status display on a VGA monitor |
| `seven_seg_controller.sv`, `debounce.sv`, `multiplexer.sv` | Display and input helpers |

There are testbenches for the FSM, fuel-pump logic, time parameters, timer and top level. The printed code is in `docs/Lab4_Code.pdf`.

_Part of [digital_systems](../README.md), MIT 6.111, fall 2021._
