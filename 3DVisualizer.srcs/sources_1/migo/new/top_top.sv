`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2020 01:06:04 AM
// Design Name: 
// Module Name: top_top
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


module top_top(input clk_100mhz,
                    input sd_cd,
                    inout [3:0] sd_dat,
                    output reg [15:0] led,
                    output logic sd_reset,
                    output logic sd_sck,
                    output logic sd_cmd,
                    input logic [15:0] sw,
                    input btnc, btnu, btnd, btnr, btnl,
                    output logic[3:0] vga_r,
                    output logic[3:0] vga_b,
                    output logic[3:0] vga_g,
                    output logic led16_b,
                    output logic vga_hs,
                    output logic vga_vs,
                    output logic aud_pwm,
                    output logic aud_sd

    );
    
    logic beat;
    
    top_audio u_audio(.*);
    graphics_top u_graphics(.*);
endmodule
