# Lab 2.5: UART transmitter

Pressing the centre button sends the byte on `sw[7:0]` to the PC over the board's USB-UART bridge.

- `serial_tx.sv`: 8N1 transmitter, 115200 baud (`DIVISOR = 868` clock cycles per bit at 100 MHz), with a testbench.
- `debounce.sv` and an edge detector make one button press send exactly one byte.
- `software/uart_rx/uart.py`: the course's Python reader. It finds the Digilent port and prints each byte as ASCII and as a number. It needs `pyserial`.

```bash
pip install pyserial
python software/uart_rx/uart.py
```

_Part of [digital_systems](../README.md), MIT 6.111, fall 2021._
