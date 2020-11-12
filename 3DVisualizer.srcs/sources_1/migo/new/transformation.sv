`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2020 02:01:14 PM
// Design Name: 
// Module Name: transformation
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


module transformation #(POINT_WIDTH = 12, NUM_POINTS=20)(
    input clk,
    input valid,
    input rst,
    input signed [POINT_WIDTH-1:0] scale,
    input signed [POINT_WIDTH-1:0] sin_in[3], cos_in[3],
    output signed [POINT_WIDTH+1:0] point_out[3],
    output valid_out
    );
  logic working;
  logic [$clog2(NUM_POINTS)-1:0] addr;
  logic signed [POINT_WIDTH-1:0] sin[3], cos[3];
  logic rot_valid, scale_valid, trans_valid, proj_valid;
  logic [3*POINT_WIDTH-1:0] point;
  logic signed [POINT_WIDTH-1:0] rot_in[3], scale_in[3], trans_in[3];
  logic signed [POINT_WIDTH+1:0] proj_in[3];
  assign {>>{rot_in}} = point;
  logic proj_ready;

  rotation #(.POINT_WIDTH(POINT_WIDTH)) u_rotation (.valid_in(rot_valid), .rot_out(scale_in), .valid_out(scale_valid), .*);
  scale #(.POINT_WIDTH(POINT_WIDTH)) u_scale (.valid_in(scale_valid), .scale_out(trans_in), .valid_out(trans_valid), .*);
  translation #(.POINT_WIDTH(POINT_WIDTH)) u_translate (.valid_in(trans_valid), .trans_out(proj_in), .valid_out(proj_valid), .*);
  projection #(.POINT_WIDTH(POINT_WIDTH +2)) u_projection (.valid_in(proj_valid),.proj_out(point_out), .*);
  blk_mem_gen_0 points_mem (.clka(clk), .addra(addr), .douta(point));
/* synthesis syn_black_box black_box_pad_pin="clka,ena,addra[4:0],douta[35:0]" */;
  always_ff @(posedge clk) begin
      if (rst) begin
        sin <= '{default:0};
        cos <= '{default:0};
        addr <= 19;
        rot_valid <= '0;
      end
      else begin
        if (valid && !working) begin
            working <= 1;
            sin <= sin_in;
            cos <= cos_in;
        end else begin
            if (addr == 19) begin
                rot_valid <= 0;
                working <= 0;
            end else begin
                rot_valid <= proj_ready;
                addr <= (proj_ready ? addr + 1 : addr);
            end
        end
      end
   end
    
endmodule
