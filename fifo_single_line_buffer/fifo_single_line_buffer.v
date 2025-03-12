`timescale 1ps/1ps

// The implementation for a single buffer such as fifo Line buffer 1
// if there is continuous data stream filling the fifo, then once the fifo
// is full the fifo data will be read continuously, while the input data
// continue writing to the fifo. --> This is effectively shifting data out
// from the fifo while new data is shifting into the fifo.
module fifo_single_line_buffer (
    input clk,
    input rst,
    input we_i,

    input [7:0] data_i,
    output [7:0] data_o,
    output done_o
);
    // This suggests that the buffer is designed to hold 640 pixel values 
    // (often corresponding to the width of an image in a row). 
    // parameter DEPTH = 640;
    parameter DEPTH = 5; // for sim
    reg [7:0] mem [DEPTH - 1: 0];

    reg [9:0] wr_pointer; // we need 10 bits because we need 10 bits to cover 640
    reg [9:0] rd_pointer;
    //  A 10-bit counter used to track how many pixels have been written into the FIFO buffer. 
    // When it reaches DEPTH, it indicates that the FIFO is full.
    reg [9:0] iCounter;
    // This output signal indicates whether the FIFO has been filled with data or not. 
    assign done_o = (iCounter == DEPTH) ? 1'b1 : 1'b0;
    assign data_o = mem[rd_pointer];

    //------------------- Handle with iCounter --------------------
    // we can see that the iCounter is used to determine when the FIFO is full.
    always @(posedge clk) begin
        if(rst) begin
            iCounter <= 10'b0;
        end else begin
            if(we_i == 1'b1) begin
                iCounter <= (iCounter == DEPTH ) ? iCounter : iCounter + 10'b1;
            end
        end
    end

    //------------------- Handle with write process --------------------
    always @(posedge clk) begin
        if(rst) begin
            wr_pointer <= 10'b0;
        end else begin
            if(we_i == 1'b1) begin
                mem[wr_pointer] <= data_i;
                wr_pointer <= (wr_pointer == DEPTH - 1) ? 0 : wr_pointer + 10'b1;
            end
        end
    end

    //------------------- Handle with read process --------------------
    always @(posedge clk) begin
        if(rst) begin
            rd_pointer <= 10'b0;
        end else begin
            // The read pointer is updated after each read once the buffer has been filled.
            if(iCounter == DEPTH) begin
                rd_pointer <= (rd_pointer == DEPTH - 1) ? 0 : rd_pointer + 10'b1;
            end
        end
    end

endmodule