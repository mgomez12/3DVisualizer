`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2020 04:55:24 AM
// Design Name: 
// Module Name: transformation_tb
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


module transformation_tb(

    );
    logic clk;
    logic valid;
    logic rst;
    logic all_out;
    logic valid_out;
    logic signed [11:0] scale;
    logic signed [11:0] sin_in[3], cos_in[3];
    logic signed [13:0] point_out[3];
    assign cos = {12'd2044, 12'd2044, 12'd2044};
    assign sin = {12'd128, -12'd128, 12'd128};
    
    transformation u_transformation(.*);
    
    always begin
        #5 clk = ~clk;
    end
    
    int fd = $fopen("C:/Users/mgome/3DVisualizer/tb_points.txt", "w");
    int ct = 0;
    
    always begin
        #10;
        if (valid_out) begin
            ct = ct + 1;
            $fdisplay(fd, "(%d, %d, %d),", point_out[0], point_out[1], point_out[2]);
            if (ct == 20) all_out = 1;
        end
    end
    
    initial begin
        for (int i = 0; i < 30; i++) begin
            valid = 1;
            #10;
            valid = 0;
            all_out=0;
            while (!all_out) #10;
            
        end
        $finish;
    end
        
endmodule
