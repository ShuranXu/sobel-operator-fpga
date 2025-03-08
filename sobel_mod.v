`timescale 1ps/1ps

module sobel_top (
    input sys_clk_i,
    input sys_rst_i,

    input [7:0] cam_red_i,
    input [7:0] cam_green_i,
    input [7:0] cam_blue_i,
    input cam_done_i,

    output [7:0] sobel_red_o,
    output [7:0] sobel_green_o,
    output [7:0] sobel_blue_o,
    output sobel_done_o
);

endmodule
