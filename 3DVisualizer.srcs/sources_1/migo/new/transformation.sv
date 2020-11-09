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


module transformation(
    input clk,
    input valid,
    input rst,
    input signed [11:0] scale,
    input signed [11:0] sin_in[3], cos_in[3]
    );
  parameter NUM_POINTS = 20;
  parameter POINT_WIDTH = 12;
  logic working;
  logic [$clog2(NUM_POINTS)-1:0] addr;
  logic signed [POINT_WIDTH-1:0] sin[3], cos[3];
  logic rot_valid, scale_valid, trans_valid, proj_valid;
  logic [3*POINT_WIDTH-1:0] point;
  logic signed [POINT_WIDTH-1:0] rot_in[3], scale_in[3], trans_in[3], proj_in[3];
  assign {>>{rot_in}} = point;
  assign rot_valid = valid;
  logic proj_ready;

  rotation #(.POINT_WIDTH(POINT_WIDTH)) u_rotation (.valid_in(rot_valid), .rot_out(scale_in), .valid_out(scale_valid), .*);
  scale #(.POINT_WIDTH(POINT_WIDTH)) u_scale (.valid_in(scale_valid), .scale_out(trans_in), .valid_out(trans_valid), .*);
  translation #(.POINT_WIDTH(POINT_WIDTH)) u_translate (.valid_in(trans_valid), .translation_in(trans_in), .valid_out(proj_valid), .*);
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
            rot_valid <= (addr == 19);
            addr <= (addr == 19 ? addr + 1 : addr);
        end
      end
   end
    
endmodule
