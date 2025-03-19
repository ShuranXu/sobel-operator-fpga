`timescale 1ps/1ps

module store_grayscale 
#(parameter RESULT_ARRAY_LEN = 50 * 1024)
(
    input clk,
    input rst,
    input done_i,
    input [7:0] red_i,
    input [7:0] green_i,
    input [7:0] blue_i,
    output reg [7:0] result[RESULT_ARRAY_LEN-1:0]
);

integer j;

always @(posedge clk) begin
    if(rst) begin
        j <= 8'd0;
    end else begin
        if(done_i) begin
            result[j] <= red_i;
            result[j+1] <= green_i;
            result[j+2] <= blue_i;
            j <= j + 3;
        end
    end
end

endmodule