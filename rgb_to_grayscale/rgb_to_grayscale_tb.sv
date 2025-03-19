`define clk_period  10
`include "rgb_to_grayscale.v"
`include "store_grayscale.v"

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

//-------------------------------------------------------------
localparam RESULT_ARRAY_LEN = 50 * 1024; // 50 KB
reg [7:0] result[RESULT_ARRAY_LEN-1:0];

store_grayscale STORE_GRAYSCALE(
    clk,
    rst,
    done_o,
    grayscale_o,
    result
);

//-------------------------------------------------------------

// 128x128 RGB image with pixel size being 24 bits
`define read_file_name "input.bmp"
localparam BMP_ARRAY_LEN = 50 * 1024; // 50 KB

reg [7:0] bmp_data[BMP_ARRAY_LEN-1: 0];
integer bmp_size, bmp_start_pos, bmp_width, bmp_height, bit_count;
integer read_count;

task readBMP;
    integer fileId;
    integer i;
    begin
        fileId = $fopen(`read_file_name, "rb");
        if(fileId == 0) begin
            $display("Open BMP error\n");
            $finish;
        end else begin
            read_count = $fread(bmp_data, fileId);
            if(read_count < 0) begin
                $display("Failed to read %s\n", `read_file_name);
                $finish;
            end
            $fclose(fileId);

            // extract fields from bmp_data
            bmp_size = {bmp_data[5], bmp_data[4], bmp_data[3], bmp_data[2]};
            $display("bmp_size = %d\n", bmp_size);

            bmp_start_pos = {bmp_data[13], bmp_data[12], bmp_data[11], bmp_data[10]};
            $display("bmp_start_pos = %d\n", bmp_start_pos);

            bmp_width = {bmp_data[21], bmp_data[20], bmp_data[19], bmp_data[18]};
            $display("bmp_width = %d\n", bmp_width);

            bmp_height = {bmp_data[25], bmp_data[24], bmp_data[23], bmp_data[22]};
            $display("bmp_height = %d\n", bmp_height);

            bit_count = {bmp_data[29], bmp_data[28]};
            $display("bit_count = %d\n", bit_count);

            if(bit_count != 24) begin
                $display("bit_count needs to be 24 !\n");
                $finish;
            end

            // this is the case where we need to pad zeros
            if(bmp_width % 4 == 1) begin
                $display("bmp_width mod 4 needs to be zero\n");
                $finish;
            end

            // for(i = bmp_start_pos; i <bmp_size; i = i + 1) begin
            //     $display("%h", bmp_data[i]);
            // end
        end
    end
endtask


//-------------------------------------------------------------
`define write_file_name "result.bmp"
task writeBMP();
    integer fileId, i;
    begin
        fileId = $fopen(`write_file_name, "wb");
        if(fileId == 0) begin
            $display("Open BMP error\n");
            $finish;
        end

        for(i = 0; i < bmp_size; i = i + 1) begin
            $fwrite(fileId, "%c", bmp_data[i]);
        end

        $fclose(fileId);
        $display("writeBMP completed\n");
    end
endtask

task writeBMPFromGrayscale();
    integer fileId, i;
    begin
        fileId = $fopen(`write_file_name, "wb");
        if(fileId == 0) begin
            $display("Open BMP error\n");
            $finish;
        end

        // write the BMP file header
        for(i = 0; i < bmp_start_pos; i = i + 1) begin
            $fwrite(fileId, "%c", bmp_data[i]);
        end

        // for(i = bmp_start_pos; i <bmp_size; i = i + 1) begin
        //     $display("%h", result[i]);
        // end

        // write the BMP file content
        for(i = bmp_start_pos; i < bmp_size; i = i + 1) begin
            $fwrite(fileId, "%c", result[i - bmp_start_pos]);
        end

        $fclose(fileId);
        $display("writeBMPFromGrayscale completed\n");
    end
endtask

//-------------------------------------------------------------
integer i;
initial begin
    rst = 1'b1;
    done_i = 1'b0;

    red_i = 8'b0;
    green_i = 8'b0;
    blue_i = 8'b0;

    $dumpfile("waveforms/rgb_to_grayscale.vcd");
    $dumpvars(0, rgb_to_grayscale_tb);

    readBMP;

    #(`clk_period);
    rst = 1'b0;

    for(i = bmp_start_pos; i < bmp_size; i = i + 3) begin
        red_i = bmp_data[i+2];
        green_i = bmp_data[i+1];
        blue_i = bmp_data[i];

        #(`clk_period);
        done_i = 1'b1;
    end

    #(`clk_period);
    done_i = 1'b0;

    #(`clk_period);
    writeBMPFromGrayscale;

    #(`clk_period);
    $finish;
end

// initial begin
//     rst = 1'b1;
//     done_i = 1'b0;

//     red_i = 8'b0;
//     green_i = 8'b0;
//     blue_i = 8'b0;

//     #(`clk_period);
//     rst = 1'b0;

//     red_i = 8'b0000_0100;
//     green_i = 8'b0000_0010;
//     blue_i = 8'b0001_0000;

//     done_i = 1'b1;

//     #(`clk_period);
//     assert(done_o == 1'b1);
//     assert(grayscale_o == 8'd3);
//     $display("grayscale_o = %d\n", grayscale_o);
//     done_i = 1'b0;

//     #(`clk_period);
//     assert(done_o == 1'b0);
//     assert(grayscale_o == 8'd0);
//     readBMP;
//     writeBMP;
//     $finish;
// end
endmodule

