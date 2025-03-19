`timescale 1ps/1ps

module store_grayscale 
#(parameter RESULT_ARRAY_LEN = 50 * 1024)
(
    input clk,
    input rst,
    input done_o,
    input [7:0] grayscale_o,
    output reg [7:0] result[RESULT_ARRAY_LEN-1:0]
);

integer  j;
always @(posedge clk) begin
    if(rst == 1'b1) begin
        j <= 0;
    end else begin
        if (done_o == 1'b1) begin
            result[j] <= grayscale_o;
            result[j+1] <= grayscale_o;
            result[j+2] <= grayscale_o;
            j <= j + 3;
        end
    end
end

endmodule