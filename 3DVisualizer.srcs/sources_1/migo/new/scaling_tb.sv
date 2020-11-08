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


module scaling_tb(

    );
    localparam POINT_WIDTH=12;
    logic clk;
    logic rst;
    logic signed [POINT_WIDTH-1:0] scale_in[3];
    logic signed [POINT_WIDTH-1:0] scale = 12'b011000000000;
    logic signed [POINT_WIDTH-1:0] scale_out[3];
    logic valid_out;
    logic valid_in;
    
    scale #(.POINT_WIDTH(POINT_WIDTH)) u_scale (.*);
    logic signed [POINT_WIDTH-1:0] points[20][3] = {{-12'd1024, -12'd1024, -12'd1024},
    {-12'd1024, -12'd1024, 12'd1024}, 
    {-12'd1024, 12'd1024, -12'd1024}, 
    {-12'd1024, 12'd1024, 12'd1024}, 
    {12'd1024, -12'd1024, -12'd1024}, 
    {12'd1024, -12'd1024, 12'd1024}, 
    {12'd1024, 12'd1024, -12'd1024}, 
    {12'd1024, 12'd1024, 12'd1024}, 
    {12'd0, -12'd1656, -12'd632}, 
    {-12'd1656, -12'd632, 12'd0}, 
    {-12'd632, 12'd0, -12'd1656}, 
    {12'd0, -12'd1656, 12'd632}, 
    {-12'd1656, 12'd632, 12'd0}, 
    {12'd632, 12'd0, -12'd1656}, 
    {12'd0, 12'd1656, -12'd632}, 
    {12'd1656, -12'd632, 12'd0}, 
    {-12'd632, 12'd0, 12'd1656}, 
    {12'd0, 12'd1656, 12'd632}, 
    {12'd1656, 12'd632, 12'd0}, 
    {12'd632, 12'd0, 12'd1656}};
    always begin
        clk = ~clk;
        #5;
    end
    int fd = $fopen("C:/Users/mgome/3DVisualizer/tb_points.txt", "w");
    
    always begin
        $fdisplay(fd, "(%d, %d, %d),\n", scale_out[0], scale_out[1], scale_out[2]);
        #10;
    end
    initial begin
    $display("file desc: %d", fd);
        valid_in = 0;
        clk = 1;
        rst = 1;
        #20;
        rst = 0;
        # 10;
        for (int i = 0; i< 20; i++) begin
            valid_in = 1;
            scale_in = points[i];
            #10;
        end
        valid_in = 0;
        #40;
        $fclose(fd);
    end
        
endmodule
