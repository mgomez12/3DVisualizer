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


module transformation #(POINT_WIDTH = 12, NUM_POINTS=20, WIDTH=640, HEIGHT=480)(
    input clk,
    input valid,
    input rst,
    input signed [POINT_WIDTH-1:0] scale,
    input signed [POINT_WIDTH-1:0] sin_in[3], cos_in[3],
    output reg [$clog2(WIDTH)-1:0] point_out[3],
    output reg valid_out
    );
  logic signed [$clog2(WIDTH)-1:0] height = HEIGHT/2;
  logic signed [$clog2(WIDTH)-1:0] width = WIDTH/2;
  logic working;
  logic [$clog2(NUM_POINTS)-1:0] addr;
  logic signed [POINT_WIDTH-1:0] sin[3], cos[3];
  logic rot_valid, scale_valid, trans_valid, proj_valid, coord_valid;
  logic [3*POINT_WIDTH-1:0] point;
  logic signed [POINT_WIDTH-1:0] rot_in[3], scale_in[3], trans_in[3];
  logic signed [POINT_WIDTH+1:0] proj_in[3], coord_in[3];
  assign {>>{rot_in}} = point;
  wire proj_ready;
  logic  start_delay;
  logic [1:0] mem_delay;

  rotation #(.POINT_WIDTH(POINT_WIDTH)) u_rotation (.valid_in(rot_valid), .rot_out(scale_in), .valid_out(scale_valid), .*);
  scale #(.POINT_WIDTH(POINT_WIDTH)) u_scale (.valid_in(scale_valid), .scale_out(trans_in), .valid_out(trans_valid), .*);
  translation #(.POINT_WIDTH(POINT_WIDTH)) u_translate (.valid_in(trans_valid), .trans_out(proj_in), .valid_out(proj_valid), .*);
  projection #(.POINT_WIDTH(POINT_WIDTH +2)) u_projection (.valid_in(proj_valid), .proj_out(coord_in), .valid_out(coord_valid), .*);
  blk_mem_gen_0 points_mem (.clka(clk), .addra(addr), .douta(point));
/* synthesis syn_black_box black_box_pad_pin="clka,ena,addra[4:0],douta[35:0]" */;
  always_ff @(posedge clk) begin
      if (rst) begin
        sin <= '{default:0};
        cos <= '{default:0};
        addr <= NUM_POINTS-1;
        working <= 0;
        start_delay <= '0;
        mem_delay <= '0;
      end
      else begin
        if (valid && !working) begin
            working <= 1;
            addr <= 0;
            sin <= sin_in;
            cos <= cos_in;
            start_delay <= 0;
            mem_delay <= '0;
        end else if (working) begin
            if (start_delay ==0) begin
                start_delay <= 1;
            end
            if (mem_delay != 2) begin
                mem_delay <= mem_delay +1;
            end else if (addr == NUM_POINTS-1 && proj_ready) begin
                working <= 0;
            end else begin
                if (proj_ready) begin
                    addr <= addr + 1;
                    mem_delay <= 0;
                end
            end
         end
      end
    end
   
   logic signed [$clog2(WIDTH)+ POINT_WIDTH:0] coord_x;
   logic signed [$clog2(WIDTH)+ POINT_WIDTH:0] coord_y;
   always_comb begin
       rot_valid = (working && mem_delay == 2);
       coord_x = (coord_in[0] * width);
       coord_y = (coord_in[1] * height);
   end

    always_ff @(posedge clk) begin
        if (rst) begin
            point_out <= '{default:0};
            valid_out <= 0;
        end else begin
            point_out[0] <= (coord_x >> 13) + WIDTH/2;
            point_out[1] <= (coord_y >> 13) + HEIGHT/2;
            point_out[2] <= coord_in[2]>>4;
            valid_out <= coord_valid;
        end
    end
endmodule
