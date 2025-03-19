#!/bin/bash

iverilog -g2012 -o sobel_mod_tb.vvp sobel_mod_tb.sv
vvp -n sobel_mod_tb.vvp
rm sobel_mod_tb.vvp