`timescale 1ps/1ps

module cam_top (
    input sys_clk_i,
    input sys_rst_i,

    output xvclk_o,
    output sio_c_o,
    output sio_d_io,
    output cam_rst_o,
    output cam_pwd_o,

    input vsync_i,
    input href_i,
    input pclk_i,
    input [7:0] cam_data_i,

    output sci_o,
    inout sda_io,

    output [7:0] cam_red_o,
    output [7:0] cam_green_o,
    output [7:0] cam_blue_o,

    output cam_done_o
);

endmodule
