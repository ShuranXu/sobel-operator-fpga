`include "sobel_calc.v"
`define clk_period  10

module sobel_calc_tb();

reg clk, rst;
reg [7:0]  d0_i, d1_i, d2_i,
            d3_i, d4_i, d5_i, 
            d6_i, d7_i, d8_i;
wire [7:0] grayscale_o;
reg done_i;
wire done_o;


sobel_calc SOBEL_CALC(

    .clk(clk),
    .rst(rst),

    .d0_i(d0_i),
    .d1_i(d1_i),
    .d2_i(d2_i),
    .d3_i(d3_i),
    .d4_i(d4_i),
    .d5_i(d5_i),
    .d6_i(d6_i),
    .d7_i(d7_i),
    .d8_i(d8_i),
    .done_i(done_i),

    .grayscale_o(grayscale_o),
    .done_o(done_o)
);

initial clk = 1'b1;
always #(`clk_period / 2) clk = ~clk;
integer i;

initial begin
    rst = 1'b1;
    done_i = 1'b0;

    $dumpfile("waveforms/sobel_calc_tb.vcd");
    $dumpvars(0, sobel_calc_tb);

    #(`clk_period);
    rst = 1'b0;

    d0_i = 8'd1;
    d1_i = 8'd2;
    d2_i = 8'd3;
    d3_i = 8'd4;
    d4_i = 8'd5;
    d5_i = 8'd6;
    d6_i = 8'd7;
    d7_i = 8'd8;
    d8_i = 8'd9;

    // gx_d = d6 +  d3 * 2 + d0 - (d8 + d5 * 2 + d2)
    // gx_d = -8

    // gy_d = d0 + d1 * 2 + d2 - (d6 + d7 * 2 + d8)
    // gy_d = 24

    // g_sum = |gx_d| + |gy_d|
    // g_sum = 32

    done_i = 1'b1;

    #(`clk_period);
    #(`clk_period);
    #(`clk_period);
    #(`clk_period);
    #(`clk_period);

    done_i = 1'b0;
    #(`clk_period);
    
    $stop;
end

endmodule