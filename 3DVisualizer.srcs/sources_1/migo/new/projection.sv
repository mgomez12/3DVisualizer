`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2020 07:35:52 PM
// Design Name: 
// Module Name: projection
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


module projection #(POINT_WIDTH = 20) (
    input logic clk,
    input logic rst,
    input logic valid_in,
    input signed [POINT_WIDTH+1:0] projection_in[3],
    output reg signed [POINT_WIDTH+1:0] projection_out[3],
    output reg valid_out,
    output logic proj_ready
    );
    
    always_ff @(posedge clk) begin
        if (rst) begin
            projection_out <= '{default:0};
            valid_out <= 0;
        end else begin
        
        end
    end
            
endmodule
