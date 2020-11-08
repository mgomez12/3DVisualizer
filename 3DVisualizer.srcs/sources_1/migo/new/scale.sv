`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2020 05:04:50 PM
// Design Name: 
// Module Name: scale
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


module scale #(POINT_WIDTH = 20) (
    input logic clk,
    input logic rst,
    input logic valid_in,
    input signed [POINT_WIDTH-1:0] scale,
    input signed [POINT_WIDTH-1:0] scale_in[3],
    output reg signed [POINT_WIDTH-1:0] scale_out[3],
    output reg valid_out
    );
    logic signed [2*POINT_WIDTH-2:0] out[3];
    always_comb begin
        for (int i = 0; i < 3; i++) begin
            out[i] = scale_in[i]*scale;
        end
    end
    
    always_ff @(posedge clk) begin
        if (rst) begin
            out <= '{default:0};
            valid_out <= 0;
        end
        else begin
            valid_out <= valid_in;
            for (int i = 0; i < 3; i++) begin
                    scale_out[i] <= out[i][2*POINT_WIDTH-2:POINT_WIDTH-1];
            end
        end
    end
    
endmodule
