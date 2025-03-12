#!/bin/bash

iverilog -g2012 -o fifo_single_line_buffer_tb.vvp fifo_single_line_buffer_tb.v
vvp -n fifo_single_line_buffer_tb.vvp
rm fifo_single_line_buffer_tb.vvp