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
        output logic beat
    );
    
    logic [23:0] prev_band[2];
    logic [24:0] prev_avg;
    assign prev_avg = (prev_band[0] + prev_band[1]) >> 1;
    logic [1:0] count;
    logic counting;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            prev_band <= {0,0};
            beat <= 0;
            counting <= 0;
            prev_avg <= 0;
            count <= 0;
        end else begin
            if (counting) begin
                beat <= 0;
                count <= count + 1;
                if (count == 3) counting <= 0;
            end else if (valid) begin
                prev_band[0] <= band;
                prev_band[1] <= prev_band[0];
                if ((band > prev_band[0]) && ((band - prev_avg) > 500)) begin
                    beat <= 1;
                    count <= 0;
                    counting <= 1;
                end else beat <= 0;
            end
        end
    end
    
        
endmodule
