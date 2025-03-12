#!/bin/bash

iverilog -g2012 -o fifo_double_line_buffer_tb.vvp fifo_double_line_buffer_tb.v
vvp -n fifo_double_line_buffer_tb.vvp
rm fifo_double_line_buffer_tb.vvp