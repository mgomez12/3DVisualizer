`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2020 07:58:01 PM
// Design Name: 
// Module Name: projection_tb
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


module projection_tb(

    );
    localparam POINT_WIDTH = 14;
    logic clk;
    logic rst;
    logic valid_in;
    logic signed [POINT_WIDTH-1:0] projection_in[3];
    logic signed [POINT_WIDTH-1:0] projection_out[3];
    logic valid_out;
    logic proj_ready;
    int i;
    
    projection #(.POINT_WIDTH(POINT_WIDTH)) u_projection (.*);
    logic signed [POINT_WIDTH-1:0] points[20][3] = {{-14'd1024,  -14'd1024,   14'd5120},
{ -14'd1024,  -14'd1024,   14'd7168},
{ -14'd1024,   14'd1024,   14'd5120},
{ -14'd1024,   14'd1024,   14'd7168},
{  14'd1024,  -14'd1024,   14'd5120},
{  14'd1024,  -14'd1024,   14'd7168},
{  14'd1024,   14'd1024,   14'd5120},
{  14'd1024,   14'd1024,   14'd7168},
{     14'd0,  -14'd1656,   14'd5512},
{ -14'd1656,   -14'd632,   14'd6144},
{  -14'd632,      14'd0,   14'd4488},
{     14'd0,  -14'd1656,   14'd6776},
{ -14'd1656,    14'd632,   14'd6144},
{   14'd632,      14'd0,   14'd4488},
{     14'd0,   14'd1656,   14'd5512},
{  14'd1656,   -14'd632,   14'd6144},
{  -14'd632,      14'd0,   14'd7800},
{     14'd0,   14'd1656,   14'd6776},
{  14'd1656,    14'd632,   14'd6144},
{   14'd632,      14'd0,   14'd7800}};
    
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end
    int fd = $fopen("C:/Users/mgome/3DVisualizer/tb_points.txt", "w");
    int ct = 0;
    
    always begin
        #10;
        if (valid_out) begin
            ct = ct + 1;
            $fdisplay(fd, "(%d, %d, %d),", projection_out[0], projection_out[1], projection_out[2]);
            if (ct == 20) $finish;
        end
    end
    
    initial begin
        projection_in = {12'b0, 12'b0, 12'b0};
        rst = 1;
        valid_in = 0;
        #10;
        rst = 0;
        valid_in = 1;
        while (i < 20) begin
            projection_in = points[i];
            #10;
            if (proj_ready) i++;
        end
        valid_in = 0;
    end
        
endmodule
