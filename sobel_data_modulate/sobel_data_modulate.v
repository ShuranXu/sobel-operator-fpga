`timescale 1ps/1ps

module sobel_data_modulate (
    input clk,
    input rst,

    input [7:0] d0_i, // input pixel
    input [7:0] d1_i, // fifo line buffer 1 output pixel
    input [7:0] d2_i, // fifo line buffer 2 output pixel
    input done_i,

    output reg [7:0] d0_o,
    output reg [7:0] d1_o,
    output reg [7:0] d2_o,
    output reg [7:0] d3_o,
    output reg [7:0] d4_o,
    output reg [7:0] d5_o,
    output reg [7:0] d6_o,
    output reg [7:0] d7_o,
    output reg [7:0] d8_o,

    output done_o
);

localparam ROWS = 5;//480;
localparam COLS = 6;//640;

reg [9:0] iRows, iCols;

reg [7:0] data0, data1, data2, data3, data4, data5, data6, data7, data8;
reg [7:0] iCounter;


assign done_o = (iCounter == 2) ? 1'b1 : 1'b0;

//-------------------------handle with iRows and iCols ---------------------
always @(posedge clk) begin
    if(rst) begin
        iRows <= 10'b0;
        iCols <= 10'b0;
    end else begin
        if(done_o == 1'b1) begin
            iCols <= (iCols == COLS - 1) ? 0 : iCols + 1;
            if(iCols == COLS - 1) 
                iRows <= (iRows == ROWS - 1) ? 0 : iRows + 1;
        end
    end
end

//-------------------------handle with 9 output data ---------------------
//-----d0 d1 d2 -----
//-----d3 d4 d5 -----
//-----d6 d7 d8 -----

always @(*) begin
    if(rst) begin
        d0_o = 0;
        d1_o = 0;
        d2_o = 0;
        d3_o = 0;
        d4_o = 0;
        d5_o = 0;
        d6_o = 0;
        d7_o = 0;
        d8_o = 0;
    end else begin
        if(done_o == 1'b1) begin
            //----pos 1---- the top left edge point
            if(iRows == 0 && iCols == 0) begin
                d0_o = 0;
                d1_o = 0;
                d2_o = 0;
                d3_o = 0;
                d4_o = data4;
                d5_o = data5;
                d6_o = 0;
                d7_o = data7;
                d8_o = data8;
            //----pos 2---- the fist row points
            end else if(iRows == 0 && iCols > 0 && iCols < COLS - 1) begin
                d0_o = 0;
                d1_o = 0;
                d2_o = 0;
                d3_o = data3;
                d4_o = data4;
                d5_o = data5;
                d6_o = data6;
                d7_o = data7;
                d8_o = data8;
            //----pos 3---- the top right edge point
            end else if(iRows == 0 && iCols == COLS - 1) begin
                d0_o = 0;
                d1_o = 0;
                d2_o = 0;
                d3_o = data3;
                d4_o = data4;
                d5_o = 0;
                d6_o = data6;
                d7_o = data7;
                d8_o = 0;
            //----pos 4---- the left edge points
            end else if(iRows > 0 && iRows < ROWS - 1 && iCols == 0) begin
                d0_o = 0;
                d1_o = data1;
                d2_o = data2;
                d3_o = 0;
                d4_o = data4;
                d5_o = data5;
                d6_o = 0;
                d7_o = data7;
                d8_o = data8;
            //----pos 5---- the fully internal points
            end else if(iRows > 0 && iRows < ROWS - 1 && iCols > 0 && iCols < COLS - 1) begin
                d0_o = data0;
                d1_o = data1;
                d2_o = data2;
                d3_o = data3;
                d4_o = data4;
                d5_o = data5;
                d6_o = data6;
                d7_o = data7;
                d8_o = data8;
            //----pos 6---- the right edge points
            end else if(iRows > 0 && iRows < ROWS - 1 && iCols == COLS - 1) begin
                d0_o = data0;
                d1_o = data1;
                d2_o = 0;
                d3_o = data3;
                d4_o = data4;
                d5_o = 0;
                d6_o = data6;
                d7_o = data7;
                d8_o = 0;
            //----pos 7---- the bottom left edge point
            end else if(iRows == ROWS - 1 && iCols == 0) begin
                d0_o = 0;
                d1_o = data1;
                d2_o = data2;
                d3_o = 0;
                d4_o = data4;
                d5_o = data5;
                d6_o = 0;
                d7_o = 0;
                d8_o = 0;
            //----pos 8---- the bottom edge points
            end else if(iRows == ROWS - 1 && iCols > 0 && iCols < COLS - 1) begin
                d0_o = data0;
                d1_o = data1;
                d2_o = data2;
                d3_o = data3;
                d4_o = data4;
                d5_o = data5;
                d6_o = 0;
                d7_o = 0;
                d8_o = 0;
            //----pos 9---- the bottom right edge point
            end else if(iRows == ROWS - 1 && iCols == COLS - 1) begin
                d0_o = data0;
                d1_o = data1;
                d2_o = 0;
                d3_o = data3;
                d4_o = data4;
                d5_o = 0;
                d6_o = 0;
                d7_o = 0;
                d8_o = 0;
            end
        end
    end
end

//-------------------------handle with iCounter---------------------
// the iCounter is used to track the extra 2 pixels needed in the 
// 3rd row in order to be ready for the calculation
always @(posedge clk) begin
    if(rst) begin
        iCounter <= 8'b0;
    end else begin
        if(done_i == 1'b1) begin
            iCounter <= (iCounter == 2) ? iCounter : iCounter + 8'b1;
        end
    end
end

//-------------------------shift data-------------------------
always @(posedge clk) begin
    if(rst) begin
        data0 <= 8'b0;
        data1 <= 8'b0;
        data2 <= 8'b0;
        data3 <= 8'b0;
        data4 <= 8'b0;
        data5 <= 8'b0;
        data6 <= 8'b0;
        data7 <= 8'b0;
        data8 <= 8'b0;
    end else begin
        if(done_i == 1'b1) begin
            // these 3 lines correspond to the rightmost 3 bits,
            // where d2 comes from the output of fifo line buffer 2
            data0 <= data1;
            data1 <= data2;
            data2 <= d2_i;

            // these 3 lines correspond to the middle 3 bits,
            // where d5 comes from the output of fifo line buffer 1
            data3 <= data4;
            data4 <= data5;
            data5 <= d1_i;

            // these 3 lines correspond to the leftmost 3 bits,
            // where d5 comes from pixel input
            data6 <= data7;
            data7 <= data8;
            data8 <= d0_i;
        end
    end

end

endmodule