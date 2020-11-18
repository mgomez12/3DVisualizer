`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2020 04:03:44 PM
// Design Name: 
// Module Name: angle_gen
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


module angle_gen(
    input vsync,
    input clk,
    input rst,
    output [11:0] angles,
    output signed [11:0] sin_out[3], cos_out[3]
    );
    logic [11:0] out [3];
    logic signed [9:0] rate [3] = {10'd1, -10'd1, 10'd1};
    logic [11:0] final_in [3];
    logic signed [9:0] last[3];
    logic signed [9:0] in [3];
    logic [28:0] cordic_out[3];
    logic out_valid[3];
    assign angles = in[0];
    cordic_0 u_cordic0 (.aclk(clk), .s_axis_phase_tvalid(vsync), 
                        .s_axis_phase_tdata(final_in[0]), .m_axis_dout_tvalid(out_valid[0]), 
                        .m_axis_dout_tdata(cordic_out[0]));
    cordic_0 u_cordic1 (.aclk(clk), .s_axis_phase_tvalid(vsync), 
                        .s_axis_phase_tdata(final_in[1]), .m_axis_dout_tvalid(read), 
                        .m_axis_dout_tdata(cordic_out[1]));
    cordic_0 u_cordic2 (.aclk(clk), .s_axis_phase_tvalid(vsync), 
                        .s_axis_phase_tdata(final_in[2]), .m_axis_dout_tvalid(out_valid[2]), 
                        .m_axis_dout_tdata(cordic_out[2]));
    
    assign cos_out[0] = cordic_out[0][11:0];
    assign sin_out[0] = cordic_out[0][27:16];
    assign cos_out[1] = cordic_out[1][11:0];
    assign sin_out[1] = cordic_out[1][27:16];
    assign cos_out[2] = cordic_out[2][11:0];
    assign sin_out[2] = cordic_out[2][27:16];
    always_comb begin
        for (int i = 0; i < 3; i++) begin
            in[i] = last[i] + rate[i];
            final_in[i] = {in[i][9], in[i][9], in[i]};
        end
    end
  
    always_ff @(posedge clk) begin
        if (rst) begin
            last <= '{default:0};
        end else begin
            if (vsync) begin 
                for (int i = 0; i < 3; i++) last[i] <= in[i];
            end
        end
    end
endmodule
