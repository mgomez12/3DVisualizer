`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2020 04:18:38 AM
// Design Name: 
// Module Name: sampler_tb
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


module sampler_tb(

    );
    
    logic clk;
    logic rst;
    logic [9:0] addrb;
    logic clkb;
    logic [7:0] doutb;
    logic read;
    logic [7:0]data_out;
    logic last_out;
    logic valid_out;
    logic ready_out = 1;
    
    sampler u_sampler(.*);
    
    always #5 clk <= ~clk;
    assign doutb = addrb[7:0];
    initial begin
        clk = 1;
        rst = 1;
        #20;
        rst = 0;
        #100000;
        $finish();
    end
endmodule
