# Lab 4: car anti-theft alarm

A complete car-alarm controller running on a 25 MHz clock from a clocking wizard.

![Anti-theft FSM](../docs/images/lab04_fsm.png)
<sub>State diagram transcribed from `anti_theft_fsm.sv` (`tools/sim/lab04/run.sh`).</sub>

| Input | Meaning |
|---|---|
| `sw[15]` | Reset |
| `sw[14]` | Ignition |
| `btnl` / `btnr` | Driver / passenger door (held = open) |
| `btnu` | Hidden switch |
| `btnd` | Brake pedal |
| `btnc` + `sw[5:4]` + `sw[3:0]` | Reprogram: `sw[5:4]` picks the parameter, `sw[3:0]` is its new value in seconds |

| `sw[5:4]` | Time parameter |
|---|---|
| `00` | `T_ARM_DELAY`: time after the driver door closes before the alarm re-arms |
| `01` | `T_DRIVER_DELAY`: grace period after the driver door opens |
| `10` | `T_PASSENGER_DELAY`: grace period after a passenger door opens |
| `11` | `T_ALARM_ON`: how long the siren keeps sounding after the doors close |

| Module | Role |
|---|---|
| `anti_theft_fsm.sv` | The 7-state controller in the diagram |
| `time_parameter.sv` | Stores the four programmable delays |
| `timer.sv` | 1 Hz countdown that raises `expired` |
| `fuel_pump_logic.sv` | After the ignition turns on, the pump enables only once the hidden switch and brake are pressed together, and it stays on until the ignition turns off |
| `siren_generator.sv` | Square wave alternating between about 880 Hz and 440 Hz each second, on Pmod **JA** (pin 1) |
| `display_driver.sv` | Status display on a VGA monitor |
| `seven_seg_controller.sv`, `debounce.sv`, `multiplexer.sv` | 7-segment status and input conditioning |

## Recreate

1. Open `fpga/lab4/Lab4.xpr` and generate output products for the `clk_25Mhz` and `clk_wiz_0` clocking IPs.
2. Program the board. Connect a VGA monitor, and a small speaker or amplifier to Pmod JA pin 1 (with GND) to hear the siren.
3. Walk through the diagram: `sw[15]` up then down to reset into ARMED, hold `btnl` (door) to trigger, release, and wait for the siren.

There are testbenches for the FSM, fuel-pump logic, time parameters, timer and top level. The printed code is in `docs/Lab4_Code.pdf`.

_Part of [digital_systems](../README.md), MIT 6.111, fall 2021. Board: Nexys 4 DDR. Tool: Vivado 2019.2._
