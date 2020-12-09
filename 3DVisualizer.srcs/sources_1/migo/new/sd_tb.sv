`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2020 09:01:58 AM
// Design Name: 
// Module Name: sd_tb
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


module sd_tb(

    );
    
    logic clk;
    logic sd_cd;
    logic rst; // replace w/ your system reset
    logic read;
    wire [3:0] sd_dat;
    logic [9:0] addra;
    logic clka;
    logic wea;
    logic [7:0] dina;
    logic sd_reset;
    logic sd_sck;
    logic sd_cmd;
    
    
    sd_top u_sd (.*);
    always #5 clk <= ~clk;
    initial begin
        clk = 1;
        rst = 1;
        #20;
        rst = 0;
        #100000;
        $finish();
    end
endmodule
