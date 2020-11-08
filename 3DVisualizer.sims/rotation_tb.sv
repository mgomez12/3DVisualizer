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
    logic signed [POINT_WIDTH-1:0] rot_in[3];
    logic signed [POINT_WIDTH-1:0] sin[3], cos[3];
    logic signed [POINT_WIDTH-1:0] rot_out[3];
    logic valid_out;
    assign cos = {12'd2044, 12'd2044, 12'd2044};
    assign sin = {12'd128, -12'd128, 12'd128};
    logic valid_in;
    
    rotation #(.POINT_WIDTH(POINT_WIDTH)) u_rotation (.*);
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
        $fdisplay(fd, "(%d, %d, %d),\n", rot_out[0], rot_out[1], rot_out[2]);
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
            rot_in = points[i];
            #10;
        end
        valid_in = 0;
        #40;
        $fclose(fd);
    end
        
endmodule
