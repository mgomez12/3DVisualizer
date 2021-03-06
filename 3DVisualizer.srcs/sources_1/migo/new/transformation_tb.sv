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
    logic [9:0] point_out[3];
    logic [31:0] cycle_count;
    wire signed [11:0] cos[30][3] = {{12'd2048, 12'd2048, 12'd2048},
                    {12'd2036, 12'd2036, 12'd2036},
                    {12'd2003, 12'd2003, 12'd2003},
                    {12'd1947, 12'd1947, 12'd1947},
                    {12'd1870, 12'd1870, 12'd1870},
                    {12'd1773, 12'd1773, 12'd1773},
                    {12'd1656, 12'd1656, 12'd1656},
                    {12'd1521, 12'd1521, 12'd1521},
                    {12'd1370, 12'd1370, 12'd1370},
                    {12'd1203, 12'd1203, 12'd1203},
                    {12'd1024, 12'd1024, 12'd1024},
                    {12'd832, 12'd832, 12'd832},
                    {12'd632, 12'd632, 12'd632},
                    {12'd425, 12'd425, 12'd425},
                    {12'd214, 12'd214, 12'd214},
                    {12'd0, 12'd0, 12'd0},
                    {-12'd214, -12'd214, -12'd214},
                    {-12'd425, -12'd425, -12'd425},
                    {-12'd632, -12'd632, -12'd632},
                    {-12'd832, -12'd832, -12'd832},
                    {-12'd1023, -12'd1023, -12'd1023},
                    {-12'd1203, -12'd1203, -12'd1203},
                    {-12'd1370, -12'd1370, -12'd1370},
                    {-12'd1521, -12'd1521, -12'd1521},
                    {-12'd1656, -12'd1656, -12'd1656},
                    {-12'd1773, -12'd1773, -12'd1773},
                    {-12'd1870, -12'd1870, -12'd1870},
                    {-12'd1947, -12'd1947, -12'd1947},
                    {-12'd2003, -12'd2003, -12'd2003},
                    {-12'd2036, -12'd2036, -12'd2036}};
    wire signed [11:0] sin[30][3] = {{12'd0, 12'd0, 12'd0},
                    {12'd214, 12'd214, 12'd214},
                    {12'd425, 12'd425, 12'd425},
                    {12'd632, 12'd632, 12'd632},
                    {12'd832, 12'd832, 12'd832},
                    {12'd1023, 12'd1023, 12'd1023},
                    {12'd1203, 12'd1203, 12'd1203},
                    {12'd1370, 12'd1370, 12'd1370},
                    {12'd1521, 12'd1521, 12'd1521},
                    {12'd1656, 12'd1656, 12'd1656},
                    {12'd1773, 12'd1773, 12'd1773},
                    {12'd1870, 12'd1870, 12'd1870},
                    {12'd1947, 12'd1947, 12'd1947},
                    {12'd2003, 12'd2003, 12'd2003},
                    {12'd2036, 12'd2036, 12'd2036},
                    {12'd2048, 12'd2048, 12'd2048},
                    {12'd2036, 12'd2036, 12'd2036},
                    {12'd2003, 12'd2003, 12'd2003},
                    {12'd1947, 12'd1947, 12'd1947},
                    {12'd1870, 12'd1870, 12'd1870},
                    {12'd1773, 12'd1773, 12'd1773},
                    {12'd1656, 12'd1656, 12'd1656},
                    {12'd1521, 12'd1521, 12'd1521},
                    {12'd1370, 12'd1370, 12'd1370},
                    {12'd1203, 12'd1203, 12'd1203},
                    {12'd1023, 12'd1023, 12'd1023},
                    {12'd832, 12'd832, 12'd832},
                    {12'd632, 12'd632, 12'd632},
                    {12'd425, 12'd425, 12'd425},
                    {12'd214, 12'd214, 12'd214}};
    assign scale = 12'b011111111111;
    
    transformation u_transformation(.*);
    
    always begin
        clk = 1;
        #5;
        clk = 0;
        #5;
        cycle_count = cycle_count + 1;
    end
    
    int fd = $fopen("C:/Users/mgome/3DVisualizer/tb_points.py", "w");
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
        cycle_count = 0;
        rst = 1;
        valid = 0;
        #40;
        rst = 0;
        for (int i = 0; i < 30; i++) begin
            cos_in = cos[i];
            sin_in = sin[i];
            valid = 1;
            #10;
            valid = 0;
            all_out=0;
            ct = 0;
            while (!all_out) #10;
            
        end
        $fclose(fd);
        $finish;
    end
        
endmodule
