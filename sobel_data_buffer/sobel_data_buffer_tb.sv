`timescale 1ps/1ps
`include "sobel_data_buffer.v"
`define clk_period  10


module sobel_data_buffer_tb();

reg clk, rst;
reg [7:0] grayscale_i;
reg done_i;
wire [7:0] d0_o, d1_o, d2_o,
            d3_o, d4_o, d5_o,
            d6_o, d7_o, d8_o;


sobel_data_buffer SOBEL_DATA_BUFFER (

    .clk(clk),
    .rst(rst),

    .grayscale_i(grayscale_i), 
    .done_i(done_i),

    .d0_o(d0_o),
    .d1_o(d1_o),
    .d2_o(d2_o),
    .d3_o(d3_o),
    .d4_o(d4_o),
    .d5_o(d5_o),
    .d6_o(d6_o),
    .d7_o(d7_o),
    .d8_o(d8_o),

    .done_o(done_o)
);

initial clk = 1'b1;
always#(`clk_period / 2) clk = ~clk;

integer i;

initial begin
   rst = 1'b1;
   grayscale_i = 8'b0;
   done_i = 1'b0;

   $dumpfile("waveforms/sobel_data_buffer.vcd");
   $dumpvars(0, sobel_data_buffer_tb);

   #(`clk_period);
    rst = 1'b0;
    done_i = 1'b1;

    //------------------------
    //---01 02 03 04 05 06 ---
    //---07 08 09 10 11 12 ---
    //---13 14 15 16 17 18 ---
    //---19 20 21 22 23 24 ---
    //---25 26 27 28 29 30 ---
    //------------------------

    // we store one more line of data
    for(i = 1; i <= 36; i = i + 1) begin
        grayscale_i = i;
        #(`clk_period);
    end

    done_i = 1'b0;

    #(`clk_period);
    $stop;
end

endmodule