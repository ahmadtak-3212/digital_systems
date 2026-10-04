# digital_systems: MIT 6.111 Introductory Digital Systems Laboratory, fall 2021

My labs and problem sets from MIT **6.111**, the FPGA digital design lab. Everything targets the **Digilent Nexys 4 DDR** board (Xilinx Artix-7) and is written in SystemVerilog in **Vivado**, with one Vivado project per lab.

The folder covers September 11 to October 29, 2021: labs 0–5 and the problem sets. It doesn't include a final project.

## Labs

| Lab | Folder | What it does |
|---|---|---|
| 0 | [`lab00_io_demo`](lab00_io_demo) | Course-provided I/O demo: switches and buttons drive the LEDs and RGB LEDs |
| 1 | [`lab01_combinational_logic`](lab01_combinational_logic) | First combinational logic on switches → LEDs, plus a self-checking testbench |
| 1.5 | [`lab01_5_seven_seg_decoder`](lab01_5_seven_seg_decoder) | Binary-to-hex 7-segment decoder, with a testbench |
| 2 | [`lab02_counters_seven_seg`](lab02_counters_seven_seg) | Debouncer, edge detector, counters and an 8-digit multiplexed 7-segment driver |
| 2.5 | [`lab02_5_uart_tx`](lab02_5_uart_tx) | UART transmitter (115200 baud) sending switch values to a Python script on the PC |
| 3 | [`lab03_pong_vga`](lab03_pong_vga) | Pong on 1024 × 768 VGA: two paddles, an image puck from ROM, alpha blending, adjustable speed |
| 4 | [`lab04_car_alarm`](lab04_car_alarm) | Car anti-theft system: 7-state alarm FSM, programmable timers, fuel-pump cutoff, two-tone siren, VGA status display |
| 5 | [`lab05_audio_recorder`](lab05_audio_recorder) | Audio recorder: on-chip ADC microphone input, BRAM record and playback, 31-tap FIR filter, echo, PWM audio out |

Problem-set designs (TMDS/HDMI encoding, CRC, forward error correction, interleaving, DRAM timing) are in [`psets/`](psets).

## How to open a lab

1. Install **Vivado**. The projects were saved with **Vivado 2019.2**; newer versions offer to upgrade the project and its IP.
2. Open the `.xpr` file in the lab's `fpga/<lab>/` folder, for example `lab03_pong_vga/fpga/lab3/Lab3.xpr`.
3. Run synthesis, implementation and bitstream generation, then program the Nexys 4 DDR from Hardware Manager.
4. Testbenches are under each project's `*.srcs/sim_1/`; select one as the simulation top and run behavioral simulation.

Vivado's generated folders (`.cache`, `.runs`, `.sim`, `.hw`, `.ip_user_files`, `.Xil`) are kept on disk but git-ignored. Vivado rebuilds them, and the bitstreams come back when you re-run implementation. The IP definitions (`.xci`) under each project's `sources_1/ip/` are kept.

## Layout

```
digital_systems/
├── labNN_<name>/
│   ├── fpga/<lab>/        Vivado project (.xpr + .srcs)
│   ├── docs/              printed code PDF submitted for the lab (labs 2–5)
│   └── software/          host-side scripts (lab 2.5)
├── psets/
│   ├── fpga/<pset>/       Vivado projects for the problem-set designs
│   └── docs/              problem-set write-ups (PDF)
└── docs/reference/        Nexys 4 DDR master constraints file
```

See [docs/STRUCTURE.md](docs/STRUCTURE.md) for the folder conventions shared across my projects. Lab 0 and some starter code are course-provided (written by the 6.111 staff); the module headers say so.
