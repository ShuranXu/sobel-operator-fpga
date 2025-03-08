`define clk_period  10
`include "rgb_to_grayscale.v"

module rgb_to_grayscale_tb ();

reg clk,rst;
reg [7:0] red_i, green_i, blue_i;
reg done_i;
wire [7:0] grayscale_o;
wire done_o;

rgb_to_grayscale RGB_TO_GRAYSCALE(
    .clk(clk),
    .rst(rst),
    .red_i(red_i),
    .green_i(green_i),
    .blue_i(blue_i),
    .cam_done_i(done_i),
    .grayscale_o(grayscale_o),
    .done_o(done_o)
);

initial clk = 1'b1;
always #(`clk_period / 2) clk = ~clk;

initial begin
    rst = 1'b1;
    done_i = 1'b0;

    red_i = 8'b0;
    green_i = 8'b0;
    blue_i = 8'b0;

    #(`clk_period);
    rst = 1'b0;

    red_i = 8'b0000_0100;
    green_i = 8'b0000_0010;
    blue_i = 8'b0001_0000;

    done_i = 1'b1;

    #(`clk_period);
    assert(done_o == 1'b1);
    assert(grayscale_o == 8'd3);
    $display("grayscale_o = %d\n", grayscale_o);
    done_i = 1'b0;

    #(`clk_period);
    assert(done_o == 1'b0);
    assert(grayscale_o == 8'd0);
    $stop;
end

endmodule
