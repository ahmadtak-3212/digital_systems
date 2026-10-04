# Lab 3: Pong on VGA

A two-player Pong game drawn to a 1024 × 768 VGA monitor. A clocking-wizard IP makes the 65 MHz pixel clock.

| Switches | Function |
|---|---|
| `sw[1:0]` | Mode: `00`/`11` Pong, `01` 1-pixel white outline of the screen, `10` colour bars |
| `sw[8]` | Puck is an image (picture from ROM) or a plain square |
| `sw[11:9]` | Alpha-blending amount between the puck image and the background |
| `sw[15:12]` | Puck speed, in pixels per tick |

Buttons move the two paddles; the centre button resets.

| Module | Role |
|---|---|
| `top_level.sv` | Mode select, VGA timing (`xvga`), 8-digit hex display, the `pong_game` module |
| `blob.sv`, `circle.sv` | Draw a rectangle or circle at a given position |
| `picture_blob.sv` | Draws the puck from an image ROM plus a colour-map ROM (block-RAM IPs `image_rom` and `red_coe`) |

The printed code is in `docs/Lab3_Code.pdf`.

> The two ROM IPs were initialised from `ds_image.coe` and `ds_color_map.coe`, which lived in a folder outside the project and aren't in this copy. The `.mif` memory images Vivado generated from them are kept in `sources_1/ip/`, so the image data is preserved. Regenerating the IPs from scratch needs the original `.coe` files, which come from the 6.111 Lab 3 starter code.

_Part of [digital_systems](../README.md), MIT 6.111, fall 2021._
