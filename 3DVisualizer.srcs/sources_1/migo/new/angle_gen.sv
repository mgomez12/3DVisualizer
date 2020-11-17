`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2020 04:03:44 PM
// Design Name: 
// Module Name: angle_gen
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


module angle_gen(
    input vsync,
    input clk,
    input rst,
    output signed [11:0]sin_out, cos_out,
    output valid_angle
    );
    assign sin_out = '0;
    assign cos_out = 12'b011111111111;
    assign valid_angle = vsync;
endmodule
