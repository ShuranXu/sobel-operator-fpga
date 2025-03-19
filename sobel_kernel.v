`timescale 1ps/1ps
`include "/home/shxu6388/sobel-fpga/sobel_data_buffer/sobel_data_buffer.v"
`include "/home/shxu6388/sobel-fpga/sobel_calc/sobel_calc.v"

module sobel_kernel(

    input clk,
    input rst,

    input [7:0] grayscale_i,
    input done_i,

    output [7:0] grayscale_o,
    output done_o
);

wire [7:0]  d0, d1, d2,
            d3, d4, d5,
            d6, d7, d8;
wire sobel_data_buffer_done;

sobel_data_buffer SOBEL_DATA_BUFFER(

    .clk(clk),
    .rst(rst),

    .grayscale_i(grayscale_i),
    .done_i(done_i),

    .d0_o(d0),
    .d1_o(d1),
    .d2_o(d2),
    .d3_o(d3),
    .d4_o(d4),
    .d5_o(d5),
    .d6_o(d6),
    .d7_o(d7),
    .d8_o(d8),
    .done_o(sobel_data_buffer_done)
);

sobel_calc SOBEL_CALC (

    .clk(clk),
    .rst(rst),

    .d0_i(d0),
    .d1_i(d1),
    .d2_i(d2),
    .d3_i(d3),
    .d4_i(d4),
    .d5_i(d5),
    .d6_i(d6),
    .d7_i(d7),
    .d8_i(d8),

    .done_i(sobel_data_buffer_done),
    .grayscale_o(grayscale_o),
    .done_o(done_o)
);

endmodule