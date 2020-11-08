`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2020 09:51:07 AM
// Design Name: 
// Module Name: rotation
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


module rotation #(POINT_WIDTH = 20) (
    input logic clk,
    input logic rst,
    input logic valid_in,
    input signed [POINT_WIDTH-1:0] rot_in[3],
    input signed [POINT_WIDTH-1:0] sin[3], cos[3],
    output signed [POINT_WIDTH-1:0] rot_out[3],
    output logic valid_out
    );
    logic signed [POINT_WIDTH-1:0] stage[3][3];
    logic signed [2*POINT_WIDTH-1:0] mult_out[3][3];
    logic stage_valid[3];
    
    assign valid_out = stage_valid[2];
    assign rot_out = stage[2];
    
    //rotation 1
    always_ff @(posedge clk) begin
        if (rst) begin
            mult_out <= '{default:0};
        end else begin
            mult_out[0][0] <= rot_in[0];
            mult_out[0][1] <= cos[0] * -(sin[0]);
            mult_out[0][2] <= sin[0] * cos[0];

        end
    end
    
    //rotation 2
    always_ff @(posedge clk) begin
        if (rst) begin
            mult_out <= '{default:0};
        end else begin
            mult_out[1][0] <= rot_in[1];
            mult_out[1][1] <= cos[1] * -(sin[1]);
            mult_out[1][2] <= sin[1] * cos[1];
            
        end
    end
    
    //rotation 3
    always_ff @(posedge clk) begin
        if (rst) begin
            mult_out <= '{default:0};
        end else begin
            mult_out[2][0] <= rot_in[2];
            mult_out[2][1] <= cos[2] * -(sin[2]);
            mult_out[2][2] <= sin[2] * cos[2];
        end
    end
    
    always_ff @(posedge clk) begin
        if (rst) begin
            stage <= '{'{default:0}};
            stage_valid[0] <= valid_in;
            stage_valid[2:1] <= '{1'b0};
        end
        else begin
            stage_valid[0] <= valid_in;
            stage_valid[1] <= stage_valid[0];
            stage_valid[2] <= stage_valid[1];
            for (int i = 0; i < 3; i++) begin
                for (int j = 0; j < 3; j++) begin
                    stage[i][j] <= mult_out[i][j][2*POINT_WIDTH-1:POINT_WIDTH];
                end
            end
        end
    end
    
endmodule
