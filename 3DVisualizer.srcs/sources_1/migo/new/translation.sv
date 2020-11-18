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


module translation #(POINT_WIDTH = 12) (
    input logic clk,
    input logic rst,
    input logic valid_in,
    input logic proj_ready,
    input signed [POINT_WIDTH-1:0] trans_in[3],
    output reg signed [POINT_WIDTH+1:0] trans_out[3],
    output reg valid_out
    );
    logic signed [POINT_WIDTH+1:0] shift = (2*2048);
    
    always_ff @(posedge clk) begin
        if (rst) begin
            trans_out <= '{default:0};
            valid_out <= 0;
        end
        else if (proj_ready) begin
            valid_out <= valid_in;
            trans_out[0] <= trans_in[0];
            trans_out[1] <= trans_in[1];
            trans_out[2] <= trans_in[2] + shift;
        end
    end
    
endmodule
