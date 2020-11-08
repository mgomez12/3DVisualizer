`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2020 02:04:09 PM
// Design Name: 
// Module Name: rotation_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rotation_tb(

    );
    localparam POINT_WIDTH=12;
    logic clk;
    logic rst;
    logic valid_in = 1;
    logic signed [POINT_WIDTH-1:0] rot_in[3];
    logic signed [POINT_WIDTH-1:0] sin[3], cos[3];
    logic signed [POINT_WIDTH-1:0] rot_out[3];
    logic valid_out;
    assign sin = {2044, 2044, 2044};
    assign cos = {128, -128, 128};
    
    rotation #(.POINT_WIDTH(POINT_WIDTH)) u_rotation (.*);
    logic signed [POINT_WIDTH-1:0] points[20][3] = {{-1024, -1024, -1024},
    {-1024, -1024, 1024}, 
    {-1024, 1024, -1024}, 
    {-1024, 1024, 1024}, 
    {1024, -1024, -1024}, 
    {1024, -1024, 1024}, 
    {1024, 1024, -1024}, 
    {1024, 1024, 1024}, 
    {0, -1656, -632}, 
    {-1656, -632, 0}, 
    {-632, 0, -1656}, 
    {0, -1656, 632}, 
    {-1656, 632, 0}, 
    {632, 0, -1656}, 
    {0, 1656, -632}, 
    {1656, -632, 0}, 
    {-632, 0, 1656}, 
    {0, 1656, 632}, 
    {1656, 632, 0}, 
    {632, 0, 1656}};
    always begin
        clk = ~clk;
        #5;
    end
    int fd;
    always begin
        $fdisplay(fd, "(%d, %d, %d),\n", rot_out[0], rot_out[1], rot_out[2]);
        #10;
    end
    initial begin
        fd = $fopen("tb_points.txt", "w");
        clk = 0;
        rst = 1;
        #20;
        rst = 0;
        # 10;
        for (int i = 0; i< 20; i++) begin
            rot_in = points[i];
            #10;
        end
        #40;
    end
        
endmodule
