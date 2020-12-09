`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2020 05:10:21 PM
// Design Name: 
// Module Name: beat_det
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


module beat_det(
        input logic clk,
        input logic rst,
        input logic [23:0] band,
        input logic valid,
        output logic beat,
        input [3:0] s
    );
    
    logic [23:0] prev_band[2];
    logic [24:0] prev_avg;
    assign prev_avg = (prev_band[0] + prev_band[1]) >> 1;
    logic [2:0] count;
    logic counting;
    
    ila_1 u_ila (.clk(clk), .probe0(beat), .probe1(valid), .probe2(prev_band[0]), .probe3(band), .probe4(counting));

    always_ff @(posedge clk) begin
        if (rst) begin
            prev_band <= {0,0};
            beat <= 0;
            counting <= 0;
            prev_avg <= 0;
            count <= 0;
        end else begin
            if (counting && valid) begin
                beat <= 0;
                count <= count + 1;
                if (count == 5) counting <= 0;
            end else if (valid) begin
                prev_band[0] <= band;
                prev_band[1] <= prev_band[0];
                if (band > s*1000 && prev_band[0] < s*1000) begin
                    beat <= 1;
                    count <= 0;
                    counting <= 1;
                end else beat <= 0;
            end else beat <= 0;
        end
    end
    
        
endmodule
