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
    input pulse,
    output [11:0] angles,
    output signed [11:0] sin_out[3], cos_out[3]
    );
    logic [11:0] out [3];
    logic signed [4:0] rate [3] = {5'd15, 5'd13, 5'd14};
    logic [13:0] final_in [3];
    logic signed [11:0] last[3];
    logic signed [11:0] in [3];
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
            in[i] = last[i] + {{7{rate[i][4]}}, rate[i]};
            final_in[i] = {in[i][11], in[i][11], in[i]};
        end
    end
  
    always_ff @(posedge clk) begin
        if (rst) begin
            last <= '{default:0};
            rate <= {5'd15, 5'd13, 5'd14};
        end else begin
            if (pulse) begin
                rate[0] <= -rate[0];
                rate[1] <= -rate[1];
//                case (rate[1])
//                    5'd15: rate[1] <= -5'd13;
//                   -5'd13: rate[1] <=  5'd14;
//                    5'd14: rate[1] <= -5'd12;
//                   -5'd12: rate[1] <=  5'd13;
//                    5'd13: rate[1] <= -5'd15;
//                   -5'd15: rate[1] <=  5'd12;
//                    5'd12: rate[1] <= -5'd14;
//                   -5'd14: rate[1] <=  5'd15;
//                endcase
            end
            if (vsync) begin 
                for (int i = 0; i < 3; i++) last[i] <= in[i];
            end
        end
    end
endmodule
