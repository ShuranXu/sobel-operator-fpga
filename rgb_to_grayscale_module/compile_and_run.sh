#!/bin/bash

iverilog -g2012 -o rgb_to_grayscale_tb.vvp rgb_to_grayscale_tb.sv
vvp -n rgb_to_grayscale_tb.vvp