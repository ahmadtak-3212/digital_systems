#!/bin/bash
# Draws the anti-theft FSM (transitions transcribed from anti_theft_fsm.sv). Needs graphviz.
cd "$(dirname "$0")" && dot -Tpng -Gdpi=110 fsm.dot -o ../../../docs/images/lab04_fsm.png
