#!/bin/bash

iverilog -g2012 -o grayscale_to_rgb_tb.vvp grayscale_to_rgb_tb.sv
vvp -n grayscale_to_rgb_tb.vvp
rm grayscale_to_rgb_tb.vvp