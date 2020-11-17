`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2020 03:28:38 AM
// Design Name: 
// Module Name: graphics_top
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


module graphics_top(
   input clk_100mhz,
   input btnc,
   input btnu,
   output logic[3:0] vga_r,
   output logic[3:0] vga_b,
   output logic[3:0] vga_g,
   output logic vga_hs,
   output logic vga_vs
    );
    logic clk_25mhz;
    logic locked;
    logic [9:0]hcount;
    logic [8:0]vcount;
    logic hsync;
    logic vsync;
    logic pixel_buf;
    logic blank;
    logic vsync_buf[3];
    logic vsync_converted;
    logic vsync_old;
    logic [13:0] point_coord[3];
    logic valid_point;
    logic [11:0] addr_wr;
    logic [11:0] addr_rd;
    logic write_en[2];
    logic delete;
    logic [11:0] addr_delete;
    logic [11:0] pixel_out[2];
    
    clk_wiz_0 clk_25 (.clk_out1(clk_25mhz), .reset(btnu), .locked(locked), .clk_in1(clk_100mhz));
    xvga u_xvga(.vclock_in(clk_25mhz),.hcount_out(hcount), .vcount_out(vcount), .vsync_out(vsync), .hsync_out(hsync), .blank_out(blank));
    transformation #(.POINT_WIDTH(12), .NUM_POINTS(20)) u_transformation (.clk(clk_100mhz), .valid(vsync_converted), .rst(btnu), .scale(1), .sin_in({12'b0, 12'b0, 12'b0}),
                                                      .cos_in({12'b0, 12'b0, 12'b0}), .point_out(point_coord), .valid_out(valid_point));
    blk_mem_gen_1 pixels0(.clka(clk_100mhz), .wea(write_en[0]), .addra(addr_wr), .dina(12'hfff), .douta(pixel_out[0]), .clkb(clk_25mhz), 
                          .web(write_en[0]), .addrb(addr_delete), .dinb('0));
                          
    blk_mem_gen_1 pixels1(.clka(clk_100mhz), .wea(write_en[1]), .addra(addr_wr), .dina(12'hfff), .douta(pixel_out[1]), .clkb(clk_25mhz), 
                          .web(write_en[1]), .addrb(addr_delete), .dinb('0));

    
    always_ff @(posedge clk_100mhz) begin
        if (btnu) begin
            pixel_buf <= '0;
            vsync_buf <= {1'b0,1'b0,1'b0};
        end else begin
            vsync_buf[0] <= vsync;
            vsync_buf[1] <= vsync_buf[0];
            vsync_buf[2] <= vsync_buf[1];
            vsync_old <= vsync_buf[2];
            vsync_converted <= vsync_buf[2] && !vsync_old;
        end
    end
endmodule
