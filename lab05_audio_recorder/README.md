# Lab 5: audio recorder with FIR filter and echo

A voice recorder that uses the FPGA's on-chip ADC (**XADC**, input `vauxp3/vauxn3`) as the microphone input and the board's mono **PWM audio** output.

- **Sampling:** the ADC is read at about 48 kHz (`SAMPLE_COUNT = 2082` at 100 MHz) and converted from offset binary to signed. Every 8th sample is stored, about 6 kHz.
- **Record/playback** (`btnc` held = record): samples go into block RAM, up to 64,000 samples (≈ 10 s).
- **Filter** (`sw[0]`): a 31-tap FIR low-pass with 10-bit signed coefficients scaled by 2¹⁰ (`fir31` + `coeffs31`), used both as an anti-alias filter when recording and as a smoothing filter on playback.
- **Echo** (`sw[1]`): three copies of the recording in three BRAMs, read 0, 6,000 and 12,000 samples apart, mixed as 1 + ½ + ¼.
- **Volume** (`sw[15:13]`) then a PWM DAC drive the headphone jack.

Testbenches `fir_31_tb.sv` and `recorder_tb.sv` (with impulse and waveform input files) are in `sim_1`. The printed code is in `docs/Lab5_Code.pdf`.

_Part of [digital_systems](../README.md), MIT 6.111, fall 2021._
