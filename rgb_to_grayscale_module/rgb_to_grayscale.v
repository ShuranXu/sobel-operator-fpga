`timescale 1ps/1ps

module rgb_to_grayscale(

    input clk,
    input rst,

    input [7:0] red_i,
    input [7:0] green_i,
    input [7:0] blue_i,

    input cam_done_i,

    output reg [7:0] grayscale_o,
    output reg done_o
);

    always @(posedge clk) begin
        if(rst) begin
            done_o <= 1'b0;
            grayscale_o <= 7'b0;
        end else begin
            if(cam_done_i == 1'b1) begin
                grayscale_o <= (red_i >> 2) + (red_i >> 5) + 
                                (green_i >> 1) + (green_i >> 4) +
                                (blue_i >> 4) + (blue_i >> 5);
                done_o <= 1'b1;
            end else begin
                grayscale_o <= 8'b0;
                done_o <= 1'b0;
            end
        end
    end

endmodule