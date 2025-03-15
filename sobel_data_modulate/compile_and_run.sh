#!/bin/bash

iverilog -g2012 -o sobel_data_modulate_tb.vvp sobel_data_modulate_tb.sv
vvp -n sobel_data_modulate_tb.vvp
rm sobel_data_modulate_tb.vvp