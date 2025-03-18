#!/bin/bash

iverilog -g2012 -o sobel_calc_tb.vvp sobel_calc_tb.sv
vvp -n sobel_calc_tb.vvp
rm sobel_calc_tb.vvp