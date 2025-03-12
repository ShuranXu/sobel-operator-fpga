`include "fifo_double_line_buffer.v"

`define clk_period  10

module fifo_double_line_buffer_tb();

reg clk, rst, we_i;
reg [7:0] data_i;
wire [7:0] data0_o, data1_o, data2_o;
wire done_o;

fifo_double_line_buffer FIFO_DOUBLE_LINE_BUFFER (
    .clk(clk),
    .rst(rst),
    .we_i(we_i),

    .data_i(data_i),
    .data0_o(data0_o),
    .data1_o(data1_o),
    .data2_o(data2_o),

    .done_o(done_o)
);

initial clk = 1'b1;
always #(`clk_period / 2) clk = ~clk;
integer i;

initial begin
    rst = 1'b1;
    data_i = 8'b0;
    we_i = 1'b0;

    $dumpfile("waveforms/fifo_double_line_buffer.vcd");
    $dumpvars(0, fifo_double_line_buffer_tb);
    // $dumpvars(1, FIFO_DOUBLE_LINE_BUFFER);

    #(`clk_period);
    rst = 1'b0;
    we_i = 1'b1;

    for(i = 1; i < 15; i = i + 1) begin
        data_i = i;
        #(`clk_period);
    end

    we_i = 1'b0;
    #(`clk_period);
    
    $stop;
end

endmodule