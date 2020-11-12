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


module projection #(POINT_WIDTH = 14) (
    input logic clk,
    input logic rst,
    input logic valid_in,
    input signed [POINT_WIDTH-1:0] proj_in[3],
    output reg signed [POINT_WIDTH-1:0] proj_out[3],
    output reg valid_out,
    output logic proj_ready
    );
    
    logic divisor_taken[3];
    logic dividend_taken[3];
    
    logic signed [POINT_WIDTH-1:0] aspect = 'b01_010101010101;
    logic divisor_ready[3];
    logic dividend_ready[3];
    logic divisor_valid[3];
    logic dividend_valid[3];
    logic out_ready;
    logic out_valid[3];
    logic signed [POINT_WIDTH-1:0] out[3];
    logic signed [2*POINT_WIDTH-2:0] big_divisor;
    assign big_divisor = aspect * proj_in[2]; //12 fraction bits
    
    wire signed[POINT_WIDTH: 0] divisor0_in = big_divisor[2*POINT_WIDTH-2:POINT_WIDTH-2];
    
    logic all_taken;
    assign all_taken = divisor_taken[0] & divisor_taken[1] & divisor_taken[2] & dividend_taken[0] & dividend_taken[1] & dividend_taken[2];
    assign proj_ready = all_taken | !valid_in;
    logic signed [POINT_WIDTH-1:0] far = 2048;
    logic signed [POINT_WIDTH-1:0] near = 1024;
    wire signed [2*POINT_WIDTH-2:0] big_dividend2 = (near * far) >>> 13 ; //cut off 4 extra bits, need to multiply at end
    wire signed [POINT_WIDTH-1:0] dividend2_in = big_dividend2[POINT_WIDTH-1:0];
    
    div_gen_0 x_div (.aclk(clk), .s_axis_divisor_tvalid(divisor_valid[0]), 
                    .s_axis_divisor_tready(divisor_ready[0]), .s_axis_divisor_tdata(divisor0_in), .s_axis_dividend_tvalid(dividend_valid[0]), 
                    .s_axis_dividend_tready(dividend_ready[0]), .s_axis_dividend_tdata(proj_in[0]), .m_axis_dout_tvalid(out_valid[0]), 
                    .m_axis_dout_tdata(out[0]), .m_axis_dout_tready(out_ready));

    div_gen_0 y_div (.aclk(clk), .s_axis_divisor_tvalid(divisor_valid[1]), 
                    .s_axis_divisor_tready(divisor_ready[1]), .s_axis_divisor_tdata({proj_in[2][POINT_WIDTH-1],proj_in[2]}), .s_axis_dividend_tvalid(dividend_valid[1]), 
                    .s_axis_dividend_tready(dividend_ready[1]), .s_axis_dividend_tdata(proj_in[1]), .m_axis_dout_tvalid(out_valid[1]), 
                    .m_axis_dout_tdata(out[1]), .m_axis_dout_tready(out_ready));
                    
    div_gen_0 z_div (.aclk(clk), .s_axis_divisor_tvalid(divisor_valid[2]), 
                    .s_axis_divisor_tready(divisor_ready[2]), .s_axis_divisor_tdata({proj_in[2][POINT_WIDTH-1],proj_in[2]}), .s_axis_dividend_tvalid(dividend_valid[2]), 
                    .s_axis_dividend_tready(dividend_ready[2]), .s_axis_dividend_tdata(dividend2_in), .m_axis_dout_tvalid(out_valid[2]), 
                    .m_axis_dout_tdata(out[2]), .m_axis_dout_tready(out_ready));
    
    always_ff @(posedge clk) begin
        if (rst) begin
            proj_out <= '{default:0};
            valid_out <= 0;
            divisor_taken <= '{default:1};
            dividend_taken <= '{default:1};
            out_ready <= 0;
        end else begin
            if (all_taken) begin
                divisor_taken <= '{default:0};
                dividend_taken <= '{default:0};
            end
            else begin
                for (int i = 0; i < 3; i++) begin
                    divisor_taken[i] <= (divisor_ready[i] && divisor_valid[i]) | divisor_taken[i] ;
                    dividend_taken[i] <= (dividend_ready[i] && dividend_valid[i]) | dividend_taken[i] ;
                end
            end
            
            if (out_valid[0] && out_valid[1] && out_valid[2] && !out_ready) begin
                out_ready <= 1;
            end else if (out_ready) begin
                out_ready <= 0;
                valid_out <= 1;
                proj_out[0] <= out[0];
                proj_out[1] <= out[1];
                proj_out[2] <= (3 <<< 13)- {out[2], 5'b0};
            end else begin
                valid_out <= 0;
            end
        end
    end
    
    always_comb begin
        for (int i = 0; i < 3; i++) begin
            divisor_valid[i] = valid_in & !divisor_taken[i];
            dividend_valid[i] = valid_in & !dividend_taken[i];
        end
    end
            
endmodule
