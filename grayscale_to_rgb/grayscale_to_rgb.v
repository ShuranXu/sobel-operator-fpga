`timescale 1ps/1ps

module grayscale_to_rgb (

    input clk,
    input rst,

    input [7:0] grayscale_i,
    input done_i,

    output reg [7:0] red_o,
    output reg [7:0] green_o,
    output reg [7:0] blue_o,

    output reg done_o
);

always @(posedge clk) begin
    if(rst) begin
        red_o <= 8'b0;
        green_o <= 8'b0;
        blue_o <= 8'b0;
        done_o <= 8'b0;
    end else begin
        if(done_i) begin
            red_o <= grayscale_i;
            green_o <= grayscale_i;
            blue_o <= grayscale_i;
        end

        done_o <= done_i;
    end
end

endmodule