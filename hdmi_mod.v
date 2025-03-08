`timescale 1ps/1ps

module hdmi_top (
    input sys_clk_i,
    input sys_rst_i,

    input [7:0] red_i,
    input [7:0] green_i,
    input [7:0] blue_i,
    input done_i,

    output sci_o,
    inout sda_io,

    output clk_n_o,
    output clk_p_o,

    output [2:0] hdmi_data_o
);

endmodule
