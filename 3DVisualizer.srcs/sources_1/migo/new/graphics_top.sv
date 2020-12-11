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
   input btnd,
   output logic[3:0] vga_r,
   output logic[3:0] vga_b,
   output logic[3:0] vga_g,
   output logic vga_hs,
   output logic vga_vs,
   input beat
    );
    logic signed [11:0] scale;
    logic [12:0] color;
    logic pulse;
    logic [25:0] sample_beat;
    assign pulse = beat; //sample_beat == 26'd46875000;
    
    logic clk_25mhz;
    logic locked;
    logic [9:0]hcount;
    logic [8:0]vcount;
    logic hsync;
    logic vsync;
    
    logic blank;
    logic vsync_converted;
    
    
    logic [9:0] point_coord[3];
    logic valid_point;
    logic [11:0] addr_wr;
    logic [11:0] addr_rd;
    logic write;
    logic [1:0] write_en;
    logic delete_en[2];
    logic [11:0] addr_delete;
    logic [11:0] pixel_out[2];
    
    logic hsync_del[2];
    logic vsync_del[2];
    logic [11:0] pixel;
    
    logic begin_calculating;
    logic signed [11:0] sin[3], cos[3];
    
    signal_control u_control (.*);
    renderer u_renderer (.*);
    
   clk_wiz_0 clk_25 (.clk_out1(clk_25mhz), .reset(btnd), .locked(locked), .clk_in1(clk_100mhz));
    xvga u_xvga(.vclock_in(clk_25mhz),.hcount_out(hcount), .vcount_out(vcount), .vsync_out(vsync), .hsync_out(hsync), .blank_out(blank));
    transformation #(.POINT_WIDTH(12), .NUM_POINTS(300)) u_transformation (.clk(clk_100mhz), .valid(begin_calculating), .rst(btnd), .scale(scale), .sin_in(sin),
                   .cos_in(cos), .point_out(point_coord), .valid_out(valid_point));
    blk_mem_gen_1 pixels0(.clka(clk_100mhz), .wea(write_en[0]), .addra(addr_wr), .dina(color), .clkb(clk_25mhz), 
                          .web(delete_en[0]), .addrb(addr_delete), .dinb('0), .doutb(pixel_out[0]));
                          
    blk_mem_gen_1 pixels1(.clka(clk_100mhz), .wea(write_en[1]), .addra(addr_wr), .dina(color), .clkb(clk_25mhz), 
                          .web(delete_en[1]), .addrb(addr_delete), .dinb('0), .doutb(pixel_out[1]));
    parameter_gen u_param_gen(.scale_out(scale), .vsync(vsync_converted), .clk(clk_100mhz), .rst(btnd), .sin_out(sin), .cos_out(cos), .pulse(pulse));
    
    assign {vga_r, vga_g, vga_b} = pixel;
    
    always_ff @(posedge clk_100mhz) begin
        if (btnd) begin
            color <= 'hfff;
            sample_beat <= 0;
        end else begin
            sample_beat <= (pulse ? 0 : sample_beat + 1);
            if (pulse) begin
                case (color)
                    'hfff: color <= 'h00f;
                    'h00f: color <= 'h0ff;
                    'h0ff: color <= 'h0f0;
                    'h0f0: color <= 'hff0;
                    'hff0: color <= 'hf00;
                    'hf00: color <= 'hf0f;
                    'hf0f: color <= 'hfff;
                endcase
            end
        end
    end
endmodule

module renderer (
    input clk_25mhz,
    input btnd,
    input hsync,
    input vsync,
    input logic [11:0] pixel_out[2],
    output logic delete_en[2],
    input [9:0] hcount,
    input [8:0] vcount,
    output logic addr_delete,
    output logic vga_hs,
    output logic vga_vs,
    output logic pixel
    );
    
    logic [9:0] hcount_del[2];
    logic [8:0] vcount_del[2];
    logic hsync_del[2];
    logic vsync_del[2];

    always_comb begin
        delete_en[0] = vcount[2] == 0 && (hcount < 640 && vcount <480);
        delete_en[1] = vcount[2] == 1 && (hcount < 640 && vcount <480);
        addr_delete = vcount[1:0]*640 + hcount;
        pixel = (vcount_del[1][2] == 1'b1 ? pixel_out[1] : pixel_out[0]);
        vga_hs = hsync_del[1];
        vga_vs = vsync_del[1];
    end
    
    
    always_ff @(posedge clk_25mhz) begin
        if (btnd) begin
            hsync_del <= '{default:0};
            vsync_del <= '{default:0};
            vcount_del <= '{default:0};
            hcount_del <= '{default:0};
        end else begin
            hsync_del[0] <= hsync;
            hsync_del[1] <= hsync_del[0];
            vsync_del[0] <= vsync;
            vsync_del[1] <= vsync_del[0];
            vcount_del[0] <= vcount;
            vcount_del[1] <= vcount_del[0];
            hcount_del[0] <= hcount;
            hcount_del[1] <= hcount_del[0];
        end
    end
    
endmodule

module signal_control (
    input clk_100mhz,
    input btnd,
    input vsync,
    input hsync,
    output logic begin_calculating,
    input valid_point,
    input logic [9:0] point_coord[3],
    output logic write_en[2],
    output logic [11:0] addr_wr,
    output reg vsync_converted
    );
    logic vsync_old;
    logic hsync_buf[3];
    logic hsync_converted;
    logic hsync_old;
    logic [7:0] hcount_delay;
    logic [7:0] vcount_delay;
    logic [8:0] vcount_new;
    logic [8:0] last_row;
    logic pixel_buf;
    logic vsync_buf[3];
    logic write;
    
    always_comb begin
        write = valid_point && (point_coord[1][8:2] == (vcount_new[8:2] == 119 ? 0 : vcount_new[8:2] + 1));
        write_en[0] = write && vcount_new[2];
        write_en[1] = write && ~vcount_new[2];
        addr_wr = point_coord[1][1:0]*640+ point_coord[0];
        begin_calculating = (last_row != vcount_new) && vcount_new[1:0] == 2'b00;
    end

    always_ff @(posedge clk_100mhz) begin
        if (btnd) begin
            pixel_buf <= '0;
            vsync_buf <= {1'b0,1'b0,1'b0};
            hsync_buf <= {1'b0,1'b0,1'b0};
            vcount_new <= 0;
            hcount_delay <= 8'hff;
            vcount_delay <= 8'hff;
            vsync_converted <= 0;
            hsync_converted <= 0;
            hsync_old <= 0;
            vsync_old <= 0;
            last_row <= 0;
        end else begin
            last_row <= vcount_new;
            if (hsync_converted) vcount_new <= vcount_new + 1;
            if (vsync_converted) vcount_new <= 0;
        
        
            if (hcount_delay != 8'hff) hcount_delay <= hcount_delay + 1;
            if (vcount_delay != 8'hff) vcount_delay <= vcount_delay + 1;
            vsync_buf[0] <= vsync;
            vsync_buf[1] <= vsync_buf[0];
            vsync_buf[2] <= vsync_buf[1];
            vsync_old <= vsync_buf[2];
            if (!vsync_buf[2] && vsync_old && vcount_delay == 8'hff) begin
                vsync_converted <= 1;
                vcount_delay <= 0;
            end else vsync_converted <= 0;
            
            vsync_converted <= !vsync_buf[2] && vsync_old;
            hsync_buf[0] <= hsync;
            hsync_buf[1] <= hsync_buf[0];
            hsync_buf[2] <= hsync_buf[1];
            hsync_old <= hsync_buf[2];
            if (!hsync_buf[2] && hsync_old && hcount_delay == 8'hff) begin
                hsync_converted <= 1;
                hcount_delay <= 0;
            end else hsync_converted <= 0;
        end
    end
    
endmodule
